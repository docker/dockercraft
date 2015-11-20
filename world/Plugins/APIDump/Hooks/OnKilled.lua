return 
{
	HOOK_KILLED = 
	{
		CalledWhen = "A player or a mob died.",
		DefaultFnName = "OnKilled",
		Desc = [[
			This hook is called whenever player or a mob dies. It can be used to change the death message.
		]],
		Params = 
		{
			{ Name = "Victim", Type = "{{cEntity}}", Notes = "The player or mob that died" },
			{ Name = "TDI", Type = "{{TakeDamageInfo}}", Notes = "Informations about the death" },
			{ Name = "DeathMessage", Type = "string", Notes = "The default death message. An empty string if the victim is not a player" },
		},
		Returns = [[
			The function may return two values. The first value is a boolean specifying whether other plugins should be called. If it is true, the other plugins won't get notified of the death. If it is false, the other plugins will get notified.</p>
			<p>The second value is a string containing the death message. If the victim is a player, this death message is broadcasted instead of the default death message. If it is empty, no death message is broadcasted. If it is nil, the message is left unchanged. If the victim is not a player, the death message is never broadcasted.</p>
			<p>In either case, the victim is dead.
		]],
	},  -- HOOK_KILLED
}
