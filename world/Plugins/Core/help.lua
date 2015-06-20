
-- help.lua

-- Implements the /help in-game command





--- How many commands to put into one help page
local g_CommandsPerPage = 8




--- Displays one page of help for commands beginning with the specified string
-- If a_Beginning is not given, all commands are displayed
local function handleHelpPage(a_Player, a_PageNumber, a_Beginning)
	-- Check params:
	assert(type(a_PageNumber) == "number")
	assert(tolua.type(a_Player) == "cPlayer")
	a_Beginning = a_Beginning or ""
	assert(type(a_Beginning) == "string")
	
	-- Collect all commands into a table:
	local output = {}
	local beginLen = a_Beginning:len()
	cPluginManager:Get():ForEachCommand(
		function(a_CBCommand, a_CBPermission, a_CBHelpString)
			if not (a_Player:HasPermission(a_CBPermission)) then
				-- Do not display commands for which the player has no permission
				return false
			end
			if (a_CBHelpString == "") then
				-- Do not display commands without a help string
				return false
			end
			-- Check that the command contains the wanted string:
			if (a_CBCommand:sub(1, beginLen) == a_Beginning) then
				table.insert(output, a_CBCommand .. " " .. a_CBHelpString)
			end
		end
	)

	-- Check the page count:
	local numCommands = #output
	if (numCommands == 0) then
		a_Player:SendMessageFailure("No commands available")
		return true
	end
	local firstLine = (a_PageNumber - 1) * g_CommandsPerPage + 1
	local lastLine = firstLine + g_CommandsPerPage
	local maxPages = math.ceil(numCommands / g_CommandsPerPage)
	if (firstLine > numCommands) then
		a_Player:SendMessageFailure("The requested page is not available. Only pages 1 - " .. maxPages .. " are available.")
		return true
	end

	-- Display only the requested page:
	table.sort(output)
	a_Player:SendMessageInfo("Displaying page " .. a_PageNumber .. " of " .. maxPages .. ":")
	for idx, txt in ipairs(output) do
		if ((idx >= firstLine) and (idx < lastLine)) then
			a_Player:SendMessage(txt)
		end
	end
	return true
end





--- Decides what help to show based on the parameters, calls the appropriate worker function
function HandleHelpCommand(a_Split, a_Player)
	-- Handles the "/help [<PageNum>] [<CommandText>]" in-game command
	-- If there's no param, display the first page of help:
	local numSplit = #a_Split
	if (numSplit == 1) then
		return handleHelpPage(a_Player, 1)
	end
	
	-- If there is a number as the first param, show that page:
	local pageRequested = tonumber(a_Split[2])
	local filterStart = 3
	if (pageRequested == nil) then
		filterStart = 2
		pageRequested = 1
	end
	local beginningWanted
	if (numSplit >= filterStart) then
		beginningWanted = "/" .. table.concat(a_Split, " ", filterStart)
	end
	return handleHelpPage(a_Player, pageRequested, beginningWanted)
end




