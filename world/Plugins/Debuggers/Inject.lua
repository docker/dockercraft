-- Inject.lua

-- This file gets injected into the Core plugin when testing the inter-plugin calls with the "testcall" command
-- However, since this is a .lua file, it also gets loaded into the Debuggers plugin, so we need to distinguish the two





--- Prints the specified table to the log, using the specified indent
-- Assumes there are no cycles in the table and all keys and values can be turned to strings
local function printTable(a_Table, a_Indent)
	for k, v in pairs(a_Table) do
		LOG(a_Indent .. "k = " .. tostring(k))
		if (type(k) == "table") then
			printTable(k, a_Indent .. "  ")
		end
		LOG(a_Indent .. "v = " .. tostring(v))
		if (type(v) == "table") then
			printTable(v, a_Indent .. "  ")
		end
	end
end





local function printParams(...)
	LOG("printParams:")
	for idx, param in ipairs({...}) do
		LOG("  param" .. idx .. ": " .. tostring(param))
		if (type(param) == "table") then
			printTable(param, "    ")
		end
	end
	LOG("done")
	return true
end





local pluginName = cPluginManager:Get():GetCurrentPlugin():GetName()
if (pluginName ~= "Debuggers") then
	-- We're in the destination plugin
	LOG("Loaded Inject.lua into " .. pluginName)
	injectedPrintParams = printParams
	return true
else
	-- We're in the Debuggers plugin, do nothing
end




