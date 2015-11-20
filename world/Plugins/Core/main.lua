-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true





-- Global variables
Messages = {}
WorldsSpawnProtect = {}
WorldsWorldLimit = {}
WorldsWorldDifficulty = {}
lastsender = {}




-- Called by MCServer on plugin start to initialize the plugin
function Initialize(Plugin)
	Plugin:SetName( "Core" )
	Plugin:SetVersion( 15 )

	-- Register for all hooks needed
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,                  OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_CRAFTING_NO_RECIPE,    OnCraftingNoRecipe)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,      OnDisconnect);
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING,               OnKilling)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,         OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,         OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK,  OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY,       OnSpawningEntity)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,           OnTakeDamage)

	-- Bind ingame commands:
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands();

	-- Load settings:
	IniFile = cIniFile()
	IniFile:ReadFile("settings.ini")
	HardCore = IniFile:GetValueSet("GameMode", "Hardcore", "false")
	IniFile:WriteFile("settings.ini")
	
	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (a_World)
			LoadWorldSettings(a_World)
		end
	)

	-- Initialize the banlist, load its DB, do whatever processing it needs on startup:
	InitializeBanlist()
	
	-- Initialize the whitelist, load its DB, do whatever processing it needs on startup:
	InitializeWhitelist()

	-- Initialize the Item Blacklist (the list of items that cannot be obtained using the give command)
	IntializeItemBlacklist( Plugin )

	-- Add webadmin tabs:
	Plugin:AddWebTab("Manage Server",   HandleRequest_ManageServer)
	Plugin:AddWebTab("Server Settings", HandleRequest_ServerSettings)
	Plugin:AddWebTab("Chat",            HandleRequest_Chat)
	Plugin:AddWebTab("Players",         HandleRequest_Players)
	Plugin:AddWebTab("Whitelist",       HandleRequest_WhiteList)
	Plugin:AddWebTab("Permissions",     HandleRequest_Permissions)
	Plugin:AddWebTab("Plugins",         HandleRequest_ManagePlugins)
	Plugin:AddWebTab("Time & Weather",  HandleRequest_Weather)
	Plugin:AddWebTab("Ranks",           HandleRequest_Ranks)
	Plugin:AddWebTab("Player Ranks",    HandleRequest_PlayerRanks)

	LoadMotd()
	
	WEBLOGINFO("Core is initialized")
	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end
