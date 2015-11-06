return
{
	HOOK_COLLECTING_PICKUP =
	{
		CalledWhen = "Player is about to collect a pickup. Plugin can refuse / override behavior. ",
		DefaultFnName = "OnCollectingPickup",  -- also used as pagename
		Desc = [[
			This hook is called when a player is about to collect a pickup. Plugins may refuse the action.</p>
			<p>
			Pickup collection happens within the world tick, so if the collecting is refused, it will be tried
			again in the next world tick, as long as the player is within reach of the pickup.</p>
			<p>
			FIXME: There is no OnCollectedPickup() callback.</p>
			<p>
			FIXME: This callback is called even if the pickup doesn't fit into the player's inventory.</p>
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who's collecting the pickup" },
			{ Name = "Pickup", Type = "{{cPickup}}", Notes = "The pickup being collected" },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins' callbacks and finally the
			pickup is collected. If the function returns true, no other plugins are called for this event and
			the pickup is not collected.
		]],
	},  -- HOOK_COLLECTING_PICKUP
}




