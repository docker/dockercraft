
-- web_playerranks.lua

-- Implements the Player Ranks tab in the webadmin





--- Maximum number of players displayed on a single page.
local PLAYERS_PER_PAGE = 20

local ins = table.insert
local con = table.concat





--- Updates the rank from the ingame player with this uuid
local function UpdateIngamePlayer(a_PlayerUUID, a_Message)
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			if (a_Player:GetUUID() == a_PlayerUUID) then
				if (a_Message ~= "") then
					a_Player:SendMessage(a_Message)
				end
				a_Player:LoadRank()
			end
		end
	)
end





--- Returns the HTML contents of the rank list
local function GetRankList(a_SelectedRank)
	local RankList = {}
	ins(RankList, "<select name='RankName'>")

	local AllRanks = cRankManager:GetAllRanks()
	table.sort(AllRanks)

	for _, Rank in ipairs(AllRanks) do
		local HTMLRankName = cWebAdmin:GetHTMLEscapedString(Rank)
		ins(RankList, "<option value='")
		ins(RankList, HTMLRankName)
		if (HTMLRankName == a_SelectedRank) then
			ins(RankList, "' selected>")
		else
			ins(RankList, "'>")
		end
		ins(RankList, HTMLRankName)
		ins(RankList, "</option>")
	end
	ins(RankList, "</select>")

	return con(RankList)
end





--- Returns the HTML contents of a single row in the Players table
local function GetPlayerRow(a_PlayerUUID)
	-- Get the player name/rank:
	local PlayerName = cRankManager:GetPlayerName(a_PlayerUUID)
	local PlayerRank = cRankManager:GetPlayerRankName(a_PlayerUUID)

	-- First row: player name:
	local Row = {"<tr><td>"}
	ins(Row, cWebAdmin:GetHTMLEscapedString(PlayerName))
	ins(Row, "</td><td>")

	-- Rank:
	ins(Row, cWebAdmin:GetHTMLEscapedString(PlayerRank))

	-- Display actions for this player:
	ins(Row, "</td><td><form style='float: left'>")
	ins(Row, GetFormButton("editplayer", "Edit", {PlayerUUID = a_PlayerUUID}))
	ins(Row, "</form><form style='float: left'>")
	ins(Row, GetFormButton("confirmdel", "Remove rank", {PlayerUUID = a_PlayerUUID, PlayerName = PlayerName}))

	-- Terminate the row and return the entire concatenated string:
	ins(Row, "</form></td></tr>")
	return con(Row)
end





