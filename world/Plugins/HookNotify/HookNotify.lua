
-- HookNotify.lua

--[[
Implements the entire plugin

NOTE: This plugin is not meant for production servers. It is used mainly by developers to verify that things
are working properly when implementing Cuberite features. Do not enable this plugin on production servers!

This plugin logs a notification for each hook that is being called by the server.
The TICK and WORLD_TICK hooks are disabled because they produce too much output.
--]]





function Initialize(a_Plugin)
	-- Notify the admin that HookNotify is installed, this is not meant for production servers
	LOGINFO("HookNotify plugin is installed, beware, the log output may be quite large!");
	LOGINFO("You want this plugin enabled only when developing another plugin, not for regular gameplay.");

	-- These hooks will not be notified:
	local hooksToIgnore =
	{
		["HOOK_TICK"] = true,  -- Too much spam
		["HOOK_WORLD_TICK"] = true,  -- Too much spam
		["HOOK_TAKE_DAMAGE"] = true,  -- Has a separate handler with more info logged
		["HOOK_MAX"] = true,  -- No such hook, placeholder only
		["HOOK_NUM_HOOKS"] = true,  -- No such hook, placeholder only
	}
	
	-- Add all hooks:
	for n, v in pairs(cPluginManager) do
		if (n:match("HOOK_.*")) then
			if not(hooksToIgnore[n]) then
				LOG("Adding notification for hook " .. n .. " (" .. v .. ").")
				cPluginManager.AddHook(v,
					function (...)
						LOG(n .. "(")
						for i, param in ipairs(arg) do
							LOG("  " .. i .. ": " .. tolua.type(param) .. ": " .. tostring(param))
						end
						LOG(")");
					end  -- hook handler
				)  -- AddHook
			end  -- not (ignore)
		end  -- n matches "HOOK"
	end  -- for cPluginManager{}
	
	-- OnTakeDamage has a special handler listing the details of the damage dealt:
	cPluginManager.AddHook(cPluginManager.HOOK_TAKE_DAMAGE,
		function (a_Receiver, a_TDI)
			-- a_Receiver is cPawn
			-- a_TDI is TakeDamageInfo

			LOG("OnTakeDamage(): " .. a_Receiver:GetClass() .. " was dealt RawDamage " .. a_TDI.RawDamage .. ", FinalDamage " .. a_TDI.FinalDamage .. " (that is, " .. (a_TDI.RawDamage - a_TDI.FinalDamage) .. " HPs covered by armor)");
		end
	)
	
	return true
end



