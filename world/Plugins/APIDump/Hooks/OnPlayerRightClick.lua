return
{
	HOOK_PLAYER_RIGHT_CLICK =
	{
		CalledWhen = "A right-click packet is received from the client. Plugin may override / refuse.",
		DefaultFnName = "OnPlayerRightClick",  -- also used as pagename
		Desc = [[
			This hook is called when Cuberite receives a right-click packet from the {{cClientHandle|client}}. It
			is called before any processing whatsoever is performed on the packet, meaning that hacked /
			malicious clients may be trigerring this event very often and with unchecked parameters. Therefore
			plugin authors are advised to use extreme caution with this callback.</p>
			<p>
			Plugins may refuse the default processing for the packet, causing Cuberite to behave as if the
			packet has never arrived. This may, however, create inconsistencies in the client - the client may
			think that they placed a block, while the server didn't process the placing, etc.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player whose client sent the packet" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockFace", Type = "number", Notes = "Face of the block upon which the player interacted. One of the BLOCK_FACE_ constants" },
			{ Name = "CursorX", Type = "number", Notes = "X-coord of the mouse crosshair on the block" },
			{ Name = "CursorY", Type = "number", Notes = "Y-coord of the mouse crosshair on the block" },
			{ Name = "CursorZ", Type = "number", Notes = "Z-coord of the mouse crosshair on the block" },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins' callbacks and finally sends
			the packet for further processing.</p>
			<p>
			If the function returns true, no other plugins are called, processing is halted.
		]],
	},  -- HOOK_PLAYER_RIGHT_CLICK
}





