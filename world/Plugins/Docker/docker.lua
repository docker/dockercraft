-- local PLUGIN = nil

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
