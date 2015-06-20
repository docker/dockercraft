FROM golang:1.3

RUN apt-get update

RUN cd /srv; curl -s https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh | sh

ADD start.sh /srv/start.sh
CMD ["/bin/bash","/srv/start.sh"]
