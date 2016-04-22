function HandleSpawnCommand(Split, Player)
	
	local WorldIni = cIniFile()
	WorldIni:ReadFile(Player:GetWorld():GetIniFileName())
	
	local SpawnX = WorldIni:GetValue("SpawnPosition", "X")
	local SpawnY = WorldIni:GetValue("SpawnPosition", "Y")
	local SpawnZ = WorldIni:GetValue("SpawnPosition", "Z")
	local flag = 0
	
	if (#Split == 2 and Split[2] ~= Player:GetName()) then
		if Player:HasPermission("core.spawn.others") then
			local FoundPlayerCallback = function(OtherPlayer)
				if (OtherPlayer:GetName() == Split[2]) then
					World = OtherPlayer:GetWorld()
					local OnAllChunksAvailable = function()
						OtherPlayer:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
						SendMessageSuccess( Player, "Returned " .. OtherPlayer:GetName() .. " to world spawn" )
						flag=1
					end
					World:ChunkStay({{SpawnX/16, SpawnZ/16}}, OnChunkAvailable, OnAllChunksAvailable)		
				end
			end
			cRoot:Get():FindAndDoWithPlayer(Split[2], FoundPlayerCallback)
			
			if flag == 0 then
				SendMessageFailure( Player, "Player " .. Split[2] .. " not found!" )
			end
		else
			SendMessageFailure( Player, "You need core.spawn.others permission to do that!" )
		end
	else
		World = Player:GetWorld()
		local OnAllChunksAvailable = function()
			Player:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
			SendMessageSuccess( Player, "Returned to world spawn" )
		end
		World:ChunkStay({{SpawnX/16, SpawnZ/16}}, OnChunkAvailable, OnAllChunksAvailable)
	end
	
	return true

end

function HandleSetSpawnCommand(Split, Player)
	
	local WorldIni = cIniFile()
	WorldIni:ReadFile(Player:GetWorld():GetIniFileName())
	
	local PlayerX = Player:GetPosX()
	local PlayerY = Player:GetPosY()
	local PlayerZ = Player:GetPosZ()
	
	WorldIni:DeleteValue("SpawnPosition", "X")
	WorldIni:DeleteValue("SpawnPosition", "Y")
	WorldIni:DeleteValue("SpawnPosition", "Z")
	
	WorldIni:SetValue("SpawnPosition", "X", PlayerX)
	WorldIni:SetValue("SpawnPosition", "Y", PlayerY)
	WorldIni:SetValue("SpawnPosition", "Z", PlayerZ)
	WorldIni:WriteFile(Player:GetWorld():GetIniFileName())
	
	SendMessageSuccess( Player, string.format("Changed spawn position to [X:%i Y:%i Z:%i]", PlayerX, PlayerY, PlayerZ) )
	return true
	
end
