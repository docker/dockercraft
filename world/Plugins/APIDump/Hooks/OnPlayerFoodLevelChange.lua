return
{
	HOOK_PLAYER_FOOD_LEVEL_CHANGE =
	{
		CalledWhen = "Called before the player food level changed. Plugin may override",
		DefaultFnName = "OnPlayerFoodLevelChange", -- also used as pagename
		Desc = [[
			This hook is called before the food level changes.
			The food level is not changed yet, plugins may choose
			to refuse the change.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who changes the food level." },
			{ Name = "NewFoodLevel", Type = "number", Notes = "The new food level." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. Afterwards, the
			server changes the food level of the player. If the function returns true, no
			other callback is called for this event and the player's food level doesn't change.
		]],
	}, -- HOOK_PLAYER_FOOD_LEVEL_CHANGE
};




