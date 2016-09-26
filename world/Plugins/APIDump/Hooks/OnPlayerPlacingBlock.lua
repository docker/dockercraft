return
{
	HOOK_PLAYER_PLACING_BLOCK =
	{
		CalledWhen = "Just before a player places a block. Plugin may override / refuse.",
		DefaultFnName = "OnPlayerPlacingBlock",  -- also used as pagename
		Desc = [[
			This hook is called just before a {{cPlayer|player}} places a block in the {{cWorld|world}}. The
			block is not yet placed, plugins may choose to override the default behavior or refuse the placement
			at all.</p>
			<p>
			Note that the client already expects that the block has been placed. For that reason, if a plugin
			refuses the placement, Cuberite sends the old block at the provided coords to the client.</p>
			<p>
			Use the {{cPlayer}}:GetWorld() function to get the world to which the block belongs.</p>
			<p>
			See also the {{OnPlayerPlacedBlock|HOOK_PLAYER_PLACED_BLOCK}} hook for a similar hook called after
			the placement.</p>
			<p>
			If the client action results in multiple blocks being placed (such as a bed or a door), each separate
			block is reported through this hook and only if all of them succeed, all the blocks are placed. If
			any one of the calls are refused by the plugin, all the blocks are refused and reverted on the client.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who is placing the block" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockType", Type = "BLOCKTYPE", Notes = "The block type of the block" },
			{ Name = "BlockMeta", Type = "NIBBLETYPE", Notes = "The block meta of the block" },
		},
		Returns = [[
			If this function returns false or no value, Cuberite calls other plugins with the same event and
			finally places the block and removes the corresponding item from player's inventory. If this
			function returns true, no other plugin is called for this event, Cuberite sends the old block at
			the specified coords to the client and drops the packet.
		]],
	},  -- HOOK_PLAYER_PLACING_BLOCK
}





