function HandleBackCommand( Split, Player )
	local BackPosition = BackCoords[Player:GetName()]

	if (BackPosition == nil) then
		SendMessageFailure(Player, "No known last position")
		return true
	end

	SetBackCoordinates(Player)
	local OnAllChunksAvaliable = function()
		Player:TeleportToCoords(BackPosition.x, BackPosition.y, BackPosition.z)
		SendMessageSuccess(Player, "Teleported back to your last known position")
	end

	Player:GetWorld():ChunkStay({{BackPosition.x/16, BackPosition.z/16}}, OnChunkAvailable, OnAllChunksAvaliable)
	return true
end
