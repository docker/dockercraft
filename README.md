# minecraft-docker-client
A simple Minecraft docker client, to visualize and run containers.

Build the image:

```
docker build -t mcclient .
```

Run the container:

```
docker run -t -i --rm -p 25565:25565 -p 8080:8080  --name mcclient mcclient
```

MCServer has no proper Rest API.
Look for Docker plugin responses inside HTML repsonses:

```
wget -q  -O- \
--post-data="action=startContainer&name=test&imageRepo=test&imageTag=latest" \
--http-user=admin --http-password=admin \
127.0.0.1:8080/webadmin/Docker/Docker \
| grep '\[dockerclient\]' \
| sed -E 's/.*\[dockerclient\](.*)\[\/dockerclient\].*/\1/'
```

### Requests

**Start a container**

This will display a running container in the Minecraft world.

- POST data:
	- action=startContainer
	- name=[CONTAINER NAME] 
	- imageRepo=[IMAGE REPO]
	- imageTag=[IMAGE TAG]

