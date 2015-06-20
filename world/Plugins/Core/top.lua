function HandleTopCommand( Split, Player )

	local World = Player:GetWorld()

	local PlayerPos = Player:GetPosition()
	local Height = World:GetHeight( math.floor( PlayerPos.x ), math.floor( PlayerPos.z ) )
	SetBackCoordinates( Player )
	Player:TeleportToCoords( PlayerPos.x, Height+1, PlayerPos.z )
	SendMessageSuccess( Player, "Teleported to the topmost block" )

	return true

end
