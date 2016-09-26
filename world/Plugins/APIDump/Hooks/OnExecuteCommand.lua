return
{
	HOOK_EXECUTE_COMMAND =
	{
		CalledWhen = [[
			A player executes an in-game command, or the admin issues a console command. Note that built-in
			console commands are exempt to this hook - they are always performed and the hook is not called.
		]],
		DefaultFnName = "OnExecuteCommand",  -- also used as pagename
		Desc = [[
			A plugin may implement a callback for this hook to intercept both in-game commands executed by the
			players and console commands executed by the server admin. The function is called for every in-game
			command sent from any player and for those server console commands that are not built in in the
			server.</p>
			<p>
			If the command is in-game, the first parameter to the hook function is the {{cPlayer|player}} who's
			executing the command. If the command comes from the server console, the first parameter is nil.</p>
			<p>
			The server calls this hook even for unregistered (unknown) console commands. It also calls the hook
			for unknown in-game commands, as long as they begin with a slash ('/'). If a plugin needs to intercept
			in-game chat messages not beginning with a slash, it should use the {{OnChat|HOOK_CHAT}} hook.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "For in-game commands, the player who has sent the message. For console commands, nil" },
			{ Name = "CommandSplit", Type = "array-table of strings", Notes = "The command and its parameters, broken into a table by spaces" },
			{ Name = "EntireCommand", Type = "string", Notes = "The entire command as a single string" },
		},
		Returns = [[
			If the plugin returns false, Cuberite calls all the remaining hook handlers and finally the command
			will be executed. If the plugin returns true, the none of the remaining hook handlers will be called.
			In this case the plugin can return a second value, specifying whether what the command result should
			be set to, one of the {{cPluginManager#CommandResult|CommandResult}} constants. If not
			provided, the value defaults to crBlocked.
		]],
	},  -- HOOK_EXECUTE_COMMAND
}




