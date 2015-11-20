# Dockercraft

![Dockercraft](../master/docs/img/logo.png?raw=true)

A simple Minecraft Docker client, to visualize and manage Docker containers.

![Dockercraft](../master/docs/img/dockercraft.gif?raw=true)

[YouTube video](http://www.youtube.com/watch?v=eZDlJgJf55o)

## How to run Dockercraft

1. **Install Minecraft: [minecraft.net](https://minecraft.net)**

	The Minecraft client hasn't been modified, just get the official release.

2. **Pull or build Dockercraft image:** (an offical image will be available soon)

	```
	docker pull gaetan/dockercraft
	```
	or

	```
	git clone git@github.com:docker/dockercraft.git
	docker build -t gaetan/dockercraft dockercraft
	```
3. **Run Dockercraft container:**

	```
	docker run -t -i -d -p 25565:25565 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /usr/local/bin/docker:/usr/local/bin/docker \
	--name dockercraft \
	gaetan/dockercraft
	```

	Mounting `/var/run/docker.sock` inside the container is necessary to send requests to the Docker remote API.

	The default port for a Minecraft server is *25565*, if you prefer a different one: `-p <port>:25565`

4. **Open Minecraft > Multiplayer > Add Server**

	The server address is the IP of Docker host. No need to specify a port if you used the default one.

	If you're using [Docker Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

5. **Join Server!**

	You should see at least one container in your world, which is the one hosting your Dockercraft server.

	You can start, stop and remove containers interacting with levers and buttons. Some Docker commands are also supported directly via Minecraft's chat window, which is displayed by pressing the `T` key (default) or `/` key.

![Dockercraft](../master/docs/img/landscape.png?raw=true)

## How it works

The Minecraft client itself remains unmodified. All operations are done server side.

The Minecraft server we use is [http://cuberite.org](http://cuberite.org). A custom Minecraft compatible game server written in C++. [github repo](https://github.com/cuberite/cuberite)

This server accepts plugins, scripts written in Lua. So we did one for Docker. (world/Plugins/Docker)

Unfortunately, there's no nice API to communicate with these plugins. But there's a webadmin, and plugins can be responsible for "webtabs".

```lua
Plugin:AddWebTab("Docker",HandleRequest_Docker)
```
Basically it means the plungin can catch POST requests sent to `http://127.0.0.1:8080/webadmin/Docker/Docker`.

### Goproxy

Events from the Docker remote API are transmitted to the Lua plugin by a small daemon (written in Go). (go/src/goproxy)

```go
func MCServerRequest(data url.Values, client *http.Client) {
	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)
}
```

The goproxy binary can also be executed with parameters from the Lua plugin, to send requests to the daemon:

```lua
function PlayerJoined(Player)
	-- refresh containers
	r = os.execute("goproxy containers")
end
```
## Contributing

Want to hack on Dockercraft? [Docker's contributions guidelines](https://github.com/docker/docker/blob/master/CONTRIBUTING.md) apply.

![Dockercraft](../master/docs/img/contribute.png?raw=true)
