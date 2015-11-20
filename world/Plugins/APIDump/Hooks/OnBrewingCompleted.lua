return
{
	HOOK_BREWING_COMPLETED =
	{
		CalledWhen = "A brewing process is completed.",
		DefaultFnName = "OnBrewingCompleted",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cBrewingstand|brewing stand}} has completed the brewing process.
			See also the {{OnBrewingCompleting|HOOK_BREWING_COMPLETING}} hook for a similar hook, is called when a
			brewing process is completing.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World where the brewing stand resides." },
			{ Name = "Brewingstand", Type = "{{cBrewingstand}}", Notes = "The brewing stand that completed the brewing process." },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins with this event. If the
			function returns true, no other plugin is called for this event.</p>
		]],
	},  -- HOOK_BREWING_COMPLETED
}




