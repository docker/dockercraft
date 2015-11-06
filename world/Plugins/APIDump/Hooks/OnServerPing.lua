return
{
	HOOK_SERVER_PING =
	{
		CalledWhen = "Client pings the server from the server list.",
		DefaultFnName = "OnServerPing",  -- also used as pagename
		Desc = [[
			A plugin may implement an OnServerPing() function and register it as a Hook to process pings from
			clients in the server server list. It can change the logged in players and player capacity, as well
			as the server description and the favicon, that are displayed to the client in the server list.</p>
			<p>
			The client handle already has its protocol version assigned to it, so the plugin can check that; however,
			there's no username associated with the client yet, and no player object.
		]],
		Params = {
			{ Name = "ClientHandle", Type = "{{cClientHandle}}", Notes = "The client handle that pinged the server" },
			{ Name = "ServerDescription", Type = "string", Notes = "The server description" },
			{ Name = "OnlinePlayersCount", Type = "number", Notes = "The number of players currently on the server" },
			{ Name = "MaxPlayersCount", Type = "number", Notes = "The current player cap for the server" },
			{ Name = "Favicon", Type = "string", Notes = "The base64 encoded favicon to be displayed in the server list for compatible clients" },
		},
		Returns = [[
			The plugin can return whether to continue processing of the hook with other plugins, the server description to
			be displayed to the client, the currently online players, the player cap and the base64/png favicon data, in that order.
		]],
		CodeExamples = {
			{
				Title = "Change information returned to the player",
				Desc = "Tells the client that the server description is 'test', there are one more players online than there actually are, and that the player cap is zero. It also changes the favicon data.",
				Code = [[
function OnServerPing(ClientHandle, ServerDescription, OnlinePlayers, MaxPlayers, Favicon)
	-- Change Server Description
	ServerDescription = "Test"

	-- Change online / max players
	OnlinePlayers = OnlinePlayers + 1
	MaxPlayers = 0

	-- Change favicon
	if cFile:IsFile("my-favicon.png") then
		local FaviconData = cFile:ReadWholeFile("my-favicon.png")
		if (FaviconData ~= "") and (FaviconData ~= nil) then
			Favicon = Base64Encode(FaviconData)
		end
	end

	return false, ServerDescription, OnlinePlayers, MaxPlayers, Favicon
end				
				]],
			},
		},
	},  -- HOOK_SERVER_PING
}
