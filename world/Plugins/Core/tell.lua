function HandleTellCommand(Split, Player)
	if (Split[2] == nil) or (Split[3] == nil) then
		SendMessage( Player, "Usage: "..Split[1].." <player> <message ...>")
		return true
	end
	
	local FoundPlayer = false
	
	local SendMessage = function(OtherPlayer)
	
		if (OtherPlayer:GetName() == Split[2]) then
			local newSplit = table.concat( Split, " ", 3 )
    
			SendMessageSuccess( Player, "Message to player " .. Split[2] .. " sent!" )
			OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
			
			lastsender[OtherPlayer:GetName()] = Player:GetName()
			
			FoundPlayer = true
		end
	end

	cRoot:Get():ForEachPlayer(SendMessage)
	
	if not FoundPlayer then
		SendMessageFailure( Player, 'Player "' ..Split[2].. '" not found')
	end
	
	return true;
end


function HandleRCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: "..Split[1].." <message ...>")
    else
        local SendMessage = function(OtherPlayer)
            if (OtherPlayer:GetName() == lastsender[Player:GetName()]) then
                local newSplit = table.concat( Split, " ", 2 )
                Player:SendMessageSuccess( "Message to player " .. lastsender[Player:GetName()] .. " sent!" )
                OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
                lastsender[OtherPlayer:GetName()] = Player:GetName()
                return true
            end
        end
        if lastsender[Player:GetName()] == nil then
            Player:SendMessageFailure("No last sender found")
        else
            if (not(cRoot:Get():FindAndDoWithPlayer(lastsender[Player:GetName()], SendMessage))) then
                Player:SendMessageFailure("Player not found")
            end
        end
    end
    return true
end
