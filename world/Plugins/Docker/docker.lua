-- local PLUGIN = nil

Ground = 63
DContainer = {displayed = false, x = 0, z = 0}

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

	container = DContainer
	container:init(0,4)
	container:display()

	container = DContainer
	container:init(-6,4)
	container:display()

	container = DContainer
	container:init(-12,4)
	container:display()

	container = DContainer
	container:init(-18,4)
	container:display()


	return true
end


function HandleRequest_Docker(Request)
	
	content = "[dockerclient]"

	if Request.PostParams["action"] ~= nil then

		action = Request.PostParams["action"]

		if action == "buildColumn"
		then
			x = Request.PostParams["x"]
			z = Request.PostParams["z"]

			for y=0,150
			do
				cRoot:Get():GetDefaultWorld():SetBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_LIGHTBLUE)
			end

			content = content .. "{action:\"" .. action .. "\",x:" .. x .. ",z:" .. z .. "}"

		else

			content = content .. "{action:\"" .. action .. "\"}"


		end

	else
		content = content .. "{error:\"action requested\"}"

	end

	content = content .. "[/dockerclient]"

	return content

end




-- function OnDisable()
-- 	LOG(PLUGIN:GetName() .. " is shutting down...")
-- end
