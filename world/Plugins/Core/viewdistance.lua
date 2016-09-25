function HandleViewDistanceCommand( Split, Player )

	if( #Split ~= 2 ) then
		SendMessage( Player, "Usage: /viewdistance <".. cClientHandle.MIN_VIEW_DISTANCE .."-".. cClientHandle.MAX_VIEW_DISTANCE ..">" )
		return true
	end

	Player:GetClientHandle():SetViewDistance( Split[2] )
	SendMessageSuccess( Player, "Your view distance has been set to " .. Player:GetClientHandle():GetViewDistance() )
	return true

end
