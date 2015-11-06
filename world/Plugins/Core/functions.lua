function SendMessage(a_Player, a_Message)
	a_Player:SendMessageInfo(a_Message)
end

function SendMessageSuccess(a_Player, a_Message)
	a_Player:SendMessageSuccess(a_Message)
end

function SendMessageFailure(a_Player, a_Message)
	a_Player:SendMessageFailure(a_Message)
end

--- Kicks a player by name, with the specified reason; returns bool whether found and player's real name
function KickPlayer( PlayerName, Reason )

	local RealName = ""
	if (Reason == nil) then
		Reason = "You have been kicked"
	end

	local FoundPlayerCallback = function( a_Player )
		a_Player:GetClientHandle():Kick(Reason)
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( PlayerName, FoundPlayerCallback ) then
		-- Could not find player
		return false
	end

	return true -- Player has been kicked

end


function ReturnColorFromChar(char)

	-- Check if the char represents a color. Else return nil.
	if char == "0" then
		return cChatColor.Black
	elseif char == "1" then
		return cChatColor.Navy
	elseif char == "2" then
		return cChatColor.Green
	elseif char == "3" then
		return cChatColor.Blue
	elseif char == "4" then
		return cChatColor.Red
	elseif char == "5" then
		return cChatColor.Purple
	elseif char == "6" then
		return cChatColor.Gold
	elseif char == "7" then
		return cChatColor.LightGray
	elseif char == "8" then
		return cChatColor.Gray
	elseif char == "9" then
		return cChatColor.DarkPurple
	elseif char == "a" then
		return cChatColor.LightGreen
	elseif char == "b" then
		return cChatColor.LightBlue
	elseif char == "c" then
		return cChatColor.Rose
	elseif char == "d" then
		return cChatColor.LightPurple
	elseif char == "e" then
		return cChatColor.Yellow
	elseif char == "f" then
		return cChatColor.White
	elseif char == "k" then
		return cChatColor.Random
	elseif char == "l" then
		return cChatColor.Bold
	elseif char == "m" then
		return cChatColor.Strikethrough
	elseif char == "n" then
		return cChatColor.Underlined
	elseif char == "o" then
		return cChatColor.Italic
	elseif char == "r" then
		return cChatColor.Plain
	end

end

function CheckHardcore(Victim)
	if cRoot:Get():GetServer():IsHardcore() then
		if Victim:IsPlayer() == true then
			BannedPlayersIni:SetValueB( "Banned", tolua.cast(Victim, "cPlayer"):GetName(), true )
			BannedPlayersIni:WriteFile( "banned.ini" )
		end
	end
end

-- Teleports a_SrcPlayer to a player named a_DstPlayerName; if a_TellDst is true, will send a notice to the destination player
function TeleportToPlayer( a_SrcPlayer, a_DstPlayerName, a_TellDst )

	local teleport = function(a_DstPlayerName)

		if a_DstPlayerName == a_SrcPlayer then
			-- Asked to teleport to self?
			SendMessageFailure( a_SrcPlayer, "Y' can't teleport to yerself!" )
		else
			a_SrcPlayer:TeleportToEntity( a_DstPlayerName )
			SendMessageSuccess( a_SrcPlayer, "You teleported to " .. a_DstPlayerName:GetName() .. "!" )
			if (a_TellDst) then
				SendMessage( a_DstPlayerName, a_SrcPlayer:GetName().." teleported to you!" )
			end
		end

	end

	local World = a_SrcPlayer:GetWorld()
	if not World:DoWithPlayer(a_DstPlayerName, teleport) then
		SendMessageFailure( a_SrcPlayer, "Can't find player " .. a_DstPlayerName)
	end

end

function getSpawnProtectRadius(WorldName)
	return WorldsSpawnProtect[WorldName]
end

function GetWorldDifficulty(a_World)
	local Difficulty = WorldsWorldDifficulty[a_World:GetName()]
	if (Difficulty == nil) then
		Difficulty = 1
	end

	return Clamp(Difficulty, 0, 3)
end

function SetWorldDifficulty(a_World, a_Difficulty)
	local Difficulty = Clamp(a_Difficulty, 0, 3)
	WorldsWorldDifficulty[a_World:GetName()] = Difficulty

	-- Update world.ini
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldIni:SetValue("Difficulty", "WorldDifficulty", Difficulty)
	WorldIni:WriteFile(a_World:GetIniFileName())
end

function LoadWorldSettings(a_World)
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldsSpawnProtect[a_World:GetName()]    = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10)
	WorldsWorldLimit[a_World:GetName()]      = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",   0)
	WorldsWorldDifficulty[a_World:GetName()] = WorldIni:GetValueSetI("Difficulty", "WorldDifficulty", 1)
	WorldIni:WriteFile(a_World:GetIniFileName())
end


--- Returns the cWorld object represented by the given WorldName,
--  if no world of the given name is found, returns nil and informs the Player, if given, otherwise logs to console.
--  If no WorldName was given, returns the default world if called without a Player,
--  or the current world that the player is in if called with a Player.
--  
--  @param WorldName String containing the name of the world to find
--  @param Player cPlayer object representing the player calling the command
--  
--  @return cWorld object representing the requested world, or nil if not found
--
--  Called from: time.lua, weather.lua, 
--
function GetWorld( WorldName, Player )

	if not WorldName then
		return Player and Player:GetWorld() or cRoot:Get():GetDefaultWorld()
	else
		local World = cRoot:Get():GetWorld(WorldName)

		if not World then
			local Message = "There is no world \"" .. WorldName .. "\""
			if Player then
				SendMessage( Player, Message )
			else
				LOG( Message )
			end
		end
		
		return World
	end
end
