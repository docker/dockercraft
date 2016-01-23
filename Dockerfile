FROM python:2.7

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

# Download Cuberite server (Minecraft C++ server)
# and load up a special empty world for Dockercraft
RUN sh -c "$(wget -qO - https://raw.githubusercontent.com/cuberite/cuberite/master/easyinstall.sh)" && mv Server cuberite_server

COPY . /usr/src/app


CMD ["/bin/bash", "start.sh"]
