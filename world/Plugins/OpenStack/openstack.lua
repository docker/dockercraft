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
	
	-- make all players admin
	cRankManager:SetDefaultRank("Admin")

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	ListenUpdater()

	return true
end

function ListenUpdater()
	function callback(body)
		LOG("Received via HTTP: " .. body)
		changes = json.parse(body)
		if changes.monitor == "servers" then
			for i, server in ipairs(changes.decreaseServers) do
				DeleteServer(server.id)
				-- TODO: delete notification
			end
			for i, server in ipairs(changes.increaseServers) do
				status = SERVER_STOPPED
				if (server.status == 'ACTIVE') then
					status = SERVER_RUNNING
				end
				UpdateServer(server.id, server.name, status)
				body = json.stringify({notificationUrl = 'http://localhost:8010',
					                   monitor = 'specifiedServer',
				    	               server = server.id})
				request("localhost", 8000, "POST", "/notifications/", body, nil)
			end
		end
		if changes.monitor == "specifiedServer" then
			if changes.status == 'GONE' then
				DeleteServer(changes.server.id)
				-- TODO: delete notification
			else
				status = SERVER_STOPPED
				if (changes.status == 'ACTIVE') then
					status = SERVER_RUNNING
				end
				UpdateServer(changes.server.id, changes.server.name, status)
			end
		end
	end

	listen(8010, callback)
end

function WorldStarted()
	y = GROUND_LEVEL
	-- just enough to fit one server
	-- then it should be dynamic
	for x = GROUND_MIN_X, GROUND_MAX_X do
		for z = GROUND_MIN_Z, GROUND_MAX_Z do
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
			body = json.stringify({notificationUrl = 'http://localhost:8010',
				                   monitor = 'specifiedServer',
				                   server = server.id})
			request("localhost", 8000, "POST", "/notifications/", body, nil)
		end
	end
	request("localhost", 8000, "GET", "/nova/servers", "", callback)

	body = json.stringify({notificationUrl = 'http://localhost:8010',
		                   monitor = 'servers'})
	request("localhost", 8000, "POST", "/notifications/", body, nil)
end


function PlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	LOG("Using block: " .. tostring(BlockX) .. "," .. tostring(BlockY) .. "," .. tostring(BlockZ) .. " - " .. tostring(BlockType) .. " - " .. tostring(BlockMeta))
	
	-- lever: 1->OFF 9->ON (in that orientation)
	-- lever
	if BlockType == 69
	then
		serverID = GetStartStopLeverServer(BlockX, BlockZ)

		-- stop
		if BlockMeta == 1
		then
			Player:SendMessage("server stop " .. string.sub(serverID,1,8))
			NovaStop(serverID)
		-- start
		else 
			Player:SendMessage("server start " .. string.sub(serverID,1,8))
			NovaStart(serverID)
		end
	end

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
	end
	request("localhost", 8000, "POST", "/nova/servers", body, callback)
end

function NovaDelete(Name)
	function callback(a,data)
		server = json.parse(data)
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
