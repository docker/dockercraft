function OnPlayerJoined(a_Player)
	-- Send the MOTD to the player:
	ShowMOTDTo(a_Player)
	
	-- Add a message to the webadmin chat:
	WEBLOGINFO(a_Player:GetName() .. " has joined the game")
	
	return false
end




