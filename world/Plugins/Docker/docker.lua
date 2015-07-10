-- local PLUGIN = nil


Ground = 63

CONTAINER_START_X = -3
CONTAINER_OFFSET_X = -6
CONTAINER_START_Z = 2

-- enough to fit one container
GROUND_MIN_X = CONTAINER_START_X - 2
GROUND_MAX_X = CONTAINER_START_X + 5
GROUND_MIN_Z = -4
GROUND_MAX_Z = CONTAINER_START_Z + 6

MAX_BLOCK_UPDATE_PER_TICK = 50
-- a list of blocks to be updated (first in first out)
FIRST_BLOCK_UPDATE = nil
LAST_BLOCK_UPDATE = nil
UPDATE_SET = 0
UPDATE_DIG = 1
-- update operations in the list should have these fields:
-- {op (UPDATE_SET || UPDATE_DIG), next, x, y, z, [blockID, meta]}

function setBlock(x,y,z,blockID,meta)
	update = {op=UPDATE_SET,next=nil,x=x,y=y,z=z,blockID=blockID,meta=meta }

	if FIRST_BLOCK_UPDATE == nil
	then 
		FIRST_BLOCK_UPDATE = update
		LAST_BLOCK_UPDATE = update
	else 
		LAST_BLOCK_UPDATE.next = update
		LAST_BLOCK_UPDATE = update
	end
end

function digBlock(x,y,z)
	update = {op=UPDATE_DIG,next=nil,x=x,y=y,z=z }

	if FIRST_BLOCK_UPDATE == nil
	then 
		FIRST_BLOCK_UPDATE = update
		LAST_BLOCK_UPDATE = update
	else 
		LAST_BLOCK_UPDATE.next = update
		LAST_BLOCK_UPDATE = update
	end
end

-- updates one block
-- returns false if there's no update remaining in the list
-- otherwise, returns true
function updateOneBlock()

	if FIRST_BLOCK_UPDATE == nil
	then 
		return false
	else 
		update = FIRST_BLOCK_UPDATE
		FIRST_BLOCK_UPDATE = FIRST_BLOCK_UPDATE.next

		if update.op == UPDATE_SET
			then
			cRoot:Get():GetDefaultWorld():SetBlock(update.x,update.y,update.z,update.blockID,update.meta)
			else
			cRoot:Get():GetDefaultWorld():DigBlock(update.x,update.y,update.z)
		end
	end
end


function Tick(TimeDelta)

	-- update blocks, considering limit per tick
	n = MAX_BLOCK_UPDATE_PER_TICK

 	while n > 0
 	do
 		if updateOneBlock() == false
 		then
 			break
 		end
 		n = n - 1
 	end

end




Containers = {}
SignsToUpdate = {}

-- Plugin initialization
function Initialize(Plugin)
	Plugin:SetName("Docker")
	Plugin:SetVersion(1)

	-- Hooks

	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, WorldStarted);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, PlayerUsingBlock);
	cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating);
	cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick);

	-- Command Bindings

	cPluginManager.BindCommand("/docker", "*", DockerCommand, " - docker CLI commands")

	Plugin:AddWebTab("Docker",HandleRequest_Docker)

	-- make all players admin
	cRankManager:SetDefaultRank("Admin")

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end




function updateSign(x,y,z,line1,line2,line3,line4)
	
	sign = {}
	sign.x = x
	sign.y = y
	sign.z = z
	sign.line1 = line1
	sign.line2 = line2
	sign.line3 = line3
	sign.line4 = line4

	table.insert(SignsToUpdate,sign)

	cRoot:Get():GetDefaultWorld():ScheduleTask(10,updateSigns)

end


function updateSigns(World)

	for i=1,table.getn(SignsToUpdate)
	do					
		sign = SignsToUpdate[i]
		cRoot:Get():GetDefaultWorld():SetSignLines(sign.x,sign.y,sign.z,sign.line1,sign.line2,sign.line3,sign.line4)
	end
	SignsToUpdate = {}
