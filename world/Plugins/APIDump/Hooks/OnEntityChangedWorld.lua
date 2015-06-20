return
{
	HOOK_ENTITY_CHANGED_WORLD =
	{
		CalledWhen = "After a entity has changed the world.",
		DefaultFnName = "OnEntityChangedWorld",  -- also used as pagename
		Desc = [[
			This hook is called after the server has moved the {{cEntity|entity}} to the given world. This is an information-only
			callback, the entity is already in the new world.<p>
			See also the {{OnEntityChangingWorld|HOOK_ENTITY_CHANGING_WORLD}} hook for a similar hook called before the
			entity is moved to the new world.
		]],
		Params =
		{
			{ Name = "Entity", Type = "{{cEntity}}", Notes = "The entity that has changed the world" },
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world from which the entity has come" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event.
		]],
	},  -- HOOK_ENTITY_CHANGED_WORLD
}





