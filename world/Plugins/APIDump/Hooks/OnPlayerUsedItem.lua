return
{
	HOOK_PLAYER_USED_ITEM =
	{
		CalledWhen = "A player has used an item in hand (bucket...)",
		DefaultFnName = "OnPlayerUsedItem",  -- also used as pagename
		Desc = [[
			This hook is called after a {{cPlayer|player}} has right-clicked a block with an {{cItem|item}} that
			can be used (is not placeable, is not food and clicked block is not use-able), such as a bucket or a
			hoe. It is called after Cuberite processes the usage (places fluid / turns dirt to farmland).
			This is an information-only hook, there is no way to cancel the event anymore.</p>
			<p>
			Note that the block coords given in this callback are for the (solid) block that is being clicked,
			not the air block between it and the player.</p>
			<p>
			To get the world at which the right-click occurred, use the {{cPlayer}}:GetWorld() function. To get
			the item that the player is using, use the {{cPlayer}}:GetEquippedItem() function.</p>
			<p>
			See also the {{OnPlayerUsingItem|HOOK_PLAYER_USING_ITEM}} for a similar hook called before the use,
			the {{OnPlayerUsingBlock|HOOK_PLAYER_USING_BLOCK}} and {{OnPlayerUsedBlock|HOOK_PLAYER_USED_BLOCK}}
			for similar hooks called when a player interacts with a block, such as a chest.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who used the item" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the clicked block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the clicked block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the clicked block" },
			{ Name = "BlockFace", Type = "number", Notes = "Face of clicked block which has been clicked. One of the BLOCK_FACE_ constants" },
			{ Name = "CursorX", Type = "number", Notes = "X-coord of the cursor crosshair on the block being clicked" },
			{ Name = "CursorY", Type = "number", Notes = "Y-coord of the cursor crosshair on the block being clicked" },
			{ Name = "CursorZ", Type = "number", Notes = "Z-coord of the cursor crosshair on the block being clicked" },
			{ Name = "BlockType", Type = "number", Notes = "Block type of the clicked block" },
			{ Name = "BlockMeta", Type = "number", Notes = "Block meta of the clicked block" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called for this event.
		]],
	},  -- HOOK_PLAYER_USED_ITEM
}





