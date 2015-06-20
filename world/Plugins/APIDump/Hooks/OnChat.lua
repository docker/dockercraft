return
{
	HOOK_CHAT =
	{
		CalledWhen = "Player sends a chat message",
		DefaultFnName = "OnChat",  -- also used as pagename
		Desc = [[
			A plugin may implement an OnChat() function and register it as a Hook to process chat messages from
			the players. The function is then called for every in-game message sent from any player. Note that
			registered in-game commands are not sent through this hook. Use the
			{{OnExecuteCommand|HOOK_EXECUTE_COMMAND}} to intercept registered in-game commands.
		]],
		Params = {
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who sent the message" },
			{ Name = "Message", Type = "string", Notes = "The message" },
		},
		Returns = [[
			The plugin may return 2 values. The first is a boolean specifying whether the hook handling is to be
			stopped or not. If it is false, the message is broadcast to all players in the world. If it is true,
			no message is broadcast and no further action is taken.</p>
			<p>
			The second value is specifies the message to broadcast. This way, plugins may modify the message. If
			the second value is not provided, the original message is used.
		]],
	},  -- HOOK_CHAT
}