--- Returns the HTML contents of the main Rankplayers page
local function ShowMainPlayersPage(a_Request)
	-- Read the page number:
	local PageNumber = tonumber(a_Request.Params["PageNumber"])
	if (PageNumber == nil) then
		PageNumber = 1
	end
	local StartRow = (PageNumber - 1) * PLAYERS_PER_PAGE
	local EndRow = PageNumber * PLAYERS_PER_PAGE - 1

	-- Accumulator for the page data
	local PageText = {}
	ins(PageText, "<p><a href='?subpage=addplayer'>Add a new player</a>, <a href='?subpage=confirmclear'>Clear players</a></p>")

	-- Add a table describing each player:
	ins(PageText, "<table><tr><th>Playername</th><th>Rank</th><th>Action</th></tr>\n")
	local AllPlayers = cRankManager:GetAllPlayerUUIDs()
	for i = StartRow, EndRow, 1 do
		local PlayerUUID = AllPlayers[i + 1]
		if (PlayerUUID ~= nil) then
			ins(PageText, GetPlayerRow(PlayerUUID))
		end
	end
	ins(PageText, "</table>")

	-- Calculate the page num:
	local MaxPages = math.floor((#AllPlayers + PLAYERS_PER_PAGE - 1) / PLAYERS_PER_PAGE)

	-- Display the pages list:
	ins(PageText, "<table style='width: 100%;'><tr>")
	if (PageNumber > 1) then
		ins(PageText, "<td><a href='?PageNumber=" .. (PageNumber - 1) .. "'><b>&lt;&lt;&lt;</b></a></td>")
	else
		ins(PageText, "<td><b>&lt;</b></td>")
	end
	ins(PageText, "<th style='width: 100%; text-align: center;'>Page " .. PageNumber .. " of " .. MaxPages .. "</th>")
	if (PageNumber < MaxPages) then
		ins(PageText, "<td><a href='?PageNumber=" .. (PageNumber + 1) .. "'><b>&gt;&gt;&gt;</b></a></td>")
	else
		ins(PageText, "<td><b>&gt;</b></td>")
	end
	ins(PageText, "</tr></table>")

	-- Return the entire concatenated string:
	return con(PageText)
end





--- Returns the HTML contents of the player add page
local function ShowAddPlayerPage(a_Request)
	return [[
		<h4>Add Player</h4>
		<form method="POST">
		<input type="hidden" name="subpage" value="addplayerproc" />
		<table>
			<tr>
				<th>Player Name:</th>
				<td><input type="text" name="PlayerName" maxlength="16" /></td>
			</tr>
			<tr>
				<th>Player UUID (short):</th>
				<td>
					<input type="text" name="PlayerUUID" maxlength="32" />
					If you leave this empty, the server generates the uuid automaticly.
				</td>
			</tr>
			<tr>
				<th>Rank</th>
				<td>]] .. GetRankList(cRankManager:GetDefaultRank()) .. [[</td>
			</tr>
			<tr>
				<td />
				<td><input type="submit" name="AddPlayer" value="Add Player" /></td>
			</tr>
		</table>
	</form>]]
end





--- Processes the AddPlayer page's input, creating a new player and redirecting to the player rank list
local function ShowAddPlayerProcessPage(a_Request)
	-- Check the received values:
	local PlayerName = a_Request.PostParams["PlayerName"]
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	local RankName   = a_Request.PostParams["RankName"]
	if ((PlayerName == nil) or (PlayerUUID == nil) or (RankName == nil) or (RankName == "")) then
		return HTMLError("Invalid request received, missing values.")
	end

	-- Check if playername is given
	if (PlayerName == "") then
		return [[
			<h4>Add Player</h4>
			<p>Missing Playername or name is longer than 16 chars!</p>
			<p><a href="?subpage=addplayer">Go back</a></p>
		]]
	end

	-- Search the uuid (if uuid line is empty)
	if (PlayerUUID == "") then
		if (cRoot:Get():GetServer():ShouldAuthenticate()) then
			PlayerUUID = cMojangAPI:GetUUIDFromPlayerName(PlayerName, false)
		else
			PlayerUUID = cClientHandle:GenerateOfflineUUID(PlayerName)
		end
	end

	-- Check if the uuid is correct
	if ((PlayerUUID == "") or (string.len(PlayerUUID) ~= 32)) then
		if (a_Request.PostParams["PlayerUUID"] == "") then
			return [[
				<h4>Add Player</h4>
				<p>Bad uuid. <a href="?subpage=addplayer">Go back</a></p>
			]]
		else
			return [[
				<h4>Add Player</h4>
				<p>UUID for player ]] .. PlayerName .. [[ not found!<br />
				Maybe the player doesn't exists?</p>
				<p><a href="?subpage=addplayer">Go back</a></p>
			]]
		end
	end

	-- Exists the player already?
	if (cRankManager:GetPlayerRankName(PlayerUUID) ~= "") then
		return [[
			<h4>Add Player</h4>
			<p>Can't create the player because a player with the same uuid already exists!</p>
			<p><a href="?subpage=addplayer">Go back</a></p>
		]]
	end

	-- Add the new player:
	cRankManager:SetPlayerRank(PlayerUUID, PlayerName, RankName)
	UpdateIngamePlayer(PlayerUUID, "You were assigned the rank " .. RankName .. " by webadmin.")
	return "<p>Player created. <a href='/" .. a_Request.Path .. "'>Return</a>.</p>"
end




--- Deletes the specified player and redirects back to list
local function ShowDelPlayerPage(a_Request)
	-- Check the input:
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	if (PlayerUUID == nil) then
		return HTMLError("Bad request")
	end

	-- Delete the player:
	cRankManager:RemovePlayerRank(PlayerUUID)
	UpdateIngamePlayer(PlayerUUID, "You were assigned the rank " .. cRankManager:GetDefaultRank() .. " by webadmin.")

	-- Redirect back to list:
	return "<p>Rank deleted. <a href='/" .. a_Request.Path .. "'>Return to list</a>."
end





--- Shows a confirmation page for deleting the specified player
local function ShowConfirmDelPage(a_Request)
	-- Check the input:
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	local PlayerName = a_Request.PostParams["PlayerName"]
	if ((PlayerUUID == nil) or (PlayerName == nil)) then
		return HTMLError("Bad request")
	end

	-- Show confirmation:
	return [[
		<h4>Delete player</h4>
		<p>Are you sure you want to delete player ]] .. PlayerName .. [[?<br />
		<short>UUID: ]] .. PlayerUUID .. [[</short></p>
		<p><a href='?subpage=delplayer&PlayerUUID=]] .. PlayerUUID .. [['>Delete</a></p>
		<p><a href='/]] .. a_Request.Path .. [['>Cancel</a></p>
	]]
end





--- Returns the HTML contents of the playerrank edit page.
local function ShowEditPlayerRankPage(a_Request)
	-- Check the input:
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	if ((PlayerUUID == nil) or (string.len(PlayerUUID) ~= 32)) then
		return HTMLError("Bad request")
	end

	-- Get player name:
	local PlayerName = cRankManager:GetPlayerName(PlayerUUID)
	local PlayerRank = cRankManager:GetPlayerRankName(PlayerUUID)

	return [[
		<h4>Change rank from ]] .. PlayerName .. [[</h4>
		<form method="POST">
		<input type="hidden" name="subpage" value="editplayerproc" />
		<input type="hidden" name="PlayerUUID" value="]] .. PlayerUUID .. [[" />
		<table>
			<tr>
				<th>UUID</th>
				<td>]] .. PlayerUUID .. [[</td>
			</tr>
			<tr>
				<th>Current Rank</th>
				<td>]] .. PlayerRank .. [[</td>
			</tr>
			<tr>
				<th>New Rank</th>
				<td>]] .. GetRankList(PlayerRank) .. [[</td>
			</tr>
			<tr>
				<td />
				<td><input type="submit" name="EditPlayerRank" value="Edit Rank" /></td>
			</tr>
		</table>
		</form>
	]]
end





--- Processes the edit rank page's input, change the rank and redirecting to the player rank list
local function ShowEditPlayerRankProcessPage(a_Request)
	-- Check the input:
	local PlayerUUID = a_Request.PostParams["PlayerUUID"]
	local NewRank    = a_Request.PostParams["RankName"]
	if ((PlayerUUID == nil) or (NewRank == nil) or (string.len(PlayerUUID) ~= 32) or (NewRank == "")) then
		return HTMLError("Bad request")
	end

	-- Get the player name:
	local PlayerName = cRankManager:GetPlayerName(PlayerUUID)
	if (PlayerName == "") then
		return [[
			<p>Can't change the rank because this user doesn't exists!</p>
			<p><a href="/]] .. a_Request.Path .. [[">Go back</a></p>
		]]
	end

	-- Edit the rank:
	cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)
	UpdateIngamePlayer(PlayerUUID, "You were assigned the rank " .. NewRank .. " by webadmin.")
	return "<p>The rank from player " .. PlayerName .. " was changed to " .. NewRank .. ". <a href='/" .. a_Request.Path .. "'>Return</a>.</p>"
end





--- Processes the clear of all player ranks
local function ShowClearPlayersPage(a_Request)
	cRankManager:ClearPlayerRanks();
	LOGINFO("WebAdmin: A user cleared all player ranks")

	-- Update ingame players:
	cRoot:Get():ForEachPlayer(
		function(a_Player)
			a_Player:LoadRank()
		end
	)

	return "<p>Cleared all player ranks! <a href='/" .. a_Request.Path .. "'>Return</a>.</p>"
end





--- Shows a confirmation page for deleting all players
local function ShowConfirmClearPage(a_Request)
	-- Show confirmation:
	return [[
		<h4>Clear all player ranks</h4>
		<p>Are you sure you want to delete all players from the database?</p>
		<p><a href='?subpage=clear'>Clear</a></p>
		<p><a href='/]] .. a_Request.Path .. [['>Cancel</a></p>
	]]
end





--- Handlers for the individual subpages in this tab
-- Each item maps a subpage name to a handler function that receives a HTTPRequest object and returns the HTML to return
local g_SubpageHandlers =
{
	[""]               = ShowMainPlayersPage,
	["addplayer"]      = ShowAddPlayerPage,
	["addplayerproc"]  = ShowAddPlayerProcessPage,
	["delplayer"]      = ShowDelPlayerPage,
	["confirmdel"]     = ShowConfirmDelPage,
	["editplayer"]     = ShowEditPlayerRankPage,
	["editplayerproc"] = ShowEditPlayerRankProcessPage,
	["clear"]          = ShowClearPlayersPage,
	["confirmclear"]   = ShowConfirmClearPage,
}





--- Handles the web request coming from MCS
-- Returns the entire tab's HTML contents, based on the player's request
function HandleRequest_PlayerRanks(a_Request)
	local Subpage = (a_Request.PostParams["subpage"] or "")
	local Handler = g_SubpageHandlers[Subpage]
	if (Handler == nil) then
		return HTMLError("An internal error has occurred, no handler for subpage " .. Subpage .. ".")
	end
	
	local PageContent = Handler(a_Request)
	return PageContent
end
