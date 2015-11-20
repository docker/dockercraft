return
{
	HOOK_PLAYER_LEFT_CLICK =
	{
		CalledWhen = "A left-click packet is received from the client. Plugin may override / refuse.",
		DefaultFnName = "OnPlayerLeftClick",  -- also used as pagename
		Desc = [[
			This hook is called when Cuberite receives a left-click packet from the {{cClientHandle|client}}. It
			is called before any processing whatsoever is performed on the packet, meaning that hacked /
			malicious clients may be trigerring this event very often and with unchecked parameters. Therefore
			plugin authors are advised to use extreme caution with this callback.</p>
			<p>
			Plugins may refuse the default processing for the packet, causing Cuberite to behave as if the
			packet has never arrived. This may, however, create inconsistencies in the client - the client may
			think that they broke a block, while the server didn't process the breaking, etc. For this reason,
			if a plugin refuses the processing, Cuberite sends the block specified in the packet back to the
			client (as if placed anew), if the status code specified a block-break action. For other actions,
			plugins must rectify the situation on their own.</p>
			<p>
			The client sends the left-click packet for several other occasions, such as dropping the held item
			(Q keypress) or shooting an arrow. This is reflected in the Status code. Consult the
			<a href="http://wiki.vg/Protocol#0x0E">protocol documentation</a> for details on the actions.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player whose client sent the packet" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockFace", Type = "number", Notes = "Face of the block upon which the player interacted. One of the BLOCK_FACE_ constants" },
			{ Name = "Action", Type = "number", Notes = "Action to be performed on the block (\"status\" in the protocol docs)" },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins' callbacks and finally sends
			the packet for further processing.</p>
			<p>
			If the function returns true, no other plugins are called, processing is halted. If the action was a
			block dig, Cuberite sends the block specified in the coords back to the client. The packet is
			dropped.
		]],
	},  -- HOOK_PLAYER_LEFT_CLICK
}





