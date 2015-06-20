function HandleFlyCommand(Split, Player)
	
	local function ChangeFly( newPlayer )
		newPlayer:SetCanFly(not newPlayer:CanFly());
		newPlayer:SendMessageSuccess("Fly mode toggled!")
		return true
	end
	
	if (Split[2] == nil or Split[2] == Player:GetName()) then
		ChangeFly(Player)
	elseif (Player:HasPermission("core.fly.others")) then
		
		if cRoot:Get():FindAndDoWithPlayer( Split[2], ChangeFly ) then
			Player:SendMessageSuccess("Fly mode for player " .. Split[2] ..  " toggled!")
		else
			SendMessageFailure( Player, "Player " .. Split[2] ..  " isn't online!")
		end
		
	else 
		Player:SendMessageFailure("You need core.fly.others permission to do that!")
	end
	
	return true
	
end
