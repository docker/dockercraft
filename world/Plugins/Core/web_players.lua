
-- web_players.lua

-- Implements the Players tab in the webadmin





local ins = table.insert
local con = table.concat





--- Enumerates all players currently connected to the server
-- Returns an array-table in which each item has PlayerName, PlayerUUID and WorldName
local function EnumAllPlayers()
	local res = {}
	
	-- Insert each player into the table:
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			ins(res, {
				PlayerName = a_Player:GetName(),
				PlayerUUID = a_Player:GetUUID(),
				WorldName = a_Player:GetWorld():GetName(),
				EntityID = a_Player:GetUniqueID()
			})
		end
	)
	
	return res
end





--- Returns the HTML for a single table row describing the specified player
-- a_Player is the player item, a table containing PlayerName, PlayerUUID, WorldName and EntityID, as
-- returned by EnumAllPlayers
local function GetPlayerRow(a_Player)
	-- Check params:
	assert(type(a_Player) == "table")
	assert(type(a_Player.PlayerName) == "string")
	assert(type(a_Player.PlayerUUID) == "string")
	assert(type(a_Player.WorldName) == "string")
	assert(type(a_Player.EntityID) == "number")
	
	local Row = {"<tr>"}
	
	-- First column: player name:
	ins(Row, "<td>")
	ins(Row, cWebAdmin:GetHTMLEscapedString(a_Player.PlayerName))
	ins(Row, "</td>")
	
	-- Second column: rank:
	local RankName = cWebAdmin:GetHTMLEscapedString(cRankManager:GetPlayerRankName(a_Player.PlayerUUID))
	if (RankName == "") then
		RankName = cWebAdmin:GetHTMLEscapedString(cRankManager:GetDefaultRank())
	end
	ins(Row, "<td>")
	ins(Row, RankName)
	ins(Row, "</td>")
	
	-- Third row: actions:
	local PlayerIdent =
	{
		WorldName  = a_Player.WorldName,
		EntityID   = a_Player.EntityID,
		PlayerName = a_Player.PlayerName,
		PlayerUUID = a_Player.PlayerUUID,
	}
	ins(Row, "<td><form method='GET' style='float: left'>")
	ins(Row, GetFormButton("details", "View details", PlayerIdent))
	ins(Row, "</form> <form method='GET' style='float: left'>")
	ins(Row, GetFormButton("sendpm", "Send PM", PlayerIdent))
	ins(Row, "</form> <form method='POST' style='float: left'>")
	ins(Row, GetFormButton("kick", "Kick", PlayerIdent))
	ins(Row, "</form></td>")
	
	-- Finish the row:
	ins(Row, "</tr>")
	return con(Row)
end





--- Displays the Position details table in the Player details page
local function GetPositionDetails(a_PlayerIdent)
	-- Get the player info:
	local PlayerInfo = {}
	local World = cRoot:Get():GetWorld(a_PlayerIdent.WorldName)
	if (World == nil) then
		return HTMLError("Error querying player position details - no world.")
	end
	World:DoWithEntityByID(a_PlayerIdent.EntityID,
		function(a_Entity)
			if not(a_Entity:IsPlayer()) then
				return
			end
			local Player = tolua.cast(a_Entity, "cPlayer")
			PlayerInfo.Pos = Player:GetPosition()
			PlayerInfo.LastBedPos = Player:GetLastBedPos()
			PlayerInfo.Found = true
			-- TODO: Other info?
		end
	)

	-- If the player is not present (disconnected in the meantime), display no info:
	if not(PlayerInfo.Found) then
		return ""
	end
	
	-- Display the current world and coords:
	local Page =
	{
		"<table><tr><th>Current world</th><td>",
		cWebAdmin:GetHTMLEscapedString(a_PlayerIdent.WorldName),
		"</td></tr><tr><th>Position</th><td>X: ",
		tostring(math.floor(PlayerInfo.Pos.x * 1000) / 1000),
		"<br/>Y: ",
		tostring(math.floor(PlayerInfo.Pos.y * 1000) / 1000),
		"<br/>Z: ",
		tostring(math.floor(PlayerInfo.Pos.z * 1000) / 1000),
		"</td></tr><tr><th>Last bed position</th><td>X: ",
		tostring(PlayerInfo.LastBedPos.x),
		"<br/>Y: ",
		tostring(PlayerInfo.LastBedPos.y),
		"<br/>Z: ",
		tostring(PlayerInfo.LastBedPos.z),
		"</td></tr></table>"

		--[[
		-- TODO
		-- Add teleport control page:
		"<h4>Teleport control</h4><table><th>Spawn</th><td><form method='POST'>",
		GetFormButton("teleportcoord", "Teleport to spawn", a_PlayerIdent)
		--]]
}
	
	return con(Page)
end





