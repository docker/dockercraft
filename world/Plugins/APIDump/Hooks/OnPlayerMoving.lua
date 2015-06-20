return
{
	HOOK_PLAYER_MOVING =
	{
		CalledWhen = "Player tried to move in the tick being currently processed. Plugin may refuse movement.",
		DefaultFnName = "OnPlayerMoving",  -- also used as pagename
		Desc = [[
			This function is called in each server tick for each {{cPlayer|player}} that has sent any of the
			player-move packets. Plugins may refuse the movement.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who has moved. The object already has the new position stored in it." },
			{ Name = "OldPosition", Type = "{{Vector3d}}", Notes = "The old position." },
			{ Name = "NewPosition", Type = "{{Vector3d}}", Notes = "The new position." },
		},
		Returns = [[
			If the function returns true, movement is prohibited.</p>
			<p>
			If the function returns false or no value, other plugins' callbacks are called and finally the new
			position is permanently stored in the cPlayer object.</p>
		]],
	},  -- HOOK_PLAYER_MOVING
}





