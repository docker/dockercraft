return
{
	HOOK_PLAYER_TOSSING_ITEM =
	{
		CalledWhen = "A player is tossing an item. Plugin may override / refuse.",
		DefaultFnName = "OnPlayerTossingItem",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cPlayer|player}} has tossed an item. The
			{{cPickup|pickup}} has not been spawned yet. Plugins may disallow the tossing, but in that case they
			need to clean up - the player's client already thinks the item has been tossed so the
			{{cInventory|inventory}} needs to be re-sent to the player.</p>
			<p>
			To get the item that is about to be tossed, call the {{cPlayer}}:GetEquippedItem() function.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player tossing an item" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called and finally Cuberite
			creates the pickup for the item and tosses it, using {{cPlayer}}:TossHeldItem, {{cPlayer}}:TossEquippedItem,
			or {{cPlayer}}:TossPickup. If the function returns true, no other callbacks are called for this event
			and Cuberite doesn't toss the item.
		]],
	},  -- HOOK_PLAYER_TOSSING_ITEM
}





