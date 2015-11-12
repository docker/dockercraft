# Dockercraft
A simple Minecraft docker client, to visualize and run containers.

[![Dockercraft video](http://img.youtube.com/vi/eZDlJgJf55o/0.jpg)](http://www.youtube.com/watch?v=eZDlJgJf55o)

### Build the image:

```
docker build -t dockercraft .
```

### Run the container:

```
docker run -t -i -d -p 25565:25565 \
-v /var/run/docker.sock:/var/run/docker.sock \
--name dockercraft \
dockercraft
```

Mounting `/var/run/docker.sock` inside the container is necessary to send requests to the Docker remote API.


### How it works

The game itself remains unmodified. All operations are done server side. 

The Minecraft server we use is [http://cuberite.org](http://cuberite.org). A custom Minecraft compatible game server written in C++. [github repo](https://github.com/cuberite/cuberite)

This server accepts plugins, scripts written in LUA. So we did one for Docker. (world/Plugins/Docker)

Unfortunately, there's no nice API to communicate with these plugins. But there's a webadmin, and plugins can be responsible for "webtabs". 

```lua
Plugin:AddWebTab("Docker",HandleRequest_Docker)
```
Basically it means the plungin can catch POST requests sent to `http://127.0.0.1:8080/webadmin/Docker/Docker`. 

#### Goproxy

Events from the Docker remote API are transmitted to the LUA plugin by a small daemon (written in Go). (go/src/goproxy)

```go
func MCServerRequest(data url.Values, client *http.Client) {
	req, _ := http.NewRequest("POST", "http://127.0.0.1:8080/webadmin/Docker/Docker", strings.NewReader(data.Encode()))
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.SetBasicAuth("admin", "admin")
	client.Do(req)
}
```

The goproxy binary can also be executed with parameters from the LUA plugin, to send requests to the daemon:

```lua
function PlayerJoined(Player)
	-- refresh containers
	r = os.execute("goproxy containers")
end
```
