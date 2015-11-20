return
{
	HOOK_ENTITY_TELEPORT =
	{
		CalledWhen = "Any entity teleports. Plugin may refuse teleport.",
		DefaultFnName = "OnEntityTeleport",  -- also used as pagename
		Desc = [[
			This function is called in each server tick for each {{cEntity|Entity}} that has
			teleported. Plugins may refuse the teleport.
		]],
		Params =
		{
			{ Name = "Entity", Type = "{{cEntity}}", Notes = "The entity who has teleported. New position is set in the object after successfull teleport" },
			{ Name = "OldPosition", Type = "{{Vector3d}}", Notes = "The old position." },
			{ Name = "NewPosition", Type = "{{Vector3d}}", Notes = "The new position." },
		},
		Returns = [[
			If the function returns true, teleport is prohibited.</p>
			<p>
			If the function returns false or no value, other plugins' callbacks are called and finally the new
			position is permanently stored in the cEntity object.</p>
		]],
	},  -- HOOK_ENTITY_TELEPORT
}





