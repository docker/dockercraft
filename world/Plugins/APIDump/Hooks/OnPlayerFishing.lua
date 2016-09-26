return
{
	HOOK_PLAYER_FISHING =
	{
		CalledWhen = "A player is about to get a reward from fishing.",
		DefaultFnName = "OnPlayerFishing", -- also used as pagename
		Desc = [[
			This hook gets called when a player right clicks with a fishing rod while the floater is under water. The reward is already descided, but the plugin may change it.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who pulled the fish in." },
			{ Name = "Reward", Type = "{{cItems}}", Notes = "The reward the player gets. It can be a fish, treasure and junk." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. Afterwards, the
			server gives the player his reward. If the function returns true, no other
			callback is called for this event and the player doesn't get his reward.
		]],
	}, -- HOOK_PLAYER_FISHING
};