--- Displays the Rank details table in the Player details page
local function GetRankDetails(a_PlayerIdent)
	-- Display the current rank and its permissions:
	local RankName = cWebAdmin:GetHTMLEscapedString(cRankManager:GetPlayerRankName(a_PlayerIdent.PlayerUUID))
	if (RankName == "") then
		RankName = cWebAdmin:GetHTMLEscapedString(cRankManager:GetDefaultRank())
	end
	local Permissions = cRankManager:GetPlayerPermissions(a_PlayerIdent.PlayerUUID)
	table.sort(Permissions)
	local Page =
	{
		"<h4>Rank</h4><table><tr><th>Current rank</th><td>",
		RankName,
		"</td></tr><tr><th>Permissions</th><td>",
		con(Permissions, "<br/>"),
		"</td></tr>",
	}
		
	-- Let the admin change the rank using a combobox:
	ins(Page, "<tr><th>Change rank</th><td><form method='POST'><select name='RankName'>")
	local AllRanks = cRankManager:GetAllRanks()
	table.sort(AllRanks)
	for _, rank in ipairs(AllRanks) do
		local HTMLRankName = cWebAdmin:GetHTMLEscapedString(rank)
		ins(Page, "<option value='")
		ins(Page, HTMLRankName)
		if (HTMLRankName == RankName) then
			ins(Page, "' selected>")
		else
			ins(Page, "'>")
		end
		ins(Page, HTMLRankName)
		ins(Page, "</option>")
	end
	ins(Page, "</select>")
	ins(Page, GetFormButton("setrank", "Change rank", a_PlayerIdent))
	ins(Page, "</form></td></tr></table>")
	
	return con(Page)
end





