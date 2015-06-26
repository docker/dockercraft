FROM golang:1.3

RUN apt-get update

RUN cd /srv; curl -s https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh | sh

ADD ./world /srv/world
ADD start.sh /srv/start.sh

ADD ./go /go
RUN cd /go/src/goproxy; go build

CMD ["/bin/bash","/srv/start.sh"]
