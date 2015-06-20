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
		SetBackCoordinates(a_Player)
		
		-- For relative coordinates
		local Function;
		local X = a_Split[2];
		Function = loadstring(a_Split[2]:gsub("~", "return " .. a_Player:GetPosX() .. "+0"));
		if Function then
			X = Function();
		end
		local Y = a_Split[3];
		Function = loadstring(a_Split[3]:gsub("~", "return " .. a_Player:GetPosY() .. "+0"));
		if Function then
			Y = Function();
		end
		local Z = a_Split[4];
		Function = loadstring(a_Split[4]:gsub("~", "return " .. a_Player:GetPosZ() .. "+0"));
		if Function then
			Z = Function();
		end
		
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessageSuccess( a_Player, "You teleported to [X:" .. X .. " Y:" .. Y .. " Z:" .. Z .. "]" )
		return true

	else
		SendMessage( a_Player, "Usage: /tp [PlayerName] (-h) or /tp [X Y Z]" )
		return true
	end

end

function HandleTPHereCommand(Split, Player)
	
	local flag = 0
	
	if #Split == 2 then

		local teleport = function( OtherPlayer )
			SetBackCoordinates(OtherPlayer)
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
			end
			OtherPlayer:TeleportToEntity( Player )
			SendMessageSuccess( Player, OtherPlayer:GetName() .. " teleported to you." )
			SendMessageSuccess( OtherPlayer, "You teleported to " .. Player:GetName() )
			flag = 1
		end
		
		cRoot:Get():FindAndDoWithPlayer(Split[2], teleport)
		
		if flag == 0 then
			SendMessageFailure(Player, "Player " ..  Split[2] .. " not found!")
		end
		
		return true
	else
		SendMessage( Player, "Usage: /tphere [PlayerName]" )
		return true
	end

end

function HandleTPACommand( Split, Player )

	local flag = 0
	
	if Split[2] == nil then
		SendMessage( Player, "Usage: " .. Split[1] .. " [Player]" )
		return true
	end
	
	if Split[2] == Player:GetName() then
		SendMessage( Player, "You can't teleport to yourself!" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if OtherPlayer:GetName() == Split[2] then
		
			if Split[1] == "/tpa" then
				SendMessage(OtherPlayer, Player:GetName() .. cChatColor.Plain .. " has requested to teleport to you." )
			else
				SendMessage(OtherPlayer, Player:GetName() .. cChatColor.Plain .. " has requested you to teleport to them." )
			end
			
			if TpRequestTimeLimit > 0 then
				OtherPlayer:SendMessage("This request will timeout after " .. TpRequestTimeLimit .. " seconds" )
			end
			
			OtherPlayer:SendMessage("To teleport, type " .. cChatColor.LightGreen .. "/tpaccept" )
			OtherPlayer:SendMessage("To deny this request, type " .. cChatColor.Rose .. "/tpdeny" )
			SendMessageSuccess( Player, "Request sent to " .. OtherPlayer:GetName() )
			
			TeleportRequests[OtherPlayer:GetUniqueID()] = {Type = Split[1], Requester = Player:GetUniqueID(), Time = GetTime() }
			
			flag = 1
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	if flag == 0 then
		SendMessageFailure(Player, "Player " ..  Split[2] .. " not found!")
	end
	
	return true

end

function HandleTPAcceptCommand( Split, Player )

	local flag = 0
	
	if TeleportRequests[Player:GetUniqueID()] == nil then
		SendMessageFailure( Player, "Nobody has send you a teleport request." )
		return true
	end
	
	if TpRequestTimeLimit > 0 then
		if TeleportRequests[Player:GetUniqueID()].Time + TpRequestTimeLimit < GetTime() then
			TeleportRequests[Player:GetUniqueID()] = nil
			SendMessageFailure( Player, "Teleport request timed out." )
			return true
		end
	end
	
	local loopPlayer = function( OtherPlayer )
	
		if TeleportRequests[Player:GetUniqueID()].Requester == OtherPlayer:GetUniqueID() then
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				if TeleportRequests[Player:GetUniqueID()].Type == "/tpa" then
					OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
				elseif TeleportRequests[Player:GetUniqueID()].Type == "/tpahere" then
					Player:MoveToWorld( OtherPlayer:GetWorld():GetName() )
				end
			end
			
			if TeleportRequests[Player:GetUniqueID()].Type == "/tpa" then
				SetBackCoordinates(OtherPlayer)
				OtherPlayer:TeleportToEntity( Player )
				SendMessageSuccess( Player, OtherPlayer:GetName() .. " teleported to you." )
				SendMessageSuccess( OtherPlayer, "You teleported to " .. Player:GetName() )
			elseif TeleportRequests[Player:GetUniqueID()].Type == "/tpahere" then
				SetBackCoordinates(Player)
				Player:TeleportToEntity( OtherPlayer )
				SendMessageSuccess( OtherPlayer, Player:GetName() .. " teleported to you." )
				SendMessageSuccess( Player, "You teleported to " .. OtherPlayer:GetName() )
			end
			
			flag = 1
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	TeleportRequests[Player:GetUniqueID()] = nil
	
	if flag == 0 then
		SendMessageFailure(Player, "Other player isn't online anymore!")
	end
	
	return true

end

function HandleTPDenyCommand( Split, Player )

	if TeleportRequests[Player:GetUniqueID()] == nil then
		SendMessageFailure( Player, "Nobody has send you a teleport request." )
		return true
	end
	
	if TpRequestTimeLimit > 0 then
		if TeleportRequests[Player:GetUniqueID()].Time + TpRequestTimeLimit < GetTime() then
			TeleportRequests[Player:GetUniqueID()] = nil
			SendMessageFailure( Player, "Teleport request timed out." )
			return true
		end
	end
	
	SendMessageSuccess( Player,"Request denied.")
	
	local loopPlayer = function( OtherPlayer )
		if TeleportRequests[Player:GetUniqueID()].Requester == OtherPlayer:GetUniqueID() then
			SendMessageFailure( OtherPlayer, Player:GetName() .. " has denied your request." )
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	TeleportRequests[Player:GetUniqueID()] = nil
	
	return true

end
