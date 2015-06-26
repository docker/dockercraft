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



Containers = {}
SignsToUpdate = {}


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

function addContainer(id,name,imageRepo,imageTag,running)

	x = CONTAINER_START_X

	index = -1

	-- first pass, to see if container
	-- already displayed (maybe with another state)
	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and Containers[i].id == id
		then
			LOG("container already displayed")
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
	container:setInfos(id,name,imageRepo,imageTag,running)
	addGroundForContainer(container)
	container:display(running)

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
			cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 1,pz,E_BLOCK_WOOL,metaPrimaryColor)
		end	
	end

	for py = Ground+2, Ground+3
	do
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
		-- leave empty space for the door
		-- cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
		
		cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

		cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)

		cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)

		cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)

		cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)

		cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
	end

	-- torch
	cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,Ground+3,self.z+3,E_BLOCK_TORCH,E_META_TORCH_ZP)

	-- start / stop lever

	cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,Ground + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
	updateSign(self.x+1,Ground + 3,self.z + 2,"","START/STOP","---->","")


	if running
	then
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,Ground+3,self.z+1,E_BLOCK_LEVER,1)
	else
		cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,Ground+3,self.z+1,E_BLOCK_LEVER,9)
	end


	-- remove button

	cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,Ground + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XM)
	updateSign(self.x+2,Ground + 3,self.z + 2,"","REMOVE","---->","")

	cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,Ground+3,self.z+3,E_BLOCK_STONE_BUTTON,E_BLOCK_BUTTON_XM)


	-- door
	-- mcserver bug with Minecraft 1.8 apparently, doors are not displayed correctly
	-- cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,Ground+2,self.z,E_BLOCK_WOODEN_DOOR,E_META_CHEST_FACING_ZM)


	for px=self.x, self.x+3
	do
		for pz=self.z, self.z+4
		do
			cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 4,pz,E_BLOCK_WOOL,metaPrimaryColor)
		end	
	end

	cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	updateSign(self.x+3,Ground + 2,self.z - 1,self.id,self.name,self.imageRepo,self.imageTag)

	-- Mem sign
	cRoot:Get():GetDefaultWorld():SetBlock(self.x,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	self:updateMemSign("")

	-- CPU sign
	cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	self:updateCPUSign("")


	cRoot:Get():GetDefaultWorld():ScheduleTask(5,
		function(World)
			World:WakeUpSimulatorsInArea(self.x-1, self.x+4,Ground, Ground+4,self.z-1, self.z+5)
		end
	)


end


function DContainer:updateMemSign(s)
	updateSign(self.x,Ground + 2,self.z - 1,"Mem usage","",s,"")
end

function DContainer:updateCPUSign(s)
	updateSign(self.x+1,Ground + 2,self.z - 1,"CPU usage","",s,"")
end



function Initialize(Plugin)
	Plugin:SetName("Docker")
	Plugin:SetVersion(1)

	-- Hooks

	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, WorldStarted);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, PlayerUsingBlock);
	
	-- Command Bindings

	cPluginManager.BindCommand("/docker", "*", DockerCommand, " - docker CLI commands")

	Plugin:AddWebTab("Docker",HandleRequest_Docker)

	-- make all players admin
	cRankManager:SetDefaultRank("Admin")

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
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
				cRoot:Get():GetDefaultWorld():SetBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
			end
		end	
	end
end


function PlayerJoined(Player)
	-- refresh containers
	LOG("player joined")
	r = os.execute("/go/src/goproxy/goproxy containers")
	LOG("executed: /go/src/goproxy/goproxy containers -> " .. tostring(r))
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
				r = os.execute("docker kill " .. containerID)
			-- start
			else 
				r = os.execute("docker start " .. containerID)
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
			r = os.execute("docker rm " .. containerID)
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

					EntireCommand = table.concat(Split, " ")
					command = string.sub(EntireCommand, 2, -1)
					r = os.execute(command)
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

		if action == "generateGround"
		then
			WorldStarted()
		end

		-- receiving informations about one container
		
		if action == "containerInfos"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]
			running = Request.PostParams["running"]

			-- LOG("containerInfos running: " .. running)

			addContainer(id,name,imageRepo,imageTag,running == "true")
		end

		if action == "startContainer"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			addContainer(id,name,imageRepo,imageTag,true)
		end

		if action == "createContainer"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			addContainer(id,name,imageRepo,imageTag,false)
		end

		if action == "stopContainer"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			addContainer(id,name,imageRepo,imageTag,false)
		end

		if action == "destroyContainer"
		then
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
