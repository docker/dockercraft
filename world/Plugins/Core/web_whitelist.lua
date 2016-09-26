
-- web_whitelist.lua

-- Implements the webadmin page for handling whitelist





local ins = table.insert
local con = table.concat





--- Returns the HTML code for an action button specific for the specified player
-- a_Player should be the player's description, as returned by ListWhitelistedPlayers()
local function getPlayerActionButton(a_Action, a_Caption, a_Player)
	-- Check params:
	assert(type(a_Action)  == "string")
	assert(type(a_Caption) == "string")
	assert(type(a_Player)  == "table")
	
	-- Put together the code for the form:
	local res = { "<form method='POST'><input type='hidden' name='action' value='" }
	ins(res, a_Action)
	ins(res, "'/><input type='submit' value='")
	ins(res, a_Caption)
	ins(res, "'/><input type='hidden' name='playername' value='")
	ins(res, a_Player.Name)
	ins(res, "'/></form> ")
	return con(res)
end





--- Returns the table row for a single player
-- a_Player should be the player's description, as returned by ListWhitelistedPlayers()
local function getPlayerRow(a_Player)
	-- Check the params:
	assert(type(a_Player) == "table")

	-- Put together the code for the entire row:
	local res = { "<tr><td>" }
	ins(res, cWebAdmin:GetHTMLEscapedString(a_Player.Name))
	ins(res, "</td><td>")
	ins(res, os.date("%Y-%m-%d %H:%M:%S", a_Player.Timestamp or 0))
	ins(res, "</td><td>")
	ins(res, cWebAdmin:GetHTMLEscapedString(a_Player.WhitelistedBy or "<unknown>"))
	ins(res, "</td><td>")
	ins(res, getPlayerActionButton("delplayer", "Remove", a_Player))
	ins(res, "</td></tr>")
	return con(res)
end





--- Returns the list of whitelisted players
local function showList(a_Request)
	-- Show the whitelist status - enabled or disabled:
	local res = { "<table><tr><td>" }
	if (IsWhitelistEnabled()) then
		ins(res, "Whitelist is <b>ENABLED</b></td><td colspan=3><form method='POST'><input type='hidden' name='action' value='disable'/><input type='submit' value='Disable'/>")
	else
		ins(res, "Whitelist is <b>DISABLED</b></td><td colspan=3><form method='POST'><input type='hidden' name='action' value='enable'/><input type='submit' value='Enable'/>")
	end
	ins(res, "</form></td></tr><tr><td colspan=4><hr/><br/></td></tr>")
	
	-- Add the form to whitelist players:
	ins(res, "<tr><td colspan=4>Add player to whitelist: ")
	ins(res, "<form method='POST'><input type='hidden' name='action' value='addplayer'/><input type='text' name='playername' value='' hint='Player name'/>")
	ins(res, "<input type='submit' value='Add'/></form></td></tr><tr><td colspan=4><hr/><br/></td></tr>")
	
	-- Show the whitelisted players:
	local players = ListWhitelistedPlayers()
	if (players[1] == nil) then
		ins(res, "<tr><td colspan=4>There are no players in the whitelist.</td></tr>")
	else
		ins(res, "<tr><th>Name</th><th>Date whitelisted</th><th>Whitelisted by</th><th>Action</th></tr>")
		for _, player in ipairs(players) do
			ins(res, getPlayerRow(player))
		end
	end
	
	return con(res)
end





--- Processes the "addplayer" action, whitelisting the specified player and returning the player list
local function showAddPlayer(a_Request)
	-- Check HTML params:
	local playerName = a_Request.PostParams["playername"] or ""
	if (playerName == "") then
		return HTMLError("Cannot add player, bad name") .. showList(a_Request)
	end
	
	-- Whitelist the player:
	AddPlayerToWhitelist(playerName, "<web: " .. a_Request.Username .. ">")
	
	-- Redirect back to the whitelist:
	return showList(a_Request)
end





--- Processes the "delplayer" action, unwhitelisting the specified player and returning the player list
local function showDelPlayer(a_Request)
	-- Check HTML params:
	local playerName = a_Request.PostParams["playername"] or ""
	if (playerName == "") then
		return HTMLError("Cannot remove player, bad name") .. showList(a_Request)
	end
	
	-- Whitelist the player:
	RemovePlayerFromWhitelist(playerName)
	
	-- Redirect back to the whitelist:
	return showList(a_Request)
end





--- Processes the "disable" action, disabling the whitelist and returning the player list
local function showDisableWhitelist(a_Request)
	WhitelistDisable()
	return showList(a_Request)
end





--- Processes the "disable" action, disabling the whitelist and returning the player list
local function showEnableWhitelist(a_Request)
	WhitelistEnable()
	return showList(a_Request)
end





--- The table of all actions supported by this web tab:
local g_ActionHandlers =
{
	[""]          = showList,
	["addplayer"] = showAddPlayer,
	["delplayer"] = showDelPlayer,
	["disable"]   = showDisableWhitelist,
	["enable"]    = showEnableWhitelist,
}





function HandleRequest_WhiteList(a_Request)
	local action = a_Request.PostParams["action"] or ""
	local handler = g_ActionHandlers[action]
	if (handler == nil) then
		return HTMLError("Error in whitelist processing: no action handler found for action \"" .. action .. "\"")
	end
	return handler(a_Request)
end




