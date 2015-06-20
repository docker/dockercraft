return
{
	HOOK_HANDSHAKE =
	{
		CalledWhen = "A client is connecting.",
		DefaultFnName = "OnHandshake",  -- also used as pagename
		Desc = [[
			This hook is called when a client sends the Handshake packet. At this stage, only the client IP and
			(unverified) username are known. Plugins may refuse access to the server based on this
			information.</p>
			<p>
			Note that the username is not authenticated - the authentication takes place only after this hook is
			processed.
		]],
		Params =
		{
			{ Name = "Client", Type = "{{cClientHandle}}", Notes = "The client handle representing the connection. Note that there's no {{cPlayer}} object for this client yet." },
			{ Name = "UserName", Type = "string", Notes = "The username presented in the packet. Note that this username is unverified." },
		},
		Returns = [[
			If the function returns false, the user is let in to the server. If the function returns true, no
			other plugin's callback is called, the user is kicked and the connection is closed.
		]],
	},  -- HOOK_HANDSHAKE
}




