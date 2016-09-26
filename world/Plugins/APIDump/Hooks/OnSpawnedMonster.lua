return
{
	HOOK_SPAWNED_MONSTER =
	{
		CalledWhen = "After a monster is spawned in the world",
		DefaultFnName = "OnSpawnedMonster",  -- also used as pagename
		Desc = [[
			This hook is called after the server spawns a {{cMonster|monster}}. This is an information-only
			callback, the monster is already spawned by the time it is called. After this hook is called, the
			{{OnSpawnedEntity|HOOK_SPAWNED_ENTITY}} is called for the monster entity.</p>
			<p>
			See also the {{OnSpawningMonster|HOOK_SPAWNING_MONSTER}} hook for a similar hook called before the
			monster is spawned.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the monster has spawned" },
			{ Name = "Monster", Type = "{{cMonster}} descendant", Notes = "The monster that has spawned" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event.
		]],
	},  -- HOOK_SPAWNED_MONSTER
}





