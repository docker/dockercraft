return
{
	HOOK_PLAYER_EATING =
	{
		CalledWhen = "When the player starts eating",
		DefaultFnName = "OnPlayerEating",  -- also used as pagename
		Desc = [[
			This hook gets called when the {{cPlayer|player}} starts eating, after the server checks that the
			player can indeed eat (is not satiated and is holding food). Plugins may still refuse the eating by
			returning true.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who started eating" },
		},
		Returns = [[
			If the function returns false or no value, the server calls the next plugin handler, and finally
			lets the player eat. If the function returns true, the server doesn't call any more callbacks for
			this event and aborts the eating. A "disallow" packet is sent to the client.
		]],
	},  -- HOOK_PLAYER_EATING
}





