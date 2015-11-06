FROM golang:1.5.1

RUN apt-get -yqq update

ADD ./cuberite_server /srv/cuberite_server
ADD ./world /srv/world
ADD start.sh /srv/start.sh
ADD ./go /go

RUN cd /go/src/goproxy; go install

CMD ["/bin/bash","/srv/start.sh"]
