return
{
	HOOK_HOPPER_PUSHING_ITEM =
	{
		CalledWhen = "A hopper is pushing an item into another block entity. ",
		DefaultFnName = "OnHopperPushingItem",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cHopperEntity|hopper}} transfers an {{cItem|item}} from its own
			internal storage into another block entity. A plugin may decide to disallow the move by returning
			true. Note that in such a case, the hook may be called again for the same hopper and block, with
			different slot numbers.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World where the hopper resides" },
			{ Name = "Hopper", Type = "{{cHopperEntity}}", Notes = "The hopper that is pushing the item" },
			{ Name = "SrcSlot", Type = "number", Notes = "Slot in the hopper that will lose the item" },
			{ Name = "DstBlockEntity", Type = "{{cBlockEntityWithItems}}", Notes = " 	The block entity that will receive the item" },
			{ Name = "DstSlot", Type = "number", Notes = "	Slot in DstBlockEntity's internal storage where the item will be stored" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event and the hopper will not push the item.
		]],
	},  -- HOOK_HOPPER_PUSHING_ITEM
}




