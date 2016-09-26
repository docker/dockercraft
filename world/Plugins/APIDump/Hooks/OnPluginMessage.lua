return
{
	HOOK_PLUGIN_MESSAGE =
	{
		CalledWhen = "The server receives a plugin message from a client",
		DefaultFnName = "OnPluginMessage",  -- also used as pagename
		Desc = [[
			A plugin may implement an OnPluginMessage() function and register it as a Hook to process plugin messages
			from the players. The function is then called for every plugin message sent from any player.
		]],
		Params = {
			{ Name = "Client", Type = "{{cClientHandle}}", Notes = "The client who sent the plugin message" },
			{ Name = "Channel", Type = "string", Notes = "The channel on which the message was sent" },
			{ Name = "Message", Type = "string", Notes = "The message's payload" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called for this event.
		]],
	},  -- HOOK_CHAT
}




