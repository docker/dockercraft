function HandleVanishCommand(Split, Player)
	
	local function ChangeVanish( newPlayer )
	
		newPlayer:SetVisible(not newPlayer:IsVisible());
	
		if newPlayer:IsVisible() then
			newPlayer:SendMessageSuccess("You aren't hidden anymore!")
		else
			newPlayer:SendMessageSuccess("You are now hidden!")
		end
		
		return true
	end
	
	if (Split[2] == nil or Split[2] == Player:GetName()) then
		ChangeVanish(Player)
	elseif Player:HasPermission("core.vanish.others") then
		
		if cRoot:Get():FindAndDoWithPlayer( Split[2], ChangeVanish ) then
			Player:SendMessageSuccess( Split[2] ..  "s visibility has been toggled!")
		else
			SendMessageFailure( Player, "Player " .. Split[2] ..  " isn't online!")
		end
		
	else 
		Player:SendMessageFailure("You need core.vanish.others permission to do that!")
	end
	
	return true
	
end
