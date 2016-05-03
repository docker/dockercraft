package logrus

import (
	"encoding/json"
	"fmt"
	"time"
)

type JSONFormatter struct{}

func (f *JSONFormatter) Format(entry *Entry) ([]byte, error) {
	data := make(Fields, len(entry.Data)+3)
	for k, v := range entry.Data {
		data[k] = v
	}
	prefixFieldClashes(data)
	data["time"] = entry.Time.Format(time.RFC3339)
	data["msg"] = entry.Message
	data["level"] = entry.Level.String()

	serialized, err := json.Marshal(data)
	if err != nil {
		return nil, fmt.Errorf("Failed to marshal fields to JSON, %v", err)
	}
	return append(serialized, '\n'), nil
}
