return
{
	HOOK_TICK =
	{
		CalledWhen = "Every server tick (approximately 20 times per second)",
		DefaultFnName = "OnTick",  -- also used as pagename
		Desc = [[
			This hook is called every game tick (50 msec, or 20 times a second). If the server is overloaded,
			the interval is larger, which is indicated by the TimeDelta parameter.</p>
			<p>
			This hook is called in the context of the server-tick thread, that is, the thread that takes care of
			{{cClientHandle|client connections}} before they're assigned to {{cPlayer|player entities}}, and
			processing console commands.
		]],
		Params =
		{
			{ Name = "TimeDelta", Type = "number", Notes = "The number of milliseconds elapsed since the last server tick. Will not be less than 50 msec." },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called. There is no overridable behavior.
		]],
	},  -- HOOK_TICK
}





