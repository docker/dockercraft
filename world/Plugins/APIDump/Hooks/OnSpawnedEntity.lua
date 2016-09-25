return
{
	HOOK_SPAWNED_ENTITY =
	{
		CalledWhen = "After an entity is spawned in the world.",
		DefaultFnName = "OnSpawnedEntity",  -- also used as pagename
		Desc = [[
			This hook is called after the server spawns an {{cEntity|entity}}. This is an information-only
			callback, the entity is already spawned by the time it is called. If the entity spawned is a
			{{cMonster|monster}}, the {{OnSpawnedMonster|HOOK_SPAWNED_MONSTER}} hook is called before this
			hook.</p>
			<p>
			See also the {{OnSpawningEntity|HOOK_SPAWNING_ENTITY}} hook for a similar hook called before the
			entity is spawned.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the entity has spawned" },
			{ Name = "Entity", Type = "{{cEntity}} descentant", Notes = "The entity that has spawned" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event.
		]],
	},  -- HOOK_SPAWNED_ENTITY
}





