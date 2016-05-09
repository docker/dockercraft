PLUGIN = nil

-- Worlds table
Worlds = {}

-- Plugin initialization
function Initialize(Plugin)
    Plugin:SetName("Docker")
    Plugin:SetVersion(1)

    -- Register Commands
    dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
    RegisterPluginInfoCommands()

    -- Hooks
    cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, OnWorldStarted);
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined);
    cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_CHANGING_WORLD, OnEntityChangingWorld);
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, OnPlayerUsingBlock);
    cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating);
    cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_FOOD_LEVEL_CHANGE, OnPlayerFoodLevelChange);
    cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
    cPluginManager:AddHook(cPluginManager.HOOK_WEATHER_CHANGING, OnWeatherChanging);
    cPluginManager:AddHook(cPluginManager.HOOK_SERVER_PING, OnServerPing);
    cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick);

    -- Add WebAdmin Tab
    Plugin:AddWebTab("Docker",HandleRequest_Docker)

    -- make all players admin
    cRankManager:SetDefaultRank("Admin")

    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    return true
end

-- OnWorldTick processes the updateQueue of each World
function OnWorldTick(World, TimeDelta)
    local name = World:GetName()
    if name == nil then
        return
    end
    if Worlds[name] == nil then
        return
    end
    Worlds[name].updateQueue:update(MAX_BLOCK_UPDATE_PER_TICK)
end


-- OnWorldStarted creates a new World object for every Dockercraft world
-- and gets the state of the containers
function OnWorldStarted(World)
    local name = World:GetName()
    Worlds[name] = NewWorld(name)
    local y = GROUND_LEVEL
    -- just enough to fit one container
    -- then it should be dynamic
    for x = GROUND_MIN_X, GROUND_MAX_X do
        for z=GROUND_MIN_Z,GROUND_MAX_Z do
            Worlds[name]:setBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
        end
    end

    local r = os.execute("dockercraft containers?world=" .. name)
    LOG("executed: dockercraft containers?world=" .. name .. " -> " .. tostring(r))
end

-- OnEntityChangedWorld
function OnEntityChangingWorld(Entity, World)
    if Entity:IsPlayer() then
        local name = World:GetName()
        local r = os.execute("dockercraft containers?world=" .. name)
        LOG("executed: dockercraft containers?world=" .. name .. " -> " .. tostring(r))
    end
end

-- OnPlayerJoined
function OnPlayerJoined(Player)
    -- enable flying
    Player:SetCanFly(true)
end

-- OnPlayerUsingBlock
function OnPlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
    LOG("Using block: " .. tostring(BlockX) .. "," .. tostring(BlockY) .. "," .. tostring(BlockZ) .. " - " .. tostring(BlockType) .. " - " .. tostring(BlockMeta))

    -- get world
    local w = Player:GetWorld():GetName()
    local world = Worlds[w]

    -- lever: 1->OFF 9->ON (in that orientation)
    -- lever
    if BlockType == 69 then
        local containerID = world:getStartStopLeverContainer(BlockX,BlockZ)
        LOG("Using lever associated with container ID: " .. containerID)

        if containerID ~= "" then
            -- stop
            if BlockMeta == 1 then
                Player:SendMessage("docker stop " .. string.sub(containerID,1,8))
                local r = os.execute("dockercraft exec?world=" .. w .. "\\&cmd=docker+stop+" .. containerID)
                LOG("executed: dockercraft exec?world=" .. w .. "\\&cmd=docker+stop+" .. containerID .. " -> " .. tostring(r))
                -- start
            else
                Player:SendMessage("docker start " .. string.sub(containerID,1,8))
                local r = os.execute("dockercraft exec?world=" .. w .. "\\&cmd=docker+start+" .. containerID)
                LOG("executed: dockercraft exec?world=" .. w .. "\\&cmd=docker+start+" .. containerID .. " -> " .. tostring(r))
            end
        else
            LOG("WARNING: no docker container ID attached to this lever")
        end
    end

    -- stone button
    if BlockType == 77 then
        local containerID, running = world:getRemoveButtonContainer(BlockX,BlockZ)

        if running then
            Player:SendMessage("A running container can't be removed.")
        else
            Player:SendMessage("docker rm " .. string.sub(containerID,1,8))
            r = os.execute("dockercraft exec?world=" .. w .. "\\&cmd=docker+rm+" .. containerID)
            LOG("executed: dockercraft exec?world=" .. w .. "\\&cmd=docker+rm+" .. containerID .. " -> " .. tostring(r))
        end
    end
end

-- OnChunkGenerating overrides the built-in chunk generator
-- to have it generate empty chunks only
function OnChunkGenerating(World, ChunkX, ChunkZ, ChunkDesc)
    ChunkDesc:SetUseDefaultBiomes(false)
    ChunkDesc:SetUseDefaultComposition(false)
    ChunkDesc:SetUseDefaultFinish(false)
    ChunkDesc:SetUseDefaultHeight(false)
    return true
end

