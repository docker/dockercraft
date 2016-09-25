return
{
	HOOK_HOPPER_PULLING_ITEM =
	{
		CalledWhen = "A hopper is pulling an item from another block entity.",
		DefaultFnName = "OnHopperPullingItem",  -- also used as pagename
		Desc = [[
			This callback is called whenever a {{cHopperEntity|hopper}} transfers an {{cItem|item}} from another
			block entity into its own internal storage. A plugin may decide to disallow the move by returning
			true. Note that in such a case, the hook may be called again for the same hopper, with different
			slot numbers.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World where the hopper resides" },
			{ Name = "Hopper", Type = "{{cHopperEntity}}", Notes = "The hopper that is pulling the item" },
			{ Name = "DstSlot", Type = "number", Notes = "The destination slot in the hopper's {{cItemGrid|internal storage}}" },
			{ Name = "SrcBlockEntity", Type = "{{cBlockEntityWithItems}}", Notes = "The block entity that is losing the item" },
			{ Name = "SrcSlot", Type = "number", Notes = "Slot in SrcBlockEntity from which the item will be pulled" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event and the hopper will not pull the item.
		]],
	},  -- HOOK_HOPPER_PULLING_ITEM
}