--- Displays the main Players page
-- Contains a per-world tables of all the players connected to the server
local function ShowMainPlayersPage(a_Request)
	-- Get all players:
	local AllPlayers = EnumAllPlayers()
	
	-- Get all worlds:
	local PerWorldPlayers = {}  -- Contains a map: WorldName -> {Players}
	local WorldNames = {}  -- Contains an array of world names
	cRoot:Get():ForEachWorld(
		function(a_World)
			local WorldName = a_World:GetName()
			PerWorldPlayers[WorldName] = {}
			ins(WorldNames, WorldName)
		end
	)
	table.sort(WorldNames)
	
	-- Translate the list into a per-world list:
	for _, player in ipairs(AllPlayers) do
		local PerWorld = PerWorldPlayers[player.WorldName]
		ins(PerWorld, player)
	end
	
	-- For each world, display a table of players:
	local Page = {}
	for _, worldname in ipairs(WorldNames) do
		ins(Page, "<h4>")
		ins(Page, worldname)
		ins(Page, "</h4><table><tr><th>Player</th><th>Rank</th><th>Actions</th></tr>")
		table.sort(PerWorldPlayers[worldname],
			function (a_Player1, a_Player2)
				return (a_Player1.PlayerName < a_Player2.PlayerName)
			end
		)
		for _, player in ipairs(PerWorldPlayers[worldname]) do
			ins(Page, GetPlayerRow(player))
		end
		ins(Page, "</table><p>Total players in world: ")
		ins(Page, tostring(#PerWorldPlayers[worldname]))
		ins(Page, "</p>")
	end
	
	return con(Page)
end





--- Displays the player details page
local function ShowDetailsPage(a_Request)
	-- Check params:
	local WorldName  = a_Request.PostParams["WorldName"]
	local EntityID   = a_Request.PostParams["EntityID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	if ((WorldName == nil) or (EntityID == nil) or (PlayerName == nil) or (PlayerUUID == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Stuff the parameters into a table:
	local PlayerIdent =
	{
		PlayerName = PlayerName,
		WorldName  = WorldName,
		EntityID   = EntityID,
		PlayerUUID = PlayerUUID,
	}
	
	-- Add the header:
	local Page =
	{
		"<p>Back to <a href='/",
		a_Request.Path,
		"'>player list</a>.</p>",
	}
	
	-- Display the position details:
	ins(Page, GetPositionDetails(PlayerIdent))
	
	-- Display the rank details:
	ins(Page, GetRankDetails(PlayerIdent))
	
	return con(Page)
end





--- Handles the KickPlayer button in the main page
-- Kicks the player and redirects the admin back to the player list
local function ShowKickPlayerPage(a_Request)
	-- Check params:
	local WorldName  = a_Request.PostParams["WorldName"]
	local EntityID   = a_Request.PostParams["EntityID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	if ((WorldName == nil) or (EntityID == nil) or (PlayerName == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Get the world:
	local World = cRoot:Get():GetWorld(WorldName)
	if (World == nil) then
		return HTMLError("Bad request, no such world.")
	end
	
	-- Kick the player:
	World:DoWithEntityByID(EntityID,
		function(a_Entity)
			if (a_Entity:IsPlayer()) then
				local Client = tolua.cast(a_Entity, "cPlayer"):GetClientHandle()
				if (Client ~= nil) then
					Client:Kick(a_Request.PostParams["Reason"] or "Kicked from webadmin")
				else
					LOG("Client is nil")
				end
			end
		end
	)
	
	-- Redirect the admin back to the player list:
	return "<p>Player kicked. <a href='/" .. a_Request.Path .. "'>Return to player list</a>.</p>"
end





--- Displays the SendPM subpage allowing the admin to send a PM to the player
local function ShowSendPMPage(a_Request)
	-- Check params:
	local WorldName  = a_Request.PostParams["WorldName"]
	local EntityID   = a_Request.PostParams["EntityID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	if ((WorldName == nil) or (EntityID == nil) or (PlayerName == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Show the form for entering the message:
	local PlayerIdent =
	{
		PlayerName = PlayerName,
		WorldName  = WorldName,
		EntityID   = EntityID,
	}
	return table.concat({
		"<h4>Send a message</h4><table><tr><th>Player</th><td>",
		cWebAdmin:GetHTMLEscapedString(PlayerName),
		"</td></tr><tr><th>Message</th><td><form method='POST'><input type='text' name='Msg' size=50/>",
		"</td></tr><tr><th/><td>",
		GetFormButton("sendpmproc", "Send message", PlayerIdent),
		"</td></tr></table>"
	})
end





--- Handles the message form from the SendPM page
-- Sends the PM, redirects the admin back to the player list
local function ShowSendPMProcPage(a_Request)
	-- Check params:
	local WorldName  = a_Request.PostParams["WorldName"]
	local EntityID   = a_Request.PostParams["EntityID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	local Msg        = a_Request.PostParams["Msg"]
	if ((WorldName == nil) or (EntityID == nil) or (PlayerName == nil) or (Msg == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Send the PM:
	local World = cRoot:Get():GetWorld(WorldName)
	if (World ~= nil) then
		World:DoWithEntityByID(EntityID,
			function(a_Entity)
				if (a_Entity:IsPlayer()) then
					SendMessage(tolua.cast(a_Entity, "cPlayer"), Msg)
				end
			end
		)
	end
	
	-- Redirect the admin back to the player list:
	return "<p>Message sent. <a href='/" .. a_Request.Path .. "'>Return to player list</a>.</p>"
end





--- Processes the SetRank form in the player details page
-- Sets the player's rank and redirects the admin back to the player details page
local function ShowSetRankPage(a_Request)
	-- Check params:
	local WorldName  = a_Request.PostParams["WorldName"]
	local EntityID   = a_Request.PostParams["EntityID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	local RankName   = a_Request.PostParams["RankName"]
	if ((WorldName == nil) or (EntityID == nil) or (PlayerName == nil) or (PlayerUUID == nil) or (RankName == nil)) then
		return HTMLError("Bad request, missing parameters.")
	end
	
	-- Change the player's rank:
	cRankManager:SetPlayerRank(PlayerUUID, PlayerName, RankName)
	
	-- Update each in-game player:
	cRoot:Get():ForEachPlayer(
		function(a_CBPlayer)
			if (a_CBPlayer:GetName() == PlayerName) then
				a_CBPlayer:SendMessage("You were assigned the rank " .. RankName .. " by webadmin.")
				a_CBPlayer:LoadRank()
			end
		end
	)
	
	-- Redirect the admin back to the player list:
	return con({
		"<p>Rank changed. <a href='/",
		a_Request.Path,
		"?subpage=details&PlayerName=",
		cWebAdmin:GetHTMLEscapedString(PlayerName),
		"&PlayerUUID=",
		cWebAdmin:GetHTMLEscapedString(PlayerUUID),
		"&WorldName=",
		cWebAdmin:GetHTMLEscapedString(WorldName),
		"&EntityID=",
		cWebAdmin:GetHTMLEscapedString(EntityID),
		"'>Return to player details</a>.</p>"
	})
end





--- Handlers for the individual subpages in this tab
-- Each item maps a subpage name to a handler function that receives a HTTPRequest object and returns the HTML to return
local g_SubpageHandlers =
{
	[""]           = ShowMainPlayersPage,
	["details"]    = ShowDetailsPage,
	["kick"]       = ShowKickPlayerPage,
	["sendpm"]     = ShowSendPMPage,
	["sendpmproc"] = ShowSendPMProcPage,
	["setrank"]    = ShowSetRankPage,
}





--- Handles the web request coming from MCS
-- Returns the entire tab's HTML contents, based on the player's request
function HandleRequest_Players(a_Request)
	local Subpage = (a_Request.PostParams["subpage"] or "")
	local Handler = g_SubpageHandlers[Subpage]
	if (Handler == nil) then
		return HTMLError("An internal error has occurred, no handler for subpage " .. Subpage .. ".")
	end
	
	local PageContent = Handler(a_Request)
	
	--[[
	-- DEBUG: Save content to a file for debugging purposes:
	local f = io.open("players.html", "wb")
	if (f ~= nil) then
		f:write(PageContent)
		f:close()
	end
	--]]
	
	return PageContent
end




