# minecraft-docker-client
A simple Minecraft docker client, to visualize and run containers.

### Build the image:

```
docker build -t mcclient .
```

### Run the container:

```
docker run -t -i --rm -p 25565:25565 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/local/bin/docker:/usr/local/bin/docker \
--name mcclient mcclient
```

Mounting `/var/run/docker.sock` inside the container is necessary to send requests to the Docker remote API.

Mounting `/usr/local/bin/docker` inside the container is necessary to bind Minecraft commands to Docker CLI commands.



