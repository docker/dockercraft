function HandleLocateCommand( Split, Player )
	SendMessage( Player, string.format("You are at [X:%i Y:%i Z:%i] in world %s", Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), Player:GetWorld():GetName()) )
	return true
end
