return
{
	HOOK_PLAYER_PLACED_BLOCK =
	{
		CalledWhen = "After a player has placed a block. Notification only.",
		DefaultFnName = "OnPlayerPlacedBlock",  -- also used as pagename
		Desc = [[
			This hook is called after a {{cPlayer|player}} has placed a block in the {{cWorld|world}}. The block
			is already added to the world and the corresponding item removed from player's
			{{cInventory|inventory}}.</p>
			<p>
			Use the {{cPlayer}}:GetWorld() function to get the world to which the block belongs.</p>
			<p>
			See also the {{OnPlayerPlacingBlock|HOOK_PLAYER_PLACING_BLOCK}} hook for a similar hook called
			before the placement.</p>
			<p>
			If the client action results in multiple blocks being placed (such as a bed or a door), each separate
			block is reported through this hook. All the blocks are already present in the world before the first
			instance of this hook is called.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who placed the block" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockType", Type = "BLOCKTYPE", Notes = "The block type of the block" },
			{ Name = "BlockMeta", Type = "NIBBLETYPE", Notes = "The block meta of the block" },
		},
		Returns = [[
			If this function returns false or no value, Cuberite calls other plugins with the same event. If
			this function returns true, no other plugin is called for this event.
		]],
	},  -- HOOK_PLAYER_PLACED_BLOCK
}





