json = require("json")

-- queue containing the updates that need to be applied to the minecraft world
UpdateQueue = nil

-- Tick is triggered by cPluginManager.HOOK_TICK
function Tick(TimeDelta)
	UpdateQueue:update(MAX_BLOCK_UPDATE_PER_TICK)
end

-- Plugin initialization
function Initialize(Plugin)
	Plugin:SetName("OpenStack")
	Plugin:SetVersion(1)

	UpdateQueue = NewUpdateQueue()

	-- Hooks

	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, WorldStarted);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, PlayerUsingBlock);
	-- cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating);
	cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick);

	-- Command Bindings

	cPluginManager.BindCommand("/nova", "*", NovaCommand, " - nova CLI commands")

	-- Plugin:AddWebTab("OpenStack",HandleRequest_OpenStack)
	
	-- make all players admin
	cRankManager:SetDefaultRank("Admin")

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	function callback()
		SyncNova()
	end

	listen(8010, callback)

	return true
end


function WorldStarted()
	y = GROUND_LEVEL
	-- just enough to fit one server
	-- then it should be dynamic
	for x = GROUND_MIN_X, GROUND_MAX_X do
		for z = GROUND_MIN_Z,GROUND_MAX_Z do
			setBlock(UpdateQueue, x, y, z, E_BLOCK_WOOL, E_META_WOOL_WHITE)
		end
	end	
end

function NovaCommand(Split, Player)
	if table.getn(Split) > 0 then

		LOG("Split[1]: " .. Split[1])

		if Split[1] == "/nova" then
			if table.getn(Split) > 1 then
				if Split[2] == "create" then
					name = Split[3]
					image = Split[4]
					flavor = Split[5]
					NovaCreate(name, image, flavor)
				end
				if Split[2] == "delete" then
					server_name = Split[3]
					NovaDelete(server_name)
				end
				if Split[2] == "start" then
					server_name = Split[3]
					NovaStart(server_name)
				end
				if Split[2] == "stop" then
					server_name = Split[3]
					NovaStop(server_name)
				end
			end
		end
	end

	return true
end

function PlayerJoined(Player)
	-- refresh containers
	LOG("player joined")
	SyncNova()
end

function SyncNova()
	DeleteAllServers()
	function callback(status,body)
		servers = json.parse(body)
		for i, server in ipairs(servers.server) do
			status = SERVER_STOPPED
			if (server.status == 'ACTIVE') then
				status = SERVER_RUNNING
			end
			UpdateServer(server.id, server.name, status)
			LOG(server.id .. "," .. server.name)
			function callback2(a,b)
				LOG(a .. "," .. b)
			end
			body = json.stringify({notification_url = 'http://localhost:8010'})
			-- request("localhost", 8000, "POST", "/nova/servers/" .. server.id .. "/notifications/", body, callback2)
		end
	end
	request("localhost", 8000, "GET", "/nova/servers", "", callback)
end


function PlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	LOG("Using block: " .. tostring(BlockX) .. "," .. tostring(BlockY) .. "," .. tostring(BlockZ) .. " - " .. tostring(BlockType) .. " - " .. tostring(BlockMeta))

	-- stone button
	if BlockType == 77 then
		serverID = GetDeleteButtonServer(BlockX, BlockZ)

		Player:SendMessage("server delete " .. string.sub(serverID,1,8))
		NovaDelete(serverID)
	end
end


function NovaCreate(Name, Image, Flavor)
	body = json.stringify({name = Name, image = Image, flavor = Flavor})
	function callback(a,data)
		server = json.parse(data)
		UpdateServer(server.id, Name, SERVER_RUNNING)
	end
	request("localhost", 8000, "POST", "/nova/servers", body, callback)
end

function NovaDelete(Name)
	function callback(a,data)
		server = json.parse(data)
		DeleteServer(server.id)
	end
	request("localhost", 8000, "DELETE", "/nova/server/" .. Name, "", callback)
end

function NovaStart(Name)
	function callback(a,b)
		LOG(a .. "," .. b)
	end
	request("localhost", 8000, "PUT", "/nova/server/" .. Name .. "/action/start", "", callback)
end


function NovaStop(Name)
	function callback(a,b)
		LOG(a .. "," .. b)
	end
	path = "/nova/server/" .. Name .. "/action/stop"
	request("localhost", 8000, "PUT", path, "", callback)
end