end

function updateStats(id,mem,cpu)

	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and Containers[i].id == id
		then
			Containers[i]:updateMemSign(mem)
			Containers[i]:updateCPUSign(cpu)
			break
		end
	end
end

function getStartStopLeverContainer(x,z)

	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and x == Containers[i].x + 1 and z == Containers[i].z + 1
		then
			return Containers[i].id
		end
	end

	return ""
end

-- returns container ID and running state (true / false)
function getRemoveButtonContainer(x,z)

	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and x == Containers[i].x + 2 and z == Containers[i].z + 3
		then
			return Containers[i].id, Containers[i].running
		end
	end

	return "", true
end


function destroyContainer(id)

	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and Containers[i].id == id
		then
			Containers[i]:destroy()
			Containers[i] = nil
			break
		end
	end

end


UPDATE_CREATED = 0
UPDATE_RUNNING = 1
UPDATE_STOPPED = 2
-- updateContainer accepts 3 different states: running, stopped, created
-- sometimes "start" events arrive before "create" ones
-- in this case, we just ignore the update
function updateContainer(id,name,imageRepo,imageTag,state)

	x = CONTAINER_START_X

	index = -1

	-- first pass, to see if container
	-- already displayed (maybe with another state)
	for i=1, table.getn(Containers)
	do
		-- if container found with same ID
		if Containers[i] ~= nil and Containers[i].id == id
		then
			-- container already found
			-- "create" event arrives too late
			if state == UPDATE_CREATED then
				return
			end

			index = i
			break
		end

		x = x + CONTAINER_OFFSET_X		
	end

	-- if container not already displayed
	-- see if there's an empty location
	if index == -1
	then
		x = CONTAINER_START_X

		for i=1, table.getn(Containers)
		do
			-- use first empty location
			if Containers[i] == nil
			then
				LOG("Found empty location: Containers[" .. tostring(i) .. "]")
				index = i
				break
			end

			x = x + CONTAINER_OFFSET_X			
		end
	end

	container = newDContainer()
	container:init(x,CONTAINER_START_Z)
	container:setInfos(id,name,imageRepo,imageTag,state == UPDATE_RUNNING)
	addGroundForContainer(container)
	container:display(state == UPDATE_RUNNING)

	if index == -1
		then
			table.insert(Containers, container)
		else
			Containers[index] = container
	end
end


DContainer = {displayed = false, x = 0, z = 0, name="",id="",imageRepo="",imageTag=""}

function newDContainer()
	dc = {displayed = false, x = 0, z = 0, name="",id="",imageRepo="",imageTag="",running=false}
	dc.init = DContainer.init
	dc.setInfos = DContainer.setInfos
	dc.display = DContainer.display
	dc.destroy = DContainer.destroy
	dc.updateMemSign = DContainer.updateMemSign
	dc.updateCPUSign = DContainer.updateCPUSign
	return dc
end

function DContainer:init(x,z)
	self.x = x
	self.z = z
	self.displayed = false
end

function DContainer:setInfos(id,name,imageRepo,imageTag,running)
	self.id = id
	self.name = name
	self.imageRepo = imageRepo
	self.imageTag = imageTag
	self.running = running
end


function DContainer:destroy(running)

	for py = Ground+1, Ground+4
	do
		for px=self.x-1, self.x+4
		do
			for pz=self.z-1, self.z+5
			do
				cRoot:Get():GetDefaultWorld():DigBlock(px,py,pz)
			end	
		end
	end
end


