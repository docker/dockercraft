return
{
	HOOK_PLAYER_BREAKING_BLOCK =
	{
		CalledWhen = "Just before a player breaks a block. Plugin may override / refuse. ",
		DefaultFnName = "OnPlayerBreakingBlock",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cPlayer|player}} breaks a block, before the block is actually broken in
			the {{cWorld|World}}. Plugins may refuse the breaking.</p>
			<p>
			See also the {{OnPlayerBrokenBlock|HOOK_PLAYER_BROKEN_BLOCK}} hook for a similar hook called after
			the block is broken.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who is digging the block" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockFace", Type = "number", Notes = "Face of the block upon which the player is acting. One of the BLOCK_FACE_ constants" },
			{ Name = "BlockType", Type = "BLOCKTYPE", Notes = "The block type of the block being broken" },
			{ Name = "BlockMeta", Type = "NIBBLETYPE", Notes = "The block meta of the block being broken " },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called, and then the block
			is broken. If the function returns true, no other plugin's callback is called and the block breaking
			is cancelled. The server re-sends the block back to the player to replace it (the player's client
			already thinks the block was broken).
		]],
	},  -- HOOK_PLAYER_BREAKING_BLOCK
}





