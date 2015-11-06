function OnPlayerMoving( Player )
	local LimitWorldWidth = WorldsWorldLimit[Player:GetWorld():GetName()]
	
	-- The world probably was created by an external plugin. Lets load the settings.
	if not LimitWorldWidth then
		LoadWorldSettings(Player:GetWorld())
		LimitWorldWidth = WorldsWorldLimit[Player:GetWorld():GetName()]
	end
	
	if LimitWorldWidth > 0 then
		local World = Player:GetWorld()
		local SpawnX = math.floor(World:GetSpawnX() / 16)
		local SpawnZ = math.floor(World:GetSpawnZ() / 16)
		local X = math.floor(Player:GetPosX() / 16)
		local Z = math.floor(Player:GetPosZ() / 16)
		if ( (SpawnX + LimitWorldWidth - 1) < X ) then 
			Player:TeleportToCoords(Player:GetPosX() - 1, Player:GetPosY(), Player:GetPosZ()) 
		end
		if ( (SpawnX - LimitWorldWidth + 1) > X ) then
			Player:TeleportToCoords(Player:GetPosX() + 1, Player:GetPosY(), Player:GetPosZ()) 
		end
		if ( (SpawnZ + LimitWorldWidth - 1) < Z ) then 
			Player:TeleportToCoords(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ() - 1) 
		end
		if ( (SpawnZ - LimitWorldWidth + 1) > Z ) then
			Player:TeleportToCoords(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ() + 1) 
		end
	end
end