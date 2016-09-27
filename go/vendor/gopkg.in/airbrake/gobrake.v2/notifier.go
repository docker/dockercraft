package gobrake // import "gopkg.in/airbrake/gobrake.v2"

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"net/http"
	"os"
	"runtime"
	"sync"
	"time"
)

const defaultAirbrakeHost = "https://airbrake.io"

const statusTooManyRequests = 429

var (
	errClosed      = errors.New("gobrake: notifier is closed")
	errRateLimited = errors.New("gobrake: you are rate limited")
)

var httpClient = &http.Client{
	Transport: &http.Transport{
		Proxy: http.ProxyFromEnvironment,
		Dial: (&net.Dialer{
			Timeout:   15 * time.Second,
			KeepAlive: 30 * time.Second,
		}).Dial,
		TLSHandshakeTimeout: 10 * time.Second,
		TLSClientConfig: &tls.Config{
			ClientSessionCache: tls.NewLRUClientSessionCache(1024),
		},
		MaxIdleConnsPerHost:   10,
		ResponseHeaderTimeout: 10 * time.Second,
	},
	Timeout: 10 * time.Second,
}

var buffers = sync.Pool{
	New: func() interface{} {
		return new(bytes.Buffer)
	},
}

type filter func(*Notice) *Notice

type Notifier struct {
	// http.Client that is used to interact with Airbrake API.
	Client *http.Client

	projectId       int64
	projectKey      string
	createNoticeURL string

	context map[string]string
	filters []filter

	wg       sync.WaitGroup
	noticeCh chan *Notice
	closed   chan struct{}
}

func NewNotifier(projectId int64, projectKey string) *Notifier {
	n := &Notifier{
		projectId:       projectId,
		projectKey:      projectKey,
		createNoticeURL: getCreateNoticeURL(defaultAirbrakeHost, projectId, projectKey),

		Client: httpClient,

		context: map[string]string{
			"language":     runtime.Version(),
			"os":           runtime.GOOS,
			"architecture": runtime.GOARCH,
		},

		noticeCh: make(chan *Notice, 1000),
		closed:   make(chan struct{}),
	}
	if hostname, err := os.Hostname(); err == nil {
		n.context["hostname"] = hostname
	}
	if wd, err := os.Getwd(); err == nil {
		n.context["rootDirectory"] = wd
	}
	for i := 0; i < 10; i++ {
		go n.worker()
	}
	return n
}

// Sets Airbrake host name. Default is https://airbrake.io.
func (n *Notifier) SetHost(h string) {
	n.createNoticeURL = getCreateNoticeURL(h, n.projectId, n.projectKey)
}

// AddFilter adds filter that can modify or ignore notice.
func (n *Notifier) AddFilter(fn filter) {
	n.filters = append(n.filters, fn)
}

// Notify notifies Airbrake about the error.
func (n *Notifier) Notify(e interface{}, req *http.Request) {
	notice := n.Notice(e, req, 1)
	n.SendNoticeAsync(notice)
}

// Notice returns Aibrake notice created from error and request. depth
// determines which call frame to use when constructing backtrace.
func (n *Notifier) Notice(err interface{}, req *http.Request, depth int) *Notice {
	notice := NewNotice(err, req, depth+3)
	for k, v := range n.context {
		notice.Context[k] = v
	}
	return notice
}

type sendResponse struct {
	Id string `json:"id"`
}

// SendNotice sends notice to Airbrake.
func (n *Notifier) SendNotice(notice *Notice) (string, error) {
	for _, fn := range n.filters {
		notice = fn(notice)
		if notice == nil {
			// Notice is ignored.
			return "", nil
		}
	}

	buf := buffers.Get().(*bytes.Buffer)
	defer buffers.Put(buf)

	buf.Reset()
	if err := json.NewEncoder(buf).Encode(notice); err != nil {
		return "", err
	}

	resp, err := n.Client.Post(n.createNoticeURL, "application/json", buf)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	buf.Reset()
	_, err = buf.ReadFrom(resp.Body)
	if err != nil {
		return "", err
	}

	if resp.StatusCode != http.StatusCreated {
		if resp.StatusCode == statusTooManyRequests {
			return "", errRateLimited
		}
		err := fmt.Errorf("gobrake: got response code=%d, wanted 201 CREATED", resp.StatusCode)
		return "", err
	}

	var sendResp sendResponse
	err = json.NewDecoder(buf).Decode(&sendResp)
	if err != nil {
		return "", err
	}

	return sendResp.Id, nil
}

// SendNoticeAsync acts as SendNotice, but sends notice asynchronously
// and pending notices can be flushed with Flush.
func (n *Notifier) SendNoticeAsync(notice *Notice) {
	n.wg.Add(1)
	select {
	case n.noticeCh <- notice:
	default:
		n.wg.Done()
		logger.Printf(
			"notice=%q is ignored, because queue is full (len=%d)",
			notice, len(n.noticeCh),
		)
	}
}

func (n *Notifier) worker() {
	for {
		select {
		case notice := <-n.noticeCh:
			if _, err := n.SendNotice(notice); err != nil && err != errRateLimited {
				logger.Printf("gobrake failed reporting notice=%q: error=%q", notice, err)
			}
			n.wg.Done()
		case <-n.closed:
			return
		}
	}
}

// NotifyOnPanic notifies Airbrake about the panic and should be used
// with defer statement.
func (n *Notifier) NotifyOnPanic() {
	if v := recover(); v != nil {
		notice := n.Notice(v, nil, 3)
		n.SendNotice(notice)
		panic(v)
	}
}

// Flush does nothing.
//
// Deprecated. Use CloseAndWait instead.
func (n *Notifier) Flush() {}

// WaitAndClose waits for pending requests to finish and then closes the notifier.
func (n *Notifier) WaitAndClose(timeout time.Duration) error {
	done := make(chan struct{})
	go func() {
		n.wg.Wait()
		close(done)
	}()
	select {
	case <-done:
	case <-time.After(timeout):
	}

	close(n.closed)
	return nil
}

func getCreateNoticeURL(host string, projectId int64, key string) string {
	return fmt.Sprintf(
		"%s/api/v3/projects/%d/notices?key=%s",
		host, projectId, key,
	)
}
