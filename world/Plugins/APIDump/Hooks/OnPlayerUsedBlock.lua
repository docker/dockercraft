return
{
	HOOK_PLAYER_USED_BLOCK =
	{
		CalledWhen = "A player has just used a block (chest, furnace...). Notification only.",
		DefaultFnName = "OnPlayerUsedBlock",  -- also used as pagename
		Desc = [[
			This hook is called after a {{cPlayer|player}} has right-clicked a block that can be used, such as a
			{{cChestEntity|chest}} or a lever. It is called after MCServer processes the usage (sends the UI
			handling packets / toggles redstone). Note that for UI-related blocks, the player is most likely
			still using the UI. This is a notification-only event.</p>
			<p>
			Note that the block coords given in this callback are for the (solid) block that is being clicked,
			not the air block between it and the player.</p>
			<p>
			To get the world at which the right-click occurred, use the {{cPlayer}}:GetWorld() function.</p>
			<p>
			See also the {{OnPlayerUsingBlock|HOOK_PLAYER_USING_BLOCK}} for a similar hook called before the
			use, the {{OnPlayerUsingItem|HOOK_PLAYER_USING_ITEM}} and {{OnPlayerUsedItem|HOOK_PLAYER_USED_ITEM}}
			for similar hooks called when a player interacts with any block with a usable item in hand, such as
			a bucket.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who used the block" },
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
	},  -- HOOK_PLAYER_USED_BLOCK
}





