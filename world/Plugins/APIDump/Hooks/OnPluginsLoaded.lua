return
{
	HOOK_PLUGINS_LOADED =
	{
		CalledWhen = "All the enabled plugins have been loaded",
		DefaultFnName = "OnPluginsLoaded",  -- also used as pagename
		Desc = [[
			This callback gets called when the server finishes loading and initializing plugins. This is the
			perfect occasion for a plugin to query other plugins through {{cPluginManager}}:GetPlugin() and
			possibly start communicating with them using the {{cPlugin}}:Call() function.
		]],
		Params = {},
		Returns = [[
			The return value is ignored, all registered callbacks are called.
		]],
		CodeExamples =
		{
			{
				Title = "CoreMessaging",
				Desc = [[
					This example shows how to implement the CoreMessaging functionality - messages to players will be
					sent through the Core plugin, formatted by that plugin. As a fallback for when the Core plugin is
					not present, the messages are sent directly by this code, unformatted.
				]],
				Code = [[
-- These are the fallback functions used when the Core is not present:
local function SendMessageFallback(a_Player, a_Message)
	a_Player:SendMessage(a_Message);
end

local function SendMessageSuccessFallback(a_Player, a_Message)
	a_Player:SendMessage(a_Message);
end

local function SendMessageFailureFallback(a_Player, a_Message)
	a_Player:SendMessage(a_Message);
end

-- These three "variables" will hold the actual functions to call.
-- By default they are initialized to the Fallback variants,
-- but will be redirected to Core when all plugins load
SendMessage        = SendMessageFallback;
SendMessageSuccess = SendMessageSuccessFallback;
SendMessageFailure = SendMessageFailureFallback;

-- The callback tries to connect to the Core
-- If successful, overwrites the three functions with Core ones
local function OnPluginsLoaded()
	local CorePlugin = cPluginManager:Get():GetPlugin("Core");
	if (CorePlugin == nil) then
		-- The Core is not loaded, keep the Fallback functions
		return;
	end
	
	-- Overwrite the three functions with Core functionality:
	SendMessage = function(a_Player, a_Message)
		CorePlugin:Call("SendMessage", a_Player, a_Message);
	end
	SendMessageSuccess = function(a_Player, a_Message)
		CorePlugin:Call("SendMessageSuccess", a_Player, a_Message);
	end
	SendMessageFailure = function(a_Player, a_Message)
		CorePlugin:Call("SendMessageFailure", a_Player, a_Message);
	end
end

-- Global scope, register the callback:
cPluginManager.AddHook(cPluginManager.HOOK_PLUGINS_LOADED, CoreMessagingPluginsLoaded);


-- Usage, anywhere else in the plugin:
SendMessageFailure(
	a_Player,
	"Cannot teleport to player, the destination player " .. PlayerName .. " was not found"
);
				]],
			},
		} ,  -- CodeExamples
	},  -- HOOK_PLUGINS_LOADED
}




