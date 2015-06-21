-- local PLUGIN = nil


Ground = 63
DContainer = {displayed = false, x = 0, z = 0, name=""}

CONTAINER_START_X = 0
CONTAINER_OFFSET_X = -6
CONTAINER_START_Z = 4

Containers = {}

function startContainer(name,imageRepo,imageTag)

	x = 0

	for i=0, table.getn(Containers)
	do
		if Containers[i] == nil
		then
			container = DContainer
			container:init(x,CONTAINER_START_Z)
			container:display()

			Containers[i] = container
			return
		end

		x = x + CONTAINER_OFFSET_X
	end

	container = DContainer
	container:init(x,CONTAINER_START_Z)
	container:display()

	table.insert(Containers, container)

end



function DContainer:init(x,z)
	self.x = x
	self.z = z
	self.displayed = false
end

function DContainer:display()
	if self.displayed == false 
	then
		self.displayed = true

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
	
	-- PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that
	
	-- Command Bindings

	Plugin:AddWebTab("Docker",HandleRequest_Docker)

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	y = 63
	for x=-40,40
	do
		for z=-40,40
		do
			cRoot:Get():GetDefaultWorld():SetBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
		end
	end

	return true
end


function HandleRequest_Docker(Request)
	
	content = "[dockerclient]"

	if Request.PostParams["action"] ~= nil then

		action = Request.PostParams["action"]

		if action == "startContainer"
		then
			name = Request.PostParams["name"]
			imageRepo = Request.PostParams["imageRepo"]
			imageTag = Request.PostParams["imageTag"]

			
			startContainer(name,imageRepo,imageTag)
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
