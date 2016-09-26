
-- regen.lua

-- Implements the in-game and console commands for chunk regeneration





function HandleRegenCommand(a_Split, a_Player)
	-- Check the params:
	local numParams = #a_Split
	if (numParams == 2) or (numParams > 3) then
		SendMessage(a_Player, "Usage: '" .. a_Split[1] .. "' or '" .. a_Split[1] .. " <chunk x> <chunk z>'" )
		return true
	end

	-- Get the coords of the chunk to regen:
	local chunkX = a_Player:GetChunkX()
	local chunkZ = a_Player:GetChunkZ()
	if (numParams == 3) then
		chunkX = tonumber(a_Split[2])
		chunkZ = tonumber(a_Split[3])
		if (chunkX == nil) then
			SendMessageFailure(a_Player, "Not a number: '" .. a_Split[2] .. "'")
			return true
		end
		if (chunkZ == nil) then
			SendMessageFailure(a_Player, "Not a number: '" .. a_Split[3] .. "'")
			return true
		end
	end

	-- Regenerate the chunk:
	SendMessageSuccess(a_Player, "Regenerating chunk [" .. chunkX .. ", " .. chunkZ .. "]...")
	a_Player:GetWorld():RegenerateChunk(chunkX, chunkZ)
	return true
end





function HandleConsoleRegen(a_Split)
	-- Check the params:
	local numParams = #a_Split
	if ((numParams ~= 3) and (numParams ~= 4)) then
		return true, "Usage: " .. a_Split[1] .. " <chunk x> <chunk z> [world]"
	end
	
	-- Get the coords of the chunk to regen:
	local chunkX = tonumber(a_Split[2])
	if (chunkX == nil) then
		return true, "Not a number: '" .. a_Split[2] .. "'"
	end
	local chunkZ = tonumber(a_Split[3])
	if (chunkZ == nil) then
		return true, "Not a number: '" .. a_Split[3] .. "'"
	end
	
	-- Get the world to regen:
	local world
	if (a_Split[4] == nil) then
		world = cRoot:Get():GetDefaultWorld()
	else
		world = cRoot:Get():GetWorld(a_Split[4])
		if (world == nil) then
			return true, "There's no world named '" .. a_Split[4] .. "'."
		end
	end
	
	-- Regenerate the chunk:
	world:RegenerateChunk(chunkX, chunkZ)
	return true, "Regenerating chunk [" .. chunkX .. ", " .. chunkZ .. "] in world " .. world:GetName()
end




