
-- InfoReg.lua

-- Implements registration functions that process g_PluginInfo





--- Lists all the subcommands that the player has permissions for
local function ListSubcommands(a_Player, a_Subcommands, a_CmdString)
	a_Player:SendMessage("The " .. a_CmdString .. " command requires another verb:");
	local Verbs = {};
	for cmd, info in pairs(a_Subcommands) do
		if (a_Player:HasPermission(info.Permission or "")) then
			table.insert(Verbs, a_CmdString .. " " .. cmd);
		end
	end
	table.sort(Verbs);
	for idx, verb in ipairs(Verbs) do
		a_Player:SendMessage(verb);
	end
end





--- This is a generic command callback used for handling multicommands' parent commands
-- For example, if there are "/gal save" and "/gal load" commands, this callback handles the "/gal" command
local function MultiCommandHandler(a_Split, a_Player, a_CmdString, a_CmdInfo, a_Level)
	local Verb = a_Split[a_Level + 1];
	if (Verb == nil) then
		-- No verb was specified. If there is a handler for the upper level command, call it:
		if (a_CmdInfo.Handler ~= nil) then
			return a_CmdInfo.Handler(a_Split, a_Player);
		end
		-- Let the player know they need to give a subcommand:
		ListSubcommands(a_Player, a_CmdInfo.Subcommands, a_CmdString);
		return true;
	end
	
	-- A verb was specified, look it up in the subcommands table:
	local Subcommand = a_CmdInfo.Subcommands[Verb];
	if (Subcommand == nil) then
		if (a_Level > 1) then
			-- This is a true subcommand, display the message and make MCS think the command was handled
			-- Otherwise we get weird behavior: for "/cmd verb" we get "unknown command /cmd" although "/cmd" is valid
			a_Player:SendMessage("The " .. a_CmdString .. " command doesn't support verb " .. Verb);
			return true;
		end
		-- This is a top-level command, let MCS handle the unknown message
		return false;
	end
	
	-- Check the permission:
	if not(a_Player:HasPermission(Subcommand.Permission or "")) then
		a_Player:SendMessage("You don't have permission to execute this command");
		return true;
	end
	
	-- Check if the handler is valid:
	if (Subcommand.Handler == nil) then
		if (Subcommand.Subcommands == nil) then
			LOG("Cannot find handler for command " .. a_CmdString .. " " .. Verb);
			return false;
		end
		ListSubcommands(a_Player, Subcommand.Subcommands, a_CmdString .. " " .. Verb);
		return true;
	end
	
	-- Execute:
	return Subcommand.Handler(a_Split, a_Player);
end





--- Registers all commands specified in the g_PluginInfo.Commands
function RegisterPluginInfoCommands()
	-- A sub-function that registers all subcommands of a single command, using the command's Subcommands table
	-- The a_Prefix param already contains the space after the previous command
	-- a_Level is the depth of the subcommands being registered, with 1 being the top level command
	local function RegisterSubcommands(a_Prefix, a_Subcommands, a_Level)
		assert(a_Subcommands ~= nil);
		
		for cmd, info in pairs(a_Subcommands) do
			local CmdName = a_Prefix .. cmd;
			local Handler = info.Handler;
			-- Provide a special handler for multicommands:
			if (info.Subcommands ~= nil) then
				Handler = function(a_Split, a_Player)
					return MultiCommandHandler(a_Split, a_Player, CmdName, info, a_Level);
				end
			end
			
			if (Handler == nil) then
				LOGWARNING(g_PluginInfo.Name .. ": Invalid handler for command " .. CmdName .. ", command will not be registered.");
			else
				cPluginManager.BindCommand(CmdName, info.Permission or "", Handler, info.HelpString or "");
				-- Register all aliases for the command:
				if (info.Alias ~= nil) then
					if (type(info.Alias) == "string") then
						info.Alias = {info.Alias};
					end
					for idx, alias in ipairs(info.Alias) do
						cPluginManager.BindCommand(a_Prefix .. alias, info.Permission or "", info.Handler, info.HelpString or "");
					end
				end
			end
			
			-- Recursively register any subcommands:
			if (info.Subcommands ~= nil) then
				RegisterSubcommands(a_Prefix .. cmd .. " ", info.Subcommands, a_Level + 1);
			end
		end
	end
	
	-- Loop through all commands in the plugin info, register each:
	RegisterSubcommands("", g_PluginInfo.Commands, 1);
end





--- Registers all console commands specified in the g_PluginInfo.ConsoleCommands
function RegisterPluginInfoConsoleCommands()
	-- A sub-function that registers all subcommands of a single command, using the command's Subcommands table
	-- The a_Prefix param already contains the space after the previous command
	local function RegisterSubcommands(a_Prefix, a_Subcommands)
		assert(a_Subcommands ~= nil);
		
		for cmd, info in pairs(a_Subcommands) do
			local CmdName = a_Prefix .. cmd;
			cPluginManager.BindConsoleCommand(cmd, info.Handler, info.HelpString or "");
			-- Recursively register any subcommands:
			if (info.Subcommands ~= nil) then
				RegisterSubcommands(a_Prefix .. cmd .. " ", info.Subcommands);
			end
		end
	end
	
	-- Loop through all commands in the plugin info, register each:
	RegisterSubcommands("", g_PluginInfo.ConsoleCommands);
end




