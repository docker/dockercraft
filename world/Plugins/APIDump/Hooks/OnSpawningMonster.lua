return
{
	HOOK_SPAWNING_MONSTER =
	{
		CalledWhen = "Before a monster is spawned in the world.",
		DefaultFnName = "OnSpawningMonster",  -- also used as pagename
		Desc = [[
			This hook is called before the server spawns a {{cMonster|monster}}. The plugins may modify the
			monster's parameters in the {{cMonster}} class, or disallow the spawning altogether. This hook is
			called before the {{OnSpawningEntity|HOOK_SPAWNING_ENTITY}} is called for the monster entity.</p>
			<p>
			See also the {{OnSpawnedMonster|HOOK_SPAWNED_MONSTER}} hook for a similar hook called after the
			monster is spawned.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the entity will spawn" },
			{ Name = "Monster", Type = "{{cMonster}} descentant", Notes = "The monster that will spawn" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. Finally, the server
			spawns the monster with whatever parameters the plugins set in the cMonster parameter.</p>
			<p>
			If the function returns true, no other callback is called for this event and the monster won't
			spawn.
		]],
	},  -- HOOK_SPAWNING_MONSTER
}





