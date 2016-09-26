return
{
	HOOK_PLAYER_BROKEN_BLOCK =
	{
		CalledWhen = "After a player has broken a block. Notification only.",
		DefaultFnName = "OnPlayerBrokenBlock",  -- also used as pagename
		Desc = [[
			This function is called after a {{cPlayer|player}} breaks a block. The block is already removed
			from the {{cWorld|world}} and {{cPickup|pickups}} have been spawned. To get the world in which the
			block has been dug, use the {{cPlayer}}:GetWorld() function.</p>
			<p>
			See also the {{OnPlayerBreakingBlock|HOOK_PLAYER_BREAKING_BLOCK}} hook for a similar hook called
			before the block is broken. To intercept the creation of pickups, see the
			{{OnBlockToPickups|HOOK_BLOCK_TO_PICKUPS}} hook.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who broke the block" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockFace", Type = "number", Notes = "Face of the block upon which the player interacted. One of the BLOCK_FACE_ constants" },
			{ Name = "BlockType", Type = "BLOCKTYPE", Notes = "The block type of the block" },
			{ Name = "BlockMeta", Type = "NIBBLETYPE", Notes = "The block meta of the block" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event.
		]],
	},  -- HOOK_PLAYER_BROKEN_BLOCK
}





