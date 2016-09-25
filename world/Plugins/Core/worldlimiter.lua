local WorldLimiter_Flag = false -- True when teleportation is about to occur, false otherwise
local WorldLimiter_LastMessage = -100 -- The last time the player was sent a message about reaching the border
function OnPlayerMoving(Player)
	if (WorldLimiter_Flag == true) then
		return
	end

	local LimitChunks = WorldsWorldLimit[Player:GetWorld():GetName()]
	
	-- The world probably was created by an external plugin. Let's load the settings.
	if not LimitChunks then
		LoadWorldSettings(Player:GetWorld())
		LimitChunks = WorldsWorldLimit[Player:GetWorld():GetName()]
	end

	if (LimitChunks > 0) then
		local World = Player:GetWorld()
		local Limit = LimitChunks * 16 - 1
		local SpawnX = math.floor(World:GetSpawnX())
		local SpawnZ = math.floor(World:GetSpawnZ())
		local X = math.floor(Player:GetPosX())
		local Z = math.floor(Player:GetPosZ())
		local NewX = X
		local NewZ = Z
		
		if (X > SpawnX + Limit) then 
			NewX = SpawnX + Limit
		elseif (X < SpawnX - Limit) then
			NewX = SpawnX - Limit
		end

		if (Z > SpawnZ + Limit) then
			NewZ = SpawnZ + Limit
		elseif (Z < SpawnZ - Limit) then
			NewZ = SpawnZ - Limit
		end

		if (X ~= NewX) or (Z ~= NewZ) then
			WorldLimiter_Flag = true

			local UpTime = cRoot:Get():GetServerUpTime()
			if  UpTime - WorldLimiter_LastMessage > 30 then
				WorldLimiter_LastMessage = UpTime
				Player:SendMessageInfo("You have reached the world border")
			end

			local UUID = Player:GetUUID()
			World:ScheduleTask(3, function(World)
				World:DoWithPlayerByUUID(UUID, function(Player)
					Player:TeleportToCoords(NewX, Player:GetPosY(), NewZ)
					WorldLimiter_Flag = false
				end) 
			end)
		end	


	end
end
