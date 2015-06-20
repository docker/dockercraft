FROM golang:1.3

RUN apt-get update
RUN apt-get install -y nano

RUN cd /srv; curl -s https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh | sh

ADD ./world /srv/world
ADD start.sh /srv/start.sh

CMD ["/bin/bash","/srv/start.sh"]
