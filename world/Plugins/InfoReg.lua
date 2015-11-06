
-- InfoReg.lua

-- Implements registration functions that process g_PluginInfo





--- Lists all the subcommands that the player has permissions for
local function ListSubcommands(a_Player, a_Subcommands, a_CmdString)
	if (a_Player == nil) then
		LOGINFO("The " .. a_CmdString .. " command requires another verb:")
	else
		a_Player:SendMessage("The " .. a_CmdString .. " command requires another verb:")
	end
	
	-- Enum all the subcommands:
	local Verbs = {}
	for cmd, info in pairs(a_Subcommands) do
		if ((a_Player == nil) or (a_Player:HasPermission(info.Permission or ""))) then
			table.insert(Verbs, a_CmdString .. " " .. cmd)
		end
	end
	table.sort(Verbs)
	
	-- Send the list:
	if (a_Player == nil) then
		for idx, verb in ipairs(Verbs) do
			LOGINFO("  " .. verb)
		end
	else
		for idx, verb in ipairs(Verbs) do
			a_Player:SendMessage(cCompositeChat("  ", mtInfo):AddSuggestCommandPart(verb, verb))
		end
	end
end





--- This is a generic command callback used for handling multicommands' parent commands
-- For example, if there are "/gal save" and "/gal load" commands, this callback handles the "/gal" command
-- It is used for both console and in-game commands; the console version has a_Player set to nil
local function MultiCommandHandler(a_Split, a_Player, a_CmdString, a_CmdInfo, a_Level, a_EntireCommand)
	local Verb = a_Split[a_Level + 1]
	if (Verb == nil) then
		-- No verb was specified. If there is a handler for the upper level command, call it:
		if (a_CmdInfo.Handler ~= nil) then
			return a_CmdInfo.Handler(a_Split, a_Player, a_EntireCommand)
		end
		-- Let the player know they need to give a subcommand:
		assert(type(a_CmdInfo.Subcommands) == "table", "Info.lua error: There is no handler for command \"" .. a_CmdString .. "\" and there are no subcommands defined at level " .. a_Level)
		ListSubcommands(a_Player, a_CmdInfo.Subcommands, a_CmdString)
		return true
	end
	
	-- A verb was specified, look it up in the subcommands table:
	local Subcommand = a_CmdInfo.Subcommands[Verb]
	if (Subcommand == nil) then
		if (a_Level > 1) then
			-- This is a true subcommand, display the message and make MCS think the command was handled
			-- Otherwise we get weird behavior: for "/cmd verb" we get "unknown command /cmd" although "/cmd" is valid
			if (a_Player == nil) then
				LOGWARNING("The " .. a_CmdString .. " command doesn't support verb " .. Verb)
			else
				a_Player:SendMessage("The " .. a_CmdString .. " command doesn't support verb " .. Verb)
			end
			return true
		end
		-- This is a top-level command, let MCS handle the unknown message
		return false;
	end
	
	-- Check the permission:
	if (a_Player ~= nil) then
		if not(a_Player:HasPermission(Subcommand.Permission or "")) then
			a_Player:SendMessage("You don't have permission to execute this command")
			return true
		end
	end
	
	-- If the handler is not valid, check the next sublevel:
	if (Subcommand.Handler == nil) then
		if (Subcommand.Subcommands == nil) then
			LOG("Cannot find handler for command " .. a_CmdString .. " " .. Verb)
			return false
		end
		return MultiCommandHandler(a_Split, a_Player, a_CmdString .. " " .. Verb, Subcommand, a_Level + 1, a_EntireCommand)
	end
	
	-- Execute:
	return Subcommand.Handler(a_Split, a_Player, a_EntireCommand)
end





--- Registers all commands specified in the g_PluginInfo.Commands
function RegisterPluginInfoCommands()
	-- A sub-function that registers all subcommands of a single command, using the command's Subcommands table
	-- The a_Prefix param already contains the space after the previous command
	-- a_Level is the depth of the subcommands being registered, with 1 being the top level command
	local function RegisterSubcommands(a_Prefix, a_Subcommands, a_Level)
		assert(a_Subcommands ~= nil)
		
		-- A table that will hold aliases to subcommands temporarily, during subcommand iteration
		local AliasTable = {}
		
		-- Iterate through the subcommands, register them, and accumulate aliases:
		for cmd, info in pairs(a_Subcommands) do
			local CmdName = a_Prefix .. cmd
			local Handler = info.Handler
			-- Provide a special handler for multicommands:
			if (info.Subcommands ~= nil) then
				Handler = function(a_Split, a_Player, a_EntireCommand)
					return MultiCommandHandler(a_Split, a_Player, CmdName, info, a_Level, a_EntireCommand)
				end
			end
			
			if (Handler == nil) then
				LOGWARNING(g_PluginInfo.Name .. ": Invalid handler for command " .. CmdName .. ", command will not be registered.")
			else
				local HelpString
				if (info.HelpString ~= nil) then
					HelpString = " - " .. info.HelpString
				else
					HelpString = ""
				end
				cPluginManager.BindCommand(CmdName, info.Permission or "", Handler, HelpString)
				-- Register all aliases for the command:
				if (info.Alias ~= nil) then
					if (type(info.Alias) == "string") then
						info.Alias = {info.Alias}
					end
					for idx, alias in ipairs(info.Alias) do
						cPluginManager.BindCommand(a_Prefix .. alias, info.Permission or "", Handler, HelpString)
						-- Also copy the alias's info table as a separate subcommand,
						-- so that MultiCommandHandler() handles it properly. Need to off-load into a separate table
						-- than the one we're currently iterating and join after the iterating.
						AliasTable[alias] = info
					end
				end
			end  -- else (if Handler == nil)
			
			-- Recursively register any subcommands:
			if (info.Subcommands ~= nil) then
				RegisterSubcommands(a_Prefix .. cmd .. " ", info.Subcommands, a_Level + 1)
			end
		end  -- for cmd, info - a_Subcommands[]
		
		-- Add the subcommand aliases that were off-loaded during registration:
		for alias, info in pairs(AliasTable) do
			a_Subcommands[alias] = info
		end
		AliasTable = {}
	end
	
	-- Loop through all commands in the plugin info, register each:
	RegisterSubcommands("", g_PluginInfo.Commands, 1)
end





--- Registers all console commands specified in the g_PluginInfo.ConsoleCommands
function RegisterPluginInfoConsoleCommands()
	-- A sub-function that registers all subcommands of a single command, using the command's Subcommands table
	-- The a_Prefix param already contains the space after the previous command
	local function RegisterSubcommands(a_Prefix, a_Subcommands, a_Level)
		assert(a_Subcommands ~= nil)
		
		for cmd, info in pairs(a_Subcommands) do
			local CmdName = a_Prefix .. cmd
			local Handler = info.Handler
			if (Handler == nil) then
				Handler = function(a_Split, a_EntireCommand)
					return MultiCommandHandler(a_Split, nil, CmdName, info, a_Level, a_EntireCommand)
				end
			end
			cPluginManager.BindConsoleCommand(CmdName, Handler, info.HelpString or "")
			-- Recursively register any subcommands:
			if (info.Subcommands ~= nil) then
				RegisterSubcommands(a_Prefix .. cmd .. " ", info.Subcommands, a_Level + 1)
			end
		end
	end
	
	-- Loop through all commands in the plugin info, register each:
	RegisterSubcommands("", g_PluginInfo.ConsoleCommands, 1)
end




