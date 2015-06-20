function HandleKillCommand( Split, Player )

	if (Split[2] == nil) then
		Player:TakeDamage(dtInVoid, nil, 1000, 1000, 0)
		return true
	end

	local HasKilled = false;
	local KillPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
				OtherPlayer:TakeDamage(dtPlugin, nil, 1000, 1000, 0)
				HasKilled = true
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], KillPlayer);
	if (HasKilled) then
		SendMessageSuccess( Player, "Player " .. Split[2] .. " was killed" )
		return true
	else
		SendMessageFailure( Player, "Player not found" )
		return true
	end

end
