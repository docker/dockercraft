--When someone uses tpa or tpahere request is saved in this array under targeted player uuid
--Type - Request type(used command - "/tpahere" or "/tpa"), Requester - uuid of requesting player, Time - request time
local TeleportRequests = {}

function HandleTPCommand(a_Split, a_Player)

	if #a_Split == 2 or #a_Split == 3 then

		-- Teleport to player specified in a_Split[2], tell them unless a_Split[3] equals "-h":
		TeleportToPlayer( a_Player, a_Split[2], (a_Split[3] ~= "-h") )
		return true

	elseif #a_Split == 4 then

		-- Teleport to XYZ coords specified in a_Split[2, 3, 4]:
		
		-- For relative coordinates
		local Function;
		local X = tonumber(a_Split[2]);
		Function = loadstring(a_Split[2]:gsub("~", "return " .. a_Player:GetPosX() .. "+0"));
		if Function then
			-- Execute the function in a save environment, and get the second return value. 
			-- The first return value is a boolean.
			X = select(2, pcall(setfenv(Function, {})));
		end
		
		local Y = tonumber(a_Split[3]);
		Function = loadstring(a_Split[3]:gsub("~", "return " .. a_Player:GetPosY() .. "+0"));
		if Function then
			-- Execute the function in a save environment, and get the second return value. 
			-- The first return value is a boolean.
			Y = select(2, pcall(setfenv(Function, {})));
		end
		
		local Z = tonumber(a_Split[4]);
		Function = loadstring(a_Split[4]:gsub("~", "return " .. a_Player:GetPosZ() .. "+0"));
		if Function then
			-- Execute the function in a save environment, and get the second return value. 
			-- The first return value is a boolean.
			Z = select(2, pcall(setfenv(Function, {})));
		end
		
		-- Check the given coordinates for errors.
		if (type(X) ~= 'number') then
			SendMessageFailure(a_Player, "'" .. a_Split[2] .. "' is not a valid number")
			return true
		end
		
		if (type(Y) ~= 'number') then
			SendMessageFailure(a_Player, "'" .. a_Split[3] .. "' is not a valid number")
			return true
		end
		
		if (type(Z) ~= 'number') then
			SendMessageFailure(a_Player, "'" .. a_Split[4] .. "' is not a valid number")
			return true
		end
		
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessageSuccess( a_Player, "You teleported to [X:" .. X .. " Y:" .. Y .. " Z:" .. Z .. "]" )
		return true

	else
		SendMessage( a_Player, "Usage: '" .. a_Split[1] .. " <player> [-h]' or '" .. a_Split[1] .. " <x> <y> <z>'" )
		return true
	end

end
