return
{
	HOOK_PLAYER_JOINED =
	{
		CalledWhen = "After Login and before Spawned, before being added to world. ",
		DefaultFnName = "OnPlayerJoined",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cPlayer|player}} has completely logged in. If authentication is
			enabled, this function is called after their name has been authenticated. It is called after
			{{OnLogin|HOOK_LOGIN}} and before {{OnPlayerSpawned|HOOK_PLAYER_SPAWNED}}, right after the player's
			entity is created, but not added to the world yet. The player is not yet visible to other players.
			Returning true will block a join message from being broadcast, but otherwise, the player is still allowed to join.
			Plugins wishing to refuse player's entry should kick the player using the {{cPlayer}}:Kick() function.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who has joined the game" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called and a join message is broadcast. If the function
			returns true, no other callbacks are called for this event and a join message is not sent. Either way the player is let in.
		]],
	},  -- HOOK_PLAYER_JOINED
}





