return
{
	HOOK_WORLD_TICK =
	{
		CalledWhen = "Every world tick (about 20 times per second), separately for each world",
		DefaultFnName = "OnWorldTick",  -- also used as pagename
		Desc = [[
			This hook is called for each {{cWorld|world}} every tick (50 msec, or 20 times a second). If the
			world is overloaded, the interval is larger, which is indicated by the TimeDelta parameter.</p>
			<p>
			This hook is called in the world's tick thread context and thus has access to all world data
			guaranteed without blocking.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World that is ticking" },
			{ Name = "TimeDelta", Type = "number", Notes = "The number of milliseconds since the previous game tick. Will not be less than 50 msec" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event. There is no overridable behavior.
		]],
	},  -- HOOK_WORLD_TICK
}





