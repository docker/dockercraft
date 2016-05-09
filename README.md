# Dockercraft

![Dockercraft](../master/docs/img/logo.png?raw=true)

A simple Minecraft Docker client, to visualize and manage Docker containers.

![Dockercraft](../master/docs/img/dockercraft.gif?raw=true)

[YouTube video](http://www.youtube.com/watch?v=eZDlJgJf55o)

> WARNING: Please use Dockercraft on your local machine only.
> It currently doesn't support authentication.
> Every player should be considered a root user! 

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
	--name dockercraft \
	gaetan/dockercraft
	```

	You must mount one or both of the following:
	  
            -  `/var/run/docker.sock` for a local docker instance
	    -  `~/.docker/machine/machines` for your docker machines!

	Please do not mount BOTH where `/var/run/docker.sock` is located on a machine managed by docker machine.
	Bad things may happen! In this case there will be a "local" and "<machine_name>" world both subscribed to
        events from the same daemon.

	The default port for a Minecraft server is *25565*, if you prefer a different one: `-p <port>:25565`

4. **Open Minecraft > Multiplayer > Add Server**

	The server address is the IP of Docker host. No need to specify a port if you used the default one.

	If you're using [Docker Machine](https://docs.docker.com/machine/install-machine/): `docker-machine ip <machine_name>`

5. **Join Server!**

	You should see at least one container in your world, which is the one hosting your Dockercraft server.

	You can start, stop and remove containers interacting with levers and buttons. Some Docker commands are also supported directly via Minecraft's chat window, which is displayed by pressing the `T` key (default) or `/` key.
	
> A command always starts with a `/`.
> 
> If you open the prompt using the `/` key, it will be prefilled with a `/` character, but if you open it with the `T` key, it will not be prefilled and you will have to type a `/` yourself before typing your docker command.
> 
> example: `/docker run redis`.

![Dockercraft](../master/docs/img/landscape.png?raw=true)

## (Experimental) Docker Machine support

If you mount the `~/.docker/machine/machines` directory, Dockercraft will attempt to manage your machines for you. This has only been tested with Docker Machine version 0.7.0.

When you log in, you will be placed in the default world. The criteria for selecting this are as follows:

- `local` world if you've also mounted `/var/run/docker.sock`
- `default` world if you have a machine called `default`
- the first world discovered by docker-machine in alphabetical order

To view all available worlds, use the `/worlds` command from within your minecraft client

To portal to another world, `/portal <world>`.
For example, to portal to the default world I would `/portal default`

## Upcoming features

This is just the beginning for Dockercraft! We should be able to support a lot more Docker features like:

- Support more Docker commands
- Display [logs](https://docs.docker.com/v1.8/reference/commandline/logs/) (for each container, pushing a simple button)
- Represent links
- Docker networking
- Docker volumes
- ...

If you're interested about Dockercraft's design, discussions happen in [that issue](https://github.com/docker/dockercraft/issues/19).
Also, we're using [Magicavoxel](https://voxel.codeplex.com) to do these nice prototypes:

![Dockercraft](../master/docs/img/voxelproto.jpg?raw=true)

You can find our Magicavoxel patterns in [that folder](![Dockercraft](https://github.com/docker/dockercraft/tree/master/docs/magicavoxel)).

To get fresh news, follow our Twitter account: [@dockercraft](https://twitter.com/dockercraft).

## How it works

The Minecraft client itself remains unmodified. All operations are done server side.

The Minecraft server we use is [http://cuberite.org](http://cuberite.org). A custom Minecraft compatible game server written in C++. [github repo](https://github.com/cuberite/cuberite)

This server accepts plugins, scripts written in Lua. So we did one for Docker. (world/Plugins/Docker)

Unfortunately, there's no nice API to communicate with these plugins. But there's a webadmin, and plugins can be responsible for "webtabs".

```lua
Plugin:AddWebTab("Docker",HandleRequest_Docker)
```

Basically it means the plugin can catch POST requests sent to `http://127.0.0.1:8080/webadmin/Docker/Docker`.

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
