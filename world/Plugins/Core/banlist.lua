
-- banlist.lua

-- Implements the banlist-related commands, console commands, API and storage




--- The SQLite handle to the banlist database:
local BanlistDB





--- Adds the specified IP address to the banlist, with the specified ban reason
local function AddIPToBanlist(a_IP, a_Reason, a_BannedBy)
	-- Check params:
	assert(type(a_IP) == "string")
	assert(type(a_BannedBy) == "string")
	a_Reason = a_Reason or "banned"
	
	-- Insert into DB:
	return BanlistDB:ExecuteStatement(
		"INSERT INTO BannedIPs (IP, Reason, Timestamp, BannedBy) VALUES (?, ?, ?, ?)",
		{ a_IP, a_Reason, os.time(), a_BannedBy, }
	)
end





--- Adds the specified player to the banlist, with the specified ban reason
-- Resolves the player UUID, if needed, but only through cache, not to block
local function AddPlayerToBanlist(a_PlayerName, a_Reason, a_BannedBy)
	-- Check params:
	assert(type(a_PlayerName) == "string")
	assert(type(a_BannedBy) == "string")
	a_Reason = a_Reason or "banned"
	
	-- Resolve the player name to OfflineUUID and possibly OnlineUUID (if server is in online mode):
	local UUID = ""
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		UUID = cMojangAPI:GetUUIDFromPlayerName(a_PlayerName, true)
		-- If the UUID cannot be resolved, leave it as an empty string, it will be resolved on next startup / eventually
	end
	local OfflineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)
	
	-- Insert into DB:
	return BanlistDB:ExecuteStatement(
		"INSERT INTO BannedNames (Name, UUID, OfflineUUID, Reason, Timestamp, BannedBy) VALUES (?, ?, ?, ?, ?, ?)",
		{
			a_PlayerName, UUID, OfflineUUID,
			a_Reason, os.time(), a_BannedBy,
		}
	)
end





--- Checks if the IP address is banned
-- Returns true and reason if banned, false if not
local function IsIPBanned(a_IP)
	-- Check params:
	assert(type(a_IP) == "string")
	assert(a_IP ~= "")
	
	-- Query the DB:
	local Reason
	assert(BanlistDB:ExecuteStatement(
		"SELECT Reason FROM BannedIPs WHERE IP = ?",
		{ a_IP },
		function (a_Row)
			Reason = a_Row["Reason"]
		end
	))
	
	-- Process the DB results:
	if (Reason == nil) then
		-- Not banned
		return false
	else
		-- Banned with a reason:
		return true, Reason
	end
end





--- Checks if the player is banned
-- Returns true and reason if banned, false if not
-- Uses UUID for the check, and the playername with an empty UUID for a secondary check
local function IsPlayerBanned(a_PlayerUUID, a_PlayerName)
	-- Check params:
	assert(type(a_PlayerUUID) == "string")
	assert(type(a_PlayerName) == "string")
	local UUID = a_PlayerUUID
	if (UUID == "") then
		-- There is no UUID supplied for the player, do not search by the UUID by using a dummy impossible value:
		UUID = "DummyImpossibleValue"
	end
	
	-- Query the DB:
	local OfflineUUID = cClientHandle:GenerateOfflineUUID(a_PlayerName)
	local Reason
	assert(BanlistDB:ExecuteStatement(
		[[
			SELECT Reason FROM BannedNames WHERE
				(UUID = ?) OR
				(OfflineUUID = ?) OR
				((UUID = '') AND (Name = ?))
		]],
		{ UUID, OfflineUUID, a_PlayerName },
		function (a_Row)
			Reason = a_Row["Reason"]
		end
	))
	
	-- Process the DB results:
	if (Reason == nil) then
		-- Not banned
		return false
	else
		-- Banned with a reason:
		return true, Reason
	end
end





--- Returns an array-table of all banned players
local function ListBannedPlayers()
	local res = {}
	BanlistDB:ExecuteStatement(
		"SELECT Name FROM BannedNames", {},
		function (a_Columns)
			table.insert(res, a_Columns["Name"])
		end
	)
	return res
end





--- Returns an array-table of all banned ips
local function ListBannedIPs()
	local res = {}
	BanlistDB:ExecuteStatement(
		"SELECT IP FROM BannedIPs", {},
		function (a_Columns)
			table.insert(res, a_Columns["IP"])
		end
	)
	return res