-- DockerCommand handles /docker commands entered by the player
function DockerCommand(Split, Player)

    -- get world name
    local world = Player:GetWorld():GetName()

    if table.getn(Split) > 0 then
        LOG("Split[1]: " .. Split[1])

        if Split[1] == "/docker" then
            if table.getn(Split) > 1 then
                if Split[2] == "pull" or Split[2] == "create" or Split[2] == "run" or Split[2] == "stop" or Split[2] == "rm" or Split[2] == "rmi" or Split[2] == "start" or Split[2] == "kill" then
                    -- force detach when running a container
                    if Split[2] == "run" then
                        table.insert(Split,3,"-d")
                    end

                    local EntireCommand = table.concat(Split, "+")
                    -- remove '/' at the beginning
                    local command = string.sub(EntireCommand, 2, -1)

                    r = os.execute("dockercraft exec?world=" .. world .. "\\&cmd=" .. command)
                    LOG("executed: " .. command .. " -> " .. tostring(r))
                end
            end
        end
    end

    return true
end

-- OnPlayerFoodLevelChange stops the player from getting hungry
function OnPlayerFoodLevelChange(Player, NewFoodLevel)
    return true, Player, NewFoodLevel
end

-- OnTakeDamage stops the player receiving falling or explosion damage
function OnTakeDamage(Receiver, TDI)
    if Receiver:GetClass() == 'cPlayer' then
        if TDI.DamageType == dtFall or TDI.DamageType == dtExplosion then
            return true, Receiver, TDI
        end
    end
    return false, Receiver, TDI
end

-- OnServerPing provides a nice favicon and description for Dockercraft
function OnServerPing(ClientHandle, ServerDescription, OnlinePlayers, MaxPlayers, Favicon)
    -- Change Server Description
    local ServerDescription = "A Docker client for Minecraft"
    -- Change favicon
    if cFile:IsFile("/srv/logo.png") then
        local FaviconData = cFile:ReadWholeFile("/srv/logo.png")
        if (FaviconData ~= "") and (FaviconData ~= nil) then
            Favicon = Base64Encode(FaviconData)
        end
    end
    return false, ServerDescription, OnlinePlayers, MaxPlayers, Favicon
end

-- OnWeatherChanging makes it sunny all the time!
function OnWeatherChanging(World, Weather)
    return true, wSunny
end

-- HandleRequest_Docker handles incoming events from the proxy.go
function HandleRequest_Docker(Request)

    local content = "[dockerclient]"

    if Request.PostParams["action"] ~= nil then

        local action = Request.PostParams["action"]

        -- receiving informations about one container

        if action == "containerInfos" then
            LOG("EVENT - containerInfos")

            local world = Request.PostParams["world"]
            local name = Request.PostParams["name"]
            local imageRepo = Request.PostParams["imageRepo"]
            local imageTag = Request.PostParams["imageTag"]
            local id = Request.PostParams["id"]
            local running = Request.PostParams["running"]

            -- LOG("containerInfos running: " .. running)

            local state = CONTAINER_STOPPED
            if running == "true" then
                state = CONTAINER_RUNNING
            end

            Worlds[world]:updateContainer(id,name,imageRepo,imageTag,state)
        end

        if action == "startContainer" then
            LOG("EVENT - startContainer")

            local world = Request.PostParams["world"]
            local name = Request.PostParams["name"]
            local imageRepo = Request.PostParams["imageRepo"]
            local imageTag = Request.PostParams["imageTag"]
            local id = Request.PostParams["id"]

            Worlds[world]:updateContainer(id,name,imageRepo,imageTag,CONTAINER_RUNNING)
        end

        if action == "createContainer" then
            LOG("EVENT - createContainer")

            local world = Request.PostParams["world"]
            local name = Request.PostParams["name"]
            local imageRepo = Request.PostParams["imageRepo"]
            local imageTag = Request.PostParams["imageTag"]
            local id = Request.PostParams["id"]

            Worlds[world]:updateContainer(id,name,imageRepo,imageTag,CONTAINER_CREATED)
        end

        if action == "stopContainer" then
            LOG("EVENT - stopContainer")

            local world = Request.PostParams["world"]
            local name = Request.PostParams["name"]
            local imageRepo = Request.PostParams["imageRepo"]
            local imageTag = Request.PostParams["imageTag"]
            local id = Request.PostParams["id"]

            Worlds[world]:updateContainer(id,name,imageRepo,imageTag,CONTAINER_STOPPED)
        end

        if action == "destroyContainer" then
            LOG("EVENT - destroyContainer")
            local world = Request.PostParams["world"]
            local id = Request.PostParams["id"]

            Worlds[world]:destroyContainer(id)
        end

        if action == "stats" then
            local world = Request.PostParams["world"]
            local id = Request.PostParams["id"]
            local cpu = Request.PostParams["cpu"]
            local ram = Request.PostParams["ram"]

            Worlds[world]:updateStats(id,ram,cpu)
        end


        content = content .. "{action:\"" .. action .. "\"}"

    else
        content = content .. "{error:\"action requested\"}"

    end

    content = content .. "[/dockerclient]"

    return content
end

