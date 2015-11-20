
-- plugin.lua

-- Implements the main entrypoint for the plugin, as well as all the handling needed

-- ChatLog plugin logs all chat messages into the server log





function Initialize(Plugin)
	Plugin:SetName("ChatLog")
	Plugin:SetVersion(3)

	cPluginManager.AddHook(cPluginManager.HOOK_CHAT, OnChat)

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





function OnChat(Player, Message)
	-- Lets get loggin'
	LOGINFO("[" .. Player:GetName() .. "]: " .. StripColorCodes(Message));

	return false
end