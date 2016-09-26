
-- whitelist.lua

-- Implements the whitelist-related commands, console commands, API and storage





--- The SQLite handle to the whitelist database:
local WhitelistDB

--- Global flag whether whitelist is enabled:
local g_IsWhitelistEnabled = false





--- Loads the config from the DB
-- If any value cannot be read, it is kept unchanged
local function LoadConfig()
	-- Read the g_IsWhitelistEnabled value:
	WhitelistDB:ExecuteStatement(
		"SELECT Value FROM WhitelistConfig WHERE Name='isEnabled'",
		{},
		function (a_Val)
			g_IsWhitelistEnabled = (a_Val["Value"] == "true")
		end
	)
end





--- Saves the current config into the DB
local function SaveConfig()
	-- Remove the value, if it exists:
	WhitelistDB:ExecuteStatement(
		"DELETE FROM WhitelistConfig WHERE Name='isEnabled'", {}
	)
	
	-- Insert the current value:
	WhitelistDB:ExecuteStatement(
		"INSERT INTO WhitelistConfig(Name, Value) VALUES ('isEnabled', ?)",
		{ tostring(g_IsWhitelistEnabled) }
	)
end





--- API: Adds the specified player to the whitelist
-- Resolves the player UUID, if needed, but only through cache, not to block
-- Returns true on success, false and optional error message on failure
function AddPlayerToWhitelist(a_PlayerName, a_WhitelistedBy)
	-- Check params:
	assert(type(a_PlayerName) == "string")
	assert(type(a_WhitelistedBy) == "string")
	
	-- Resolve the player name to OfflineUUID and possibly OnlineUUID (if server is in online mode):
	local UUID = ""
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		UUID = cMojangAPI:GetUUIDFromPlayerName(a_PlayerName, true)
		-- If the UUID cannot be resolved, leave it as an empty string, it will be resolved on next startup / eventually
	end
	local OfflineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)
	
	-- Insert into DB:
	return WhitelistDB:ExecuteStatement(
		"INSERT INTO WhitelistNames (Name, UUID, OfflineUUID, Timestamp, WhitelistedBy) VALUES (?, ?, ?, ?, ?)",
		{
			a_PlayerName, UUID, OfflineUUID,
			os.time(), a_WhitelistedBy,
		}
	)
end





--- API: Checks if the player is whitelisted
-- Returns true if whitelisted, false if not
-- Uses UUID for the check, and the playername with an empty UUID for a secondary check
function IsPlayerWhitelisted(a_PlayerUUID, a_PlayerName)
	-- Check params:
	assert(type(a_PlayerUUID) == "string")
	assert(type(a_PlayerName) == "string")
	local UUID = a_PlayerUUID
	if (UUID == "") then
		-- There is no UUID supplied for the player, do not search by the UUID by using a dummy impossible value:
		UUID = "DummyImpossibleValue"
	end
	
	-- Query the DB:
	local offlineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)
	local isWhitelisted
	assert(WhitelistDB:ExecuteStatement(
		[[
			SELECT Name FROM WhitelistNames WHERE
				(UUID = ?) OR
				(OfflineUUID = ?) OR
				((UUID = '') AND (Name = ?))
		]],
		{ UUID, offlineUUID, a_PlayerName },
		function (a_Row)
			isWhitelisted = true
		end
	))
	return isWhitelisted
end





--- API: Returns true if whitelist is enabled
function IsWhitelistEnabled()
	return g_IsWhitelistEnabled
end





--- Returns a sorted array-table of all whitelisted players' names
function ListWhitelistedPlayerNames()
	local res = {}
	WhitelistDB:ExecuteStatement(
		"SELECT Name FROM WhitelistNames ORDER BY Name", {},
		function (a_Columns)
			table.insert(res, a_Columns["Name"])
		end
	)
	return res
end





--- Returns an array-table of all whitelisted players, sorted by player name
-- Each item is a table with the Name, OnlineUUID, OfflineUUID, Date and WhitelistedBy values
function ListWhitelistedPlayers()
	local res = {}
	WhitelistDB:ExecuteStatement(
		"SELECT * FROM WhitelistNames ORDER BY Name", {},
		function (a_Columns)
			table.insert(res, a_Columns)
		end
	)
	return res
end





--- API: Removes the specified player from the whitelist
-- No action if the player is not whitelisted
-- Returns true on success, false and optional error message on failure
function RemovePlayerFromWhitelist(a_PlayerName)
	-- Check params:
	assert(type(a_PlayerName) == "string")
	
	-- Remove from the DB:
	return WhitelistDB:ExecuteStatement(
		"DELETE FROM WhitelistNames WHERE Name = ?",
		{ a_PlayerName }
	)
end





--- API: Disables the whitelist
-- After this call, any player can connect to the server
function WhitelistDisable()
	g_IsWhitelistEnabled = false
	SaveConfig()
end





--- API: Enables the whitelist
-- After this call, only whitelisted players can connect to the server
function WhitelistEnable()
	g_IsWhitelistEnabled = true
	SaveConfig()
