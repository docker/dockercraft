-- local PLUGIN = nil


Ground = 63
DContainer = {displayed = false, x = 0, z = 0, name="",id="",imageRepo="",imageTag=""}

CONTAINER_START_X = 0
CONTAINER_OFFSET_X = -6
CONTAINER_START_Z = 4

Containers = {}
SignsToUpdate = {}

function updateSigns(World)

	for i=1,table.getn(SignsToUpdate)
	do					
		sign = SignsToUpdate[i]

		LOG("update sign: " .. sign.line1 .. ", " .. sign.line2 .. ", " .. sign.line3 .. ", " .. sign.line4)

		cRoot:Get():GetDefaultWorld():SetSignLines(sign.x,sign.y,sign.z,sign.line1,sign.line2,sign.line3,sign.line4)
	end
	SignsToUpdate = {}
end

function startContainer(id,name,imageRepo,imageTag)

	x = 0

	index = -1

	for i=0, table.getn(Containers)
	do
		-- use first empty location
		if index == -1 and Containers[i] == nil
		then
			index = i
		else 
			if Containers[i].id == id
			then
				LOG("container already started")
				return 
			end
		end

		-- increment position only location
		-- has not already been reserved
		if index == -1
		then
			x = x + CONTAINER_OFFSET_X
		end
	end

	container = DContainer
	container:init(x,CONTAINER_START_Z)
	container:setInfos(id,name,imageRepo,imageTag)
	container:display()

	if index == -1
		then
			table.insert(Containers, container)
		else
			Containers[index] = container
	end

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

function DContainer:display()
	if self.displayed == false 
	then
		self.displayed = true

		cRoot:Get():GetDefaultWorld():SetBlock(self.x,Ground + 1,self.z - 1,E_BLOCK_SIGN_POST,8)

		sign = {}
		sign.x = self.x
		sign.y = Ground + 1
		sign.z = self.z - 1
		sign.line1 = self.id
		sign.line2 = self.name
		sign.line3 = self.imageRepo
		sign.line4 = self.imageTag

		LOG("schedule update sign: x:" .. tostring(sign.x) .. ", " .. sign.line1 .. ", " .. sign.line2 .. ", " .. sign.line3 .. ", " .. sign.line4)


		table.insert(SignsToUpdate,sign)

		cRoot:Get():GetDefaultWorld():ScheduleTask(20,updateSigns)

		-- 	function(World)
		-- 		for i=1,table.getn(SignsToUpdate) do
					
		-- 			local sign = SignsToUpdate[i]

		-- 			LOG("update sign: " .. sign.line1)

		-- 			cRoot:Get():GetDefaultWorld():SetSignLines(self.x,Ground + 1,self.z - 1,sign.line1,sign.line2,sign.line3,sign.line4)
		-- 		end
		-- 		SignsToUpdate = {}
		-- 	end
		-- )
		
		for px=self.x, self.x+3
		do
			for pz=self.z, self.z+4
			do
				cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 1,pz,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			end	
		end

		for py = Ground+2, Ground+3
		do
			
			cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)

			cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+1,E_BLOCK_WOOL,E_META_WOOL_BLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+1,E_BLOCK_WOOL,E_META_WOOL_BLUE)

			cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+2,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+2,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)

			cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+3,E_BLOCK_WOOL,E_META_WOOL_BLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+3,E_BLOCK_WOOL,E_META_WOOL_BLUE)

			cRoot:Get():GetDefaultWorld():SetBlock(self.x,py,self.z+4,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+3,py,self.z+4,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)

			cRoot:Get():GetDefaultWorld():SetBlock(self.x+1,py,self.z+4,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			cRoot:Get():GetDefaultWorld():SetBlock(self.x+2,py,self.z+4,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
		end

		for px=self.x, self.x+3
		do
			for pz=self.z, self.z+4
			do
				cRoot:Get():GetDefaultWorld():SetBlock(px,Ground + 4,pz,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			end	
		end
	end
end





function Initialize(Plugin)
	Plugin:SetName("Docker")
	Plugin:SetVersion(1)

	-- Hooks

	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_STARTED, WorldStarted);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);

	
	-- PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that
	
	-- Command Bindings

	Plugin:AddWebTab("Docker",HandleRequest_Docker)

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

			startContainer(id,name,imageRepo,imageTag)
		end

		if action == "startContainer"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]
			id = Request.PostParams["id"]

			startContainer(id,name,imageRepo,imageTag)
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
