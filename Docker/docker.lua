----------------------------------------
-- GLOBALS
----------------------------------------

-- queue containing the updates that need to be applied to the minecraft world
UpdateQueue = nil
-- array of container objects
Containers = {}
--
SignsToUpdate = {}
-- as a lua array cannot contain nil values, we store references to this object
-- in the "Containers" array to indicate that there is no container at an index
EmptyContainerSpace = {}

----------------------------------------
-- FUNCTIONS
----------------------------------------

-- Tick is triggered by cPluginManager.HOOK_TICK
function Tick(TimeDelta)
  UpdateQueue:update(MAX_BLOCK_UPDATE_PER_TICK)
end

-- Plugin initialization
function Initialize(Plugin)
  Plugin:SetName("Docker")
  Plugin:SetVersion(1)

  UpdateQueue = NewUpdateQueue()

  -- Hooks

  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, PlayerUsingBlock);
  cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_FOOD_LEVEL_CHANGE, OnPlayerFoodLevelChange);
  cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
  cPluginManager:AddHook(cPluginManager.HOOK_WEATHER_CHANGING, OnWeatherChanging);
  cPluginManager:AddHook(cPluginManager.HOOK_SERVER_PING, OnServerPing);
  cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick);

  -- Command Bindings

  cPluginManager.BindCommand("/docker", "*", DockerCommand, " - docker CLI commands")

  -- make all players admin
  cRankManager:SetDefaultRank("Admin")

  cNetwork:Connect("127.0.0.1",25566,TCP_CLIENT)

  LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

  return true
end

-- updateStats update CPU and memory usage displayed
-- on container sign (container identified by id)
function updateStats(id, mem, cpu)
  for i=1, table.getn(Containers)
  do
    if Containers[i] ~= EmptyContainerSpace and Containers[i].id == id
    then
      Containers[i]:updateMemSign(mem)
      Containers[i]:updateCPUSign(cpu)
      break
    end
  end
end

-- getStartStopLeverContainer returns the container
-- id that corresponds to lever at x,y coordinates
function getStartStopLeverContainer(x, z)
  for i=1, table.getn(Containers)
  do
    if Containers[i] ~= EmptyContainerSpace and x == Containers[i].x + 1 and z == Containers[i].z + 1
    then
      return Containers[i].id
    end
  end
  return ""
end

-- getRemoveButtonContainer returns the container
-- id and state for the button at x,y coordinates
function getRemoveButtonContainer(x, z)
  for i=1, table.getn(Containers)
  do
    if Containers[i] ~= EmptyContainerSpace and x == Containers[i].x + 2 and z == Containers[i].z + 3
    then
      return Containers[i].id, Containers[i].running
    end
  end
  return "", true
end

-- destroyContainer looks for the first container having the given id,
-- removes it from the Minecraft world and from the 'Containers' array
function destroyContainer(id)
  LOG("destroyContainer: " .. id)
  -- loop over the containers and remove the first having the given id
  for i=1, table.getn(Containers)
  do
    if Containers[i] ~= EmptyContainerSpace and Containers[i].id == id
    then
      -- remove the container from the world
      Containers[i]:destroy()
      -- if the container being removed is the last element of the array
      -- we reduce the size of the "Container" array, but if it is not,
      -- we store a reference to the "EmptyContainerSpace" object at the
      -- same index to indicate this is a free space now.
      -- We use a reference to this object because it is not possible to
      -- have 'nil' values in the middle of a lua array.
      if i == table.getn(Containers)
      then
        table.remove(Containers, i)
        -- we have removed the last element of the array. If the array
        -- has tailing empty container spaces, we remove them as well.
        while Containers[table.getn(Containers)] == EmptyContainerSpace
        do
          table.remove(Containers, table.getn(Containers))
        end
      else
        Containers[i] = EmptyContainerSpace
      end
      -- we removed the container, we can exit the loop
      break
    end
  end
end

