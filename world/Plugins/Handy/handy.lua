-- Global variables
PLUGIN = {}	-- Reference to own plugin object
CHEST_WIDTH = 9
HANDY_VERSION = 2
--[[

Handy is a plugin for other plugins. It contain no commands, no hooks, but functions to ease plugins developers' life.

API:


TODO:
1. GetChestSlot wrapper, so it will detect double chest neighbour chest and will be able to access it.
]]

function Initialize(Plugin)
	PLUGIN = Plugin
	PLUGIN:SetName("Handy")
	PLUGIN:SetVersion(HANDY_VERSION)
	
	PluginManager = cRoot:Get():GetPluginManager()
	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion())
	return true
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. " is shutting down...")
end