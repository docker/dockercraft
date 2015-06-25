-- local PLUGIN = nil


Ground = 63

CONTAINER_START_X = 0
CONTAINER_OFFSET_X = -6
CONTAINER_START_Z = 4

Containers = {}
SignsToUpdate = {}

function updateSigns(World)

	for i=1,table.getn(SignsToUpdate)
	do					
		sign = SignsToUpdate[i]

		-- LOG("update sign: " .. sign.line1 .. ", " .. sign.line2 .. ", " .. sign.line3 .. ", " .. sign.line4)

		cRoot:Get():GetDefaultWorld():SetSignLines(sign.x,sign.y,sign.z,sign.line1,sign.line2,sign.line3,sign.line4)
	end
	SignsToUpdate = {}
end


function destroyContainer(id)

	for i=1, table.getn(Containers)
	do
		-- use first empty location
		if Containers[i] ~= nil and Containers[i].id == id
		then
			LOG("destroyContainer: found!")
			Containers[i]:destroy()
			Containers[i] = nil
			break
		end
	end

end

function addContainer(id,name,imageRepo,imageTag,running)

	x = 0

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
		x = 0

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
	container:setInfos(id,name,imageRepo,imageTag)
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
	dc = {displayed = false, x = 0, z = 0, name="",id="",imageRepo="",imageTag=""}
	dc.init = DContainer.init
	dc.setInfos = DContainer.setInfos
	dc.display = DContainer.display
	dc.destroy = DContainer.destroy
	return dc
end

function DContainer:init(x,z)
	self.x = x
	self.z = z
	self.displayed = false
end

function DContainer:setInfos(id,name,imageRepo,imageTag)
	self.id = id
	self.name = name
	self.imageRepo = imageRepo
	self.imageTag = imageTag
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


	if self.displayed == false 
	then
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
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
			
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

		for px=self.x, self.x+3
		do
			for pz=self.z, self.z+4
			do
				cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 4,pz,E_BLOCK_WOOL,metaPrimaryColor)
			end	
		end


		cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,Ground + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)

		sign = {}
		sign.x = self.x+3
		sign.y = Ground + 2
		sign.z = self.z - 1
		sign.line1 = self.id
		sign.line2 = self.name
		sign.line3 = self.imageRepo
		sign.line4 = self.imageTag

		-- LOG("schedule update sign: x:" .. tostring(sign.x) .. ", " .. sign.line1 .. ", " .. sign.line2 .. ", " .. sign.line3 .. ", " .. sign.line4)

		table.insert(SignsToUpdate,sign)

		cRoot:Get():GetDefaultWorld():ScheduleTask(10,updateSigns)

	end
end





function Initialize(Plugin)
	Plugin:SetName("Docker")
	Plugin:SetVersion(1)

	-- Hooks

	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, WorldStarted);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
	
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
	for x=-40,40
	do
		for z=-40,40
		do
			cRoot:Get():GetDefaultWorld():SetBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
		end
	end	
end

function PlayerJoined(Player)
	-- refresh containers
	LOG("player joined")
	r = os.execute("/go/src/goproxy/goproxy containers")
	LOG("executed: /go/src/goproxy/goproxy containers -> " .. tostring(r))
end


function DockerCommand(Split, Player)

	if table.getn(Split) > 0
	then

		LOG("Split[1]: " .. Split[1])

		if Split[1] == "/docker"
		then
			if table.getn(Split) > 1
			then
				if Split[2] == "pull" or Split[2] == "create" or Split[2] == "run" or Split[2] == "stop" or Split[2] == "rm" or Split[2] == "rmi" or Split[2] == "start"
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