-- updateContainer accepts 3 different states: running, stopped, created
-- sometimes "start" events arrive before "create" ones
-- in this case, we just ignore the update
function updateContainer(id,name,imageRepo,imageTag,state)
  LOG("Update container with ID: " .. id .. " state: " .. state)

  -- first pass, to see if the container is
  -- already displayed (maybe with another state)
  for i=1, table.getn(Containers)
  do
    -- if container found with same ID, we update it
    if Containers[i] ~= EmptyContainerSpace and Containers[i].id == id
    then
      Containers[i]:setInfos(id,name,imageRepo,imageTag,state == CONTAINER_RUNNING)
      Containers[i]:display(state == CONTAINER_RUNNING)
      LOG("found. updated. now return")
      return
    end
  end

  -- if container isn't already displayed, we see if there's an empty space
  -- in the world to display the container
  local x = CONTAINER_START_X
  local index = -1

  for i=1, table.getn(Containers)
  do
    -- use first empty location
    if Containers[i] == EmptyContainerSpace
    then
      LOG("Found empty location: Containers[" .. tostring(i) .. "]")
      index = i
      break
    end
    x = x + CONTAINER_OFFSET_X
  end

  local container = NewContainer()
  container:init(x,CONTAINER_START_Z)
  container:setInfos(id,name,imageRepo,imageTag,state == CONTAINER_RUNNING)
  container:addGround()
  container:display(state == CONTAINER_RUNNING)

  if index == -1
  then
    table.insert(Containers, container)
  else
    Containers[index] = container
  end

  -- update hack
  -- when new containers are started, all old containers dissappear
  -- they're still running, but for some reason stop being displayed until they're updated
  -- this forces them to re-render in world
  LOG("New container detected: Refreshing all...")
  for i=1, table.getn(Containers)
  do
    LOG("Refreshing container '" .. Containers[i].name .. "'")

    -- Display
    Containers[i]:display(Containers[i].running)

    -- YES WE NEED TO DO IT TWICE
    -- The signs don't display correctly on first re-render
    -- Do it again to make signs work
    -- Look don't ask me why, but it works so ¯\_(ツ)_/¯
    Containers[i]:display(Containers[i].running)
  end
end

--
function PlayerJoined(Player)
  -- enable flying
  Player:SetCanFly(true)
  LOG("player joined")
end

--
function PlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
  LOG("Using block: " .. tostring(BlockX) .. "," .. tostring(BlockY) .. "," .. tostring(BlockZ) .. " - " .. tostring(BlockType) .. " - " .. tostring(BlockMeta))

  -- lever: 1->OFF 9->ON (in that orientation)
  -- lever
  if BlockType == 69
  then
    local containerID = getStartStopLeverContainer(BlockX,BlockZ)
    LOG("Using lever associated with container ID: " .. containerID)

    if containerID ~= ""
    then
      -- stop
      if BlockMeta == 1
      then
        Player:SendMessage("docker stop " .. string.sub(containerID,1,8))
        SendTCPMessage("docker",{"stop",containerID},0)
        -- start
      else
        Player:SendMessage("docker start " .. string.sub(containerID,1,8))
        SendTCPMessage("docker",{"start",containerID},0)
      end
    else
      LOG("WARNING: no docker container ID attached to this lever")
    end
  end

  -- stone button
  if BlockType == 77
  then
    local containerID, running = getRemoveButtonContainer(BlockX,BlockZ)

    if running
    then
      Player:SendMessage("A running container can't be removed.")
    else
      Player:SendMessage("docker rm " .. string.sub(containerID,1,8))
      SendTCPMessage("docker",{"rm",containerID},0)
    end
  end
end


function DockerCommand(Split, Player)
  if table.getn(Split) > 0
  then

    LOG("Split[1]: " .. Split[1])

    if Split[1] == "/docker"
    then
      if table.getn(Split) > 1
      then
        if Split[2] == "pull" or Split[2] == "create" or Split[2] == "run" or Split[2] == "stop" or Split[2] == "rm" or Split[2] == "rmi" or Split[2] == "start" or Split[2] == "kill"
        then
          -- force detach when running a container
          if Split[2] == "run"
          then
            table.insert(Split,3,"-d")
          end
          table.remove(Split,1)
          SendTCPMessage("docker",Split,0)
        end
      end
    end
  end

  return true
end


function OnPlayerFoodLevelChange(Player, NewFoodLevel)
  -- Don't allow the player to get hungry
  return true, Player, NewFoodLevel
end

function OnTakeDamage(Receiver, TDI)
  -- Don't allow the player to take falling or explosion damage
  if Receiver:GetClass() == 'cPlayer'
  then
    if TDI.DamageType == dtFall or TDI.DamageType == dtExplosion then
      return true, Receiver, TDI
    end
  end
  return false, Receiver, TDI
end

function OnServerPing(ClientHandle, ServerDescription, OnlinePlayers, MaxPlayers, Favicon)
  -- Change Server Description
  local serverDescription = "A Docker client for Minecraft"
  -- Change favicon
  if cFile:IsFile("/srv/logo.png") then
    local FaviconData = cFile:ReadWholeFile("/srv/logo.png")
    if (FaviconData ~= "") and (FaviconData ~= nil) then
      Favicon = Base64Encode(FaviconData)
    end
  end
  return false, serverDescription, OnlinePlayers, MaxPlayers, Favicon
end

-- Make it sunny all the time!
function OnWeatherChanging(World, Weather)
  return true, wSunny
end