end





--- Resolves the UUIDs for players that don't have their UUIDs in the DB
-- This may happen when whitelisting a player who never connected to the server and thus is not yet cached in the UUID lookup
local function ResolveUUIDs()
	-- If the server is offline, bail out:
	if not(cRoot:Get():GetServer():ShouldAuthenticate()) then
		return
	end
	
	-- Collect the names of players without their UUIDs:
	local NamesToResolve = {}
	WhitelistDB:ExecuteStatement(
		"SELECT Name From WhitelistNames WHERE UUID = ''", {},
		function (a_Columns)
			table.insert(NamesToResolve, a_Columns["PlayerName"])
		end
	)
	if (#NamesToResolve == 0) then
		return;
	end
	
	-- Resolve the names:
	LOGINFO("Core: Resolving player UUIDs in the whitelist from Mojang servers. This may take a while...")
	local ResolvedNames = cMojangAPI:GetUUIDsFromPlayerNames(NamesToResolve)
	LOGINFO("Core: Resolving finished.")
	
	-- Update the names in the DB:
	for name, uuid in pairs(ResolvedNames) do
		WhitelistDB:ExecuteStatement(
			"UPDATE WhitelistNames SET UUID = ? WHERE PlayerName = ?",
			{ uuid, name }
		)
	end
end





--- If whitelist is disabled, sends a message to the specified player (or console if nil)
local function NotifyWhitelistStatus(a_Player)
	-- Nothing to notify if the whitelist is enabled:
	if (g_IsWhitelistEnabled) then
		return
	end
	
	-- Send the notification msg to player / console:
	if (a_Player == nil) then
		LOG("Note: Whitelist is disabled. Use the \"whitelist on\" command to enable.")
	else
		a_Player:SendMessageInfo("Note: Whitelist is disabled. Use the \"/whitelist on\" command to enable.")
	end
end





--- If whitelist is empty, sends a notification to the specified player (or console if nil)
-- Assumes that the whitelist is enabled
local function NotifyWhitelistEmpty(a_Player)
	-- Check if whitelist is empty:
	local numWhitelisted
	local isSuccess, msg = WhitelistDB:ExecuteStatement(
		"SELECT COUNT(*) AS c FROM WhitelistNames",
		{},
		function (a_Values)
			numWhitelisted = a_Values["c"]
		end
	)
	if (not (isSuccess) or (type(numWhitelisted) ~= "number") or (numWhitelisted > 0)) then
		return
	end
	
	-- Send the notification msg to player / console:
	if (a_Player == nil) then
		LOGINFO("Note: Whitelist is empty. No player can connect to the server now. Use the \"whitelist add\" command to add players to whitelist.")
	else
		a_Player:SendMessageInfo("Note: Whitelist is empty. No player can connect to the server now. Use the \"/whitelist add\" command to add players to whitelist.")
	end
end





function HandleWhitelistAddCommand(a_Split, a_Player)
	-- Check params:
	if (a_Split[3] == nil) then
		SendMessage(a_Player, "Usage: " .. a_Split[1] .. " add <player>")
		return true
	end
	local playerName = a_Split[3]

	-- Add the player to the whitelist:
	local isSuccess, msg = AddPlayerToWhitelist(playerName, a_Player:GetName());
	if not(isSuccess) then
		SendMessageFailure(a_Player, "Cannot whitelist " .. playerName .. ": " .. (msg or "<unknown error>"))
		return true
	end

	-- Notify success:
	LOGINFO(a_Player:GetName() .. " added " .. playerName .. " to whitelist.")
	SendMessageSuccess(a_Player, "Successfully added " .. playerName .. " to whitelist.")
	NotifyWhitelistStatus(a_Player)
	return true
end





function HandleWhitelistListCommand(a_Split, a_Player)
	if (IsWhitelistEnabled()) then
		a_Player:SendMessageSuccess("Whitelist is enabled")
	else
		a_Player:SendMessageSuccess("Whitelist is disabled")
	end
	local players = ListWhitelistedPlayerNames()
	table.sort(players)
	a_Player:SendMessageSuccess(table.concat(players, ", "))
	return true
end





function HandleWhitelistOffCommand(a_Split, a_Player)
	g_IsWhitelistEnabled = true
	SaveConfig()
	a_Player:SendMessageSuccess("Whitelist is disabled.")
	return true
end





function HandleWhitelistOnCommand(a_Split, a_Player)
	g_IsWhitelistEnabled = true
	SaveConfig()
	a_Player:SendMessageSuccess("Whitelist is enabled.")
	NotifyWhitelistEmpty(a_Player)
	return true
end





function HandleWhitelistRemoveCommand(a_Split, a_Player)
	-- Check params:
	if ((a_Split[3] == nil) or (a_Split[4] ~= nil)) then
		SendMessage(a_Player, "Usage: " .. a_Split[1] .. " remove <player>")
		return true
	end
	local playerName = a_Split[3]

	-- Remove the player from the whitelist:
	local isSuccess, msg = RemovePlayerFromWhitelist(playerName)
	if not(isSuccess) then
		SendMessageFailure(a_Player, "Cannot unwhitelist " .. playerName .. ": " .. (msg or "<unknown error>"))
		return true
	end

	-- Notify success:
	LOGINFO(a_Player:GetName() .. " removed " .. playerName .. " from whitelist.")
	SendMessageSuccess(a_Player, "Removed " .. playerName .. " from whitelist.")
	NotifyWhitelistStatus(a_Player)
	return true
end





function HandleConsoleWhitelistAdd(a_Split)
	-- Check params:
	if (a_Split[3] == nil) then
		return true, "Usage: " .. a_Split[1] .. " add <player>"
	end
	local playerName = a_Split[3]

	-- Whitelist the player:
	local isSuccess, msg = AddPlayerToWhitelist(playerName, "<console>")
	if not(isSuccess) then
		return true, "Cannot whitelist " .. playerName .. ": " .. (msg or "<unknown error>")
	end
	
	-- Notify success:
	NotifyWhitelistStatus()
	return true, "You added " .. playerName .. " to whitelist."
end





function HandleConsoleWhitelistList(a_Split)
	local status
	if (g_IsWhitelistEnabled) then
		status = "Whitelist is ENABLED.\n"
	else
		status = "Whitelist is DISABLED.\n"
	end
	local players = ListWhitelistedPlayerNames()
	if (players[1] == nil) then
		return true, status .. "The whitelist is empty."
	else
		return true, status .. "Whitelisted players: " .. table.concat(players, ", ")
	end
end





function HandleConsoleWhitelistOff(a_Split)
	WhitelistDisable()
	return true, "Whitelist is disabled"
end





function HandleConsoleWhitelistOn(a_Split)
	WhitelistEnable()
	NotifyWhitelistEmpty()
	return true, "Whitelist is enabled"
end





function HandleConsoleWhitelistRemove(a_Split)
	-- Check params:
	if ((a_Split[3] == nil) or (a_Split[4] ~= nil)) then
		return true, "Usage: " .. a_Split[1] .. " remove <player>"
	end
	local playerName = a_Split[3]

	-- Unwhitelist the player:
	local isSuccess, msg = RemovePlayerFromWhitelist(playerName)
	if not(isSuccess) then
		return true, "Cannot unwhitelist " .. playerName .. ": " .. (msg or "<unknown error>")
	end
	
	-- Notify success:
	NotifyWhitelistStatus()
	return true, "You removed " .. playerName .. " from whitelist."
end





--- Opens the whitelist DB and checks that all the tables have the needed structure
local function InitializeDB()
	-- Open the DB:
	local ErrMsg
	WhitelistDB, ErrMsg = NewSQLiteDB("whitelist.sqlite")
	if not(WhitelistDB) then
		LOGWARNING("Cannot open the whitelist database, whitelist not available. SQLite: " .. (ErrMsg or "<no details>"))
		error(ErrMsg)
	end
	
	-- Define the needed structure:
	local nameListColumns =
	{
		"Name",
		"UUID",
		"OfflineUUID",
		"Timestamp",
		"WhitelistedBy",
	}
	local configColumns =
	{
		"Name TEXT PRIMARY KEY",
		"Value"
	}
	
	-- Check structure:
	if (
		not(WhitelistDB:CreateDBTable("WhitelistNames", nameListColumns)) or
		not(WhitelistDB:CreateDBTable("WhitelistConfig", configColumns))
	) then
		LOGWARNING("Cannot initialize the whitelist database, whitelist not available.")
		error("Whitelist DB failure")
	end
	
	-- Load the config:
	LoadConfig()
end






--- Callback for the HOOK_PLAYER_JOINED hook
-- Kicks the player if they are whitelisted by UUID or Name
-- Also sets the UUID for the player in the DB, if not present
local function OnPlayerJoined(a_Player)
	local UUID = a_Player:GetUUID()
	local Name = a_Player:GetName()
	
	-- Update the UUID in the DB, if empty:
	assert(WhitelistDB:ExecuteStatement(
		"UPDATE WhitelistNames SET UUID = ? WHERE ((UUID = '') AND (Name = ?))",
		{ UUID, Name }
	))
	
	-- If whitelist is not enabled, bail out:
	if not(g_IsWhitelistEnabled) then
		return false
	end

	-- Kick if not whitelisted:
	local isWhitelisted = IsPlayerWhitelisted(UUID, Name)
	if not(isWhitelisted) then
		a_Player:GetClientHandle():Kick("You are not on the whitelist")
		return true
	end
end





--- Init function to be called upon plugin startup
-- Opens the whitelist DB and refreshes the player names stored within
function InitializeWhitelist()
	-- Initialize the Whitelist DB:
	InitializeDB()
	ResolveUUIDs()
	
	-- Make a note in the console if the whitelist is enabled and empty:
	if (g_IsWhitelistEnabled) then
		NotifyWhitelistEmpty()
	end

	-- Add a hook to filter out non-whitelisted players:
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
end




