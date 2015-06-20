return
{
	HOOK_PLAYER_DESTROYED =
	{
		CalledWhen = "A player object is about to be destroyed.",
		DefaultFnName = "OnPlayerDestroyed",  -- also used as pagename
		Desc = [[
			This function is called before a {{cPlayer|player}} is about to be destroyed.
			The player has disconnected for whatever reason and is no longer in the server.
			If a plugin returns true, a leave message is not broadcast, and vice versa.
			However, whatever the return value, the player object is removed from memory.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The destroyed player" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called and a leave message is broadcast.
			If the function returns true, no other callbacks are called for this event and no leave message appears. Either way the player is removed internally. 
		]],
	},  -- HOOK_PLAYER_DESTROYED
}





