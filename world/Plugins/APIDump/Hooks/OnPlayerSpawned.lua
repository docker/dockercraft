return
{
	HOOK_PLAYER_SPAWNED =
	{
		CalledWhen = "After a player (re)spawns in the world to which they belong to.",
		DefaultFnName = "OnPlayerSpawned",  -- also used as pagename
		Desc = [[
			This hook is called after a {{cPlayer|player}} has spawned in the world. It is called after
			{{OnLogin|HOOK_LOGIN}} and {{OnPlayerJoined|HOOK_PLAYER_JOINED}}, after the player name has been
			authenticated, the initial worldtime, inventory and health have been sent to the player and the
			player spawn packet has been broadcast to all players near enough to the player spawn place. This is
			a notification-only event, plugins wishing to refuse player's entry should kick the player using the
			{{cPlayer}}:Kick() function.</p>
			<p>
			This hook is also called when the player respawns after death (and a respawn packet is received from
			the client, meaning the player has already clicked the Respawn button).
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who has (re)spawned" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called for this event. There is no overridable behavior.
		]],
	},  -- HOOK_PLAYER_SPAWNED
}