function DContainer:display(running)

	metaPrimaryColor = E_META_WOOL_LIGHTBLUE
	metaSecondaryColor = E_META_WOOL_BLUE

	if running == false 
	then
		metaPrimaryColor = E_META_WOOL_ORANGE
		metaSecondaryColor = E_META_WOOL_RED
	end


	
	self.displayed = true

	
	for px=self.x, self.x+3
	do
		for pz=self.z, self.z+4
		do
			setBlock(px,Ground + 1,pz,E_BLOCK_WOOL,metaPrimaryColor)
			-- cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 1,pz,E_BLOCK_WOOL,metaPrimaryColor)
		end
	end

	for py = Ground+2, Ground+3
	do
		setBlock(self.x+1,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

		-- leave empty space for the door
		-- setBlock(self.x+2,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
		
		setBlock(self.x,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
		setBlock(self.x+3,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

		setBlock(self.x,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)
		setBlock(self.x+3,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)

		setBlock(self.x,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)
		setBlock(self.x+3,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)

		setBlock(self.x,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)
		setBlock(self.x+3,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)

		setBlock(self.x,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
		setBlock(self.x+3,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)

		setBlock(self.x+1,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
		setBlock(self.x+2,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
	end

	-- torch
	setBlock(self.x+1,Ground+3,self.z+3,E_BLOCK_TORCH,E_META_TORCH_ZP)

	-- start / stop lever

	setBlock(self.x+1,Ground + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
	-- updateSign(self.x+1,Ground + 3,self.z + 2,"","START/STOP","---->","")


	if running
	then
		setBlock(self.x+1,Ground+3,self.z+1,E_BLOCK_LEVER,1)
	else
		setBlock(self.x+1,Ground+3,self.z+1,E_BLOCK_LEVER,9)
	end


	-- remove button

	setBlock(self.x+2,Ground + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XM)
	-- updateSign(self.x+2,Ground + 3,self.z + 2,"","REMOVE","---->","")

	setBlock(self.x+2,Ground+3,self.z+3,E_BLOCK_STONE_BUTTON,E_BLOCK_BUTTON_XM)


	-- door
	-- mcserver bug with Minecraft 1.8 apparently, doors are not displayed correctly
	-- setBlock(self.x+2,Ground+2,self.z,E_BLOCK_WOODEN_DOOR,E_META_CHEST_FACING_ZM)


	for px=self.x, self.x+3
	do
		for pz=self.z, self.z+4
		do
			setBlock(px,Ground + 4,pz,E_BLOCK_WOOL,metaPrimaryColor)
		end	
	end

	setBlock(self.x+3,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	-- updateSign(self.x+3,Ground + 2,self.z - 1,string.sub(self.id,1,8),self.name,self.imageRepo,self.imageTag)

	-- Mem sign
	setBlock(self.x,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	-- self:updateMemSign("")

	-- CPU sign
	setBlock(self.x+1,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	-- self:updateCPUSign("")


	-- cRoot:Get():GetDefaultWorld():ScheduleTask(5,
	-- 	function(World)
	-- 		World:WakeUpSimulatorsInArea(self.x-1, self.x+4,Ground, Ground+4,self.z-1, self.z+5)
	-- 	end
	-- )
end


function DContainer:updateMemSign(s)
	updateSign(self.x,Ground + 2,self.z - 1,"Mem usage","",s,"")
end

function DContainer:updateCPUSign(s)
	updateSign(self.x+1,Ground + 2,self.z - 1,"CPU usage","",s,"")
end


function WorldStarted()
	y = Ground

	-- just enough to fit one container
	-- then it should be dynamic
	for x= GROUND_MIN_X, GROUND_MAX_X
	do
		for z=GROUND_MIN_Z,GROUND_MAX_Z
		do
			cRoot:Get():GetDefaultWorld():SetBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
		end
	end	
end

function addGroundForContainer(container)

	if GROUND_MIN_X > container.x - 2
	then 
		OLD_GROUND_MIN_X = GROUND_MIN_X
		GROUND_MIN_X = container.x - 2

		for x= GROUND_MIN_X, OLD_GROUND_MIN_X
		do
			for z=GROUND_MIN_Z,GROUND_MAX_Z
			do
				setBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
			end
		end	
	end
end


function PlayerJoined(Player)
	-- refresh containers
	LOG("player joined")
	r = os.execute("goproxy containers")
	LOG("executed: goproxy containers -> " .. tostring(r))
end

function PlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)

	-- LOG("Using block: " .. tostring(BlockX) .. "," .. tostring(BlockY) .. "," .. tostring(BlockZ) .. " - " .. tostring(BlockType) .. " - " .. tostring(BlockMeta))

	-- lever: 1->OFF 9->ON (in that orientation)

	-- lever
	if BlockType == 69
	then
		containerID = getStartStopLeverContainer(BlockX,BlockZ)

		if containerID ~= ""
		then
			-- stop
			if BlockMeta == 1
			then
				-- r = os.execute("docker kill " .. containerID)
				Player:SendMessage("docker stop " .. string.sub(containerID,1,8))
				r = os.execute("goproxy exec " .. Player:GetName() .. " docker stop " .. containerID)
			-- start
			else 
				-- r = os.execute("docker start " .. containerID)
				Player:SendMessage("docker start " .. string.sub(containerID,1,8))
				r = os.execute("goproxy exec " .. Player:GetName() .. " docker start " .. containerID)
			end
		end
	end

	-- stone button
	if BlockType == 77
	then
		containerID, running = getRemoveButtonContainer(BlockX,BlockZ)

		if running
		then
			Player:SendMessage("A running container can't be removed.")
		else 
			-- r = os.execute("docker rm " .. containerID)
			Player:SendMessage("docker rm " .. string.sub(containerID,1,8))
			r = os.execute("goproxy exec " .. Player:GetName() .. " docker rm " .. containerID)
		end
	end
end


function OnChunkGenerating(World, ChunkX, ChunkZ, ChunkDesc)
	-- override the built-in chunk generator
	-- to have it generate empty chunks only
	ChunkDesc:SetUseDefaultBiomes(false)
	ChunkDesc:SetUseDefaultComposition(false)
	ChunkDesc:SetUseDefaultFinish(false)
	ChunkDesc:SetUseDefaultHeight(false)
	return true
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

					EntireCommand = table.concat(Split, " ")
					command = string.sub(EntireCommand, 2, -1)
					
					-- r = os.execute(command)
					r = os.execute("goproxy exec " .. Player:GetName() .. " " .. command)

					LOG("executed: " .. command .. " -> " .. tostring(r))
				end
			end
		end
	end

	return true
end



function HandleRequest_Docker(Request)
	
	content = "[dockerclient]"

	if Request.PostParams["action"] ~= nil then

		action = Request.PostParams["action"]

		-- receiving informations about one container
		
		if action == "containerInfos"
		then
			LOG("EVENT - containerInfos")

			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]
			running = Request.PostParams["running"]

			-- LOG("containerInfos running: " .. running)

			state = UPDATE_STOPPED
			if running == "true" then
				state = UPDATE_RUNNING
			end

			updateContainer(id,name,imageRepo,imageTag,state)
		end

		if action == "startContainer"
		then
			LOG("EVENT - startContainer")

			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			updateContainer(id,name,imageRepo,imageTag,UPDATE_RUNNING)
		end

		if action == "createContainer"
		then
			LOG("EVENT - createContainer")

			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			updateContainer(id,name,imageRepo,imageTag,UPDATE_CREATED)
		end

		if action == "stopContainer"
		then
			LOG("EVENT - stopContainer")

			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			updateContainer(id,name,imageRepo,imageTag,UPDATE_STOPPED)
		end

		if action == "destroyContainer"
		then
			LOG("EVENT - destroyContainer")

			id = Request.PostParams["id"]

			destroyContainer(id)
		end

		if action == "stats"
		then
			id = Request.PostParams["id"]
			cpu = Request.PostParams["cpu"]
			ram = Request.PostParams["ram"]

			updateStats(id,ram,cpu)
		end


		content = content .. "{action:\"" .. action .. "\"}"

	else
		content = content .. "{error:\"action requested\"}"

	end

	content = content .. "[/dockerclient]"

	return content
end




-- function OnDisable()
-- 	LOG(PLUGIN:GetName() .. " is shutting down...")
-- end
