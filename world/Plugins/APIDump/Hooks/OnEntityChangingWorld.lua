return
{
	HOOK_ENTITY_CHANGING_WORLD =
	{
		CalledWhen = "Before a entity is changing the world.",
		DefaultFnName = "OnEntityChangingWorld",  -- also used as pagename
		Desc = [[
			This hook is called before the server moves the {{cEntity|entity}} to the given world. Plugins may
			refuse the changing of the entity to the new world.<p>
			See also the {{OnEntityChangedWorld|HOOK_ENTITY_CHANGED_WORLD}} hook for a similar hook is called after the
			entity has been moved to the world.
		]],
		Params =
		{
			{ Name = "Entity", Type = "{{cEntity}}", Notes = "The entity that wants to change the world" },
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world to which the entity wants to change" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event and the change of the entity to the world is
			cancelled.
		]],
	},  -- HOOK_ENTITY_CHANGING_WORLD
}





