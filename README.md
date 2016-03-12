# Openstackcraft

Minecraft OpenStack client.

This project is rehash of [DockerCraft](https://github.com/docker/dockercraft).
Many codes are brought from DockerCraft. 

## How to run
1. **Install Minecraft: [minecraft.net](https://minecraft.net)**

	The Minecraft client hasn't been modified, just get the official release.
	
  > NOTE: Current Cuberite (Minecraft server) does not support version 1.9.0+.
  > Please edit profile when launch minecraft client as following.
  
  ![openstackcraft](../master/docs/img/edit_profile.png?raw=true)

2. **Clone repo:**
  ```
  git clone https://github.com/nyasukun/openstackcraft.git
  ```

3. **Prepare OpenStack RC file:**
  Download OpenStack RC file from your OpenStack server.
  Put RC file under openstackcraft directory. (ex. openstackcraft/my-openstackrc.sh)
  
  RC file name must end with "-openstackrc.sh"
  
  > NOTE: RC file should include following variables.
  > * OS_USERNAME
  > * OS_PASSWORD
  > * OS_TENANT_NAME
  > * OS_AUTH_URL

4. **Build docker image contains openstackcraft:**
  ```
  sudo docker build -t openstackcraft openstackcraft/
  ```

5. **Run Openstackcraft container
  ```
  sudo docker run -t -i -p 25565:25565 openstackcraft
  ```

6. **Open Minecraft > Multiplayer > Add Server**

	The server address is the IP of Docker host. No need to specify a port if you used the default one.

7. **Join Server!**

  To create server isnatnce:
    execute following command.

    ```
    /nova create name cirros m1.tiny
    ```


  