end





--- Removes the specified IP from the banlist
-- No action if the IP is not banned
local function RemoveIPFromBanlist(a_IP)
	-- Check params:
	assert(type(a_IP) == "string")
	
	-- Remove from the DB:
	assert(BanlistDB:ExecuteStatement(
		"DELETE FROM BannedIPs WHERE IP = ?",
		{ a_IP }
	))
end





--- Removes the specified player from the banlist
-- No action if the player is not banned
local function RemovePlayerFromBanlist(a_PlayerName)
	-- Check params:
	assert(type(a_PlayerName) == "string")
	
	-- Remove from the DB:
	assert(BanlistDB:ExecuteStatement(
		"DELETE FROM BannedNames WHERE Name = ?",
		{ a_PlayerName }
	))
end





--- Resolves the UUIDs for players that don't have their UUIDs in the DB
-- This may happen when banning a player who never connected to the server and thus is not yet cached in the UUID lookup
local function ResolveUUIDs()
	-- If the server is offline, bail out:
	if not(cRoot:Get():GetServer():ShouldAuthenticate()) then
		return
	end
	
	-- Collect the names of players without their UUIDs:
	local NamesToResolve = {}
	BanlistDB:ExecuteStatement(
		"SELECT Name From BannedNames WHERE UUID = ''", {},
		function (a_Columns)
			table.insert(NamesToResolve, a_Columns["PlayerName"])
		end
	)
	if (#NamesToResolve == 0) then
		return;
	end
	
	-- Resolve the names:
	LOGINFO("Core: Resolving player UUIDs in the banlist from Mojang servers. This may take a while...")
	local ResolvedNames = cMojangAPI:GetUUIDsFromPlayerNames(NamesToResolve)
	LOGINFO("Core: Resolving finished.")
	
	-- Update the names in the DB:
	for name, uuid in pairs(ResolvedNames) do
		BanlistDB:ExecuteStatement(
			"UPDATE BannedNames SET UUID = ? WHERE PlayerName = ?",
			{ uuid, name }
		)
	end
end





function HandleBanCommand(a_Split, a_Player)
	-- Check params:
	if (a_Split[2] == nil) then
		SendMessage(a_Player, "Usage: " .. a_Split[1] .. " <player> [reason ...]")
		return true
	end

	-- If the player supplied a reason, use that, else use a default reason.
	if (a_Split[3] ~= nil) then
		local Reason = table.concat(a_Split, " ", 3)
	else
		local Reason = "No reason."
	end

	-- Add the player to the banlist:
	AddPlayerToBanlist(a_Split[2], Reason, a_Player:GetName());
	
	-- Try akd kick the banned player, and send an appropriated response to the banner.
	if (KickPlayer(a_Split[2], Reason)) then
		SendMessageSuccess(a_Player, "Successfully kicked and banned " .. a_Split[2])
	else
		SendMessageFailure(a_Player, "Successfully banned " .. a_Split[2])
	end
	
	return true

end





function HandleUnbanCommand(a_Split, a_Player)
	-- Check params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		SendMessage(a_Player, "Usage: " .. a_Split[1] .. " <player>")
		return true
	end

	-- Remove the player from the banlist:
	RemovePlayerFromBanlist(a_Split[2])

	-- Notify success:
	LOGINFO(a_Player:GetName() .. " unbanned " .. a_Split[2])
	SendMessageSuccess(a_Player, "Unbanned " .. a_Split[2])
	return true
end





function HandleConsoleBan(a_Split)
	-- Check params:
	if (a_Split[2] == nil) then
		return true, "Usage: " .. a_Split[1] .. " <player> [reason ...]"
	end
	local PlayerName = a_Split[2]

	-- Compose the reason, if given:
	local Reason = cChatColor.Red .. "You have been banned."
	if (a_Split[3] ~= nil) then
		Reason = table.concat(a_Split, " ", 3)
	end

	-- Ban the player:
	AddPlayerToBanlist(PlayerName, Reason, "<console>")
	
	-- Kick the player, if they're online:
	if not(KickPlayer(PlayerName, Reason)) then
		LOGINFO("Could not find player " .. PlayerName .. ", but banned them anyway.")
	else
		LOGINFO("Successfully kicked and banned player " .. PlayerName)
	end

	return true
end





function HandleConsoleBanIP(a_Split)
	-- Check params:
	if (a_Split[2] == nil) then
		return true, "Usage: " .. a_Split[1] .. " <IP> [reason ..]"
	end
	local BanIP = a_Split[2]

	-- Compose the reason, if given:
	local Reason = cChatColor.Red .. "You have been banned."
	if (a_Split[3] ~= nil) then
		Reason = table.concat(a_Split, " ", 3)
	end

	-- Ban the player:
	AddIPToBanlist(BanIP, Reason, "<console>")
	
	-- Kick the player, if they're online:
	cRoot:Get():ForEachPlayer(
		function (a_Player)
			local Client = a_Player:GetClientHandle()
			if (Client and Client:GetIPString() == BanIP) then
				Client:Kick(Reason)
			end
		end
	)
	
	-- Report:
	LOGINFO("Successfully banned IP " .. BanIP)
	return true
end





function HandleConsoleBanList(a_Split)
	if (a_Split[2] == nil) then
		return true, table.concat(ListBannedPlayers(), ", ")
	end

	if (string.lower(a_Split[2]) == "ips") then
		return true, table.concat(ListBannedIPs(), ", ")
	end

	return true, "Unknown banlist subcommand"
end





function HandleConsoleUnban(a_Split)
	-- Check params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		return true, "Usage: " .. a_Split[1] .. " <player>"
	end

	-- Unban the player:
	RemovePlayerFromBanlist(a_Split[2])
	
	-- Inform the admin:
	LOGINFO("Unbanned " .. a_Split[2])
	return true
end





function HandleConsoleUnbanIP(a_Split)
	-- Check params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		return true, "Usage: " .. a_Split[1] .. " <IP>"
	end

	-- Unban the player:
	RemoveIPFromBanlist(a_Split[2])
	
	-- Inform the admin:
	LOGINFO("Unbanned " .. a_Split[2])
	return true
end





--- Opens the banlist DB and checks that all the tables have the needed structure
local function InitializeDB()
	-- Open the DB:
	local ErrMsg
	BanlistDB, ErrMsg = NewSQLiteDB("banlist.sqlite")
	if not(BanlistDB) then
		LOGWARNING("Cannot open the banlist database, banlist not available. SQLite: " .. (ErrMsg or "<no details>"))
		error(ErrMsg)
	end
	
	-- Define the needed structure:
	local NameListColumns =
	{
		"Name",
		"UUID",
		"OfflineUUID",
		"Reason",
		"Timestamp",
		"BannedBy",
	}
	local IPListColumns =
	{
		"IP",
		"Reason",
		"Timestamp",
		"BannedBy",
	}
	
	-- Check structure:
	if (
		not(BanlistDB:CreateDBTable("BannedNames", NameListColumns)) or
		not(BanlistDB:CreateDBTable("BannedIPs",   IPListColumns))
	) then
		LOGWARNING("Cannot initialize the banlist database, banlist not available.")
		error("Banlist DB failure")
	end
end






--- Callback for the HOOK_PLAYER_JOINED hook
-- Kicks the player if they are banned by UUID or Name
-- Also sets the UUID for the player in the DB, if not present
local function OnPlayerJoined(a_Player)
	local UUID = a_Player:GetUUID()
	local Name = a_Player:GetName()
	
	-- Update the UUID in the DB, if empty:
	assert(BanlistDB:ExecuteStatement(
		"UPDATE BannedNames SET UUID = ? WHERE ((UUID = '') AND (Name = ?))",
		{ UUID, Name }
	))
	
	-- Kick if banned:
	local IsBanned, Reason = IsPlayerBanned(UUID, Name)
	if (IsBanned) then
		a_Player:GetClientHandle():Kick("You have been banned: " .. Reason)
		return true
	end
end





--- Callback for the HOOK_LOGIN hook
-- Kicks the player if their IP is banned
local function OnLogin(a_Client)
	local IsBanned, Reason = IsIPBanned(a_Client:GetIPString())
	if (IsBanned) then
		a_Client:Kick("You have been banned: " .. Reason)
		return true
	end
end





--- Init function to be called upon plugin startup
-- Opens the banlist DB and refreshes the player names stored within
function InitializeBanlist()
	-- Initialize the Banlist DB:
	InitializeDB()
	ResolveUUIDs()
	
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_LOGIN, OnLogin)
end




