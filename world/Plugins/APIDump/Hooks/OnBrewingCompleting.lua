return
{
	HOOK_BREWING_COMPLETING =
	{
		CalledWhen = "A brewing process is completing.",
		DefaultFnName = "OnBrewingCompleting",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cBrewingstand|brewing stand}} is completing the brewing process. Plugins may
			refuse the completing of the brewing process.<p>
			See also the {{OnBrewingCompleted|HOOK_BREWING_COMPLETED}} hook for a similar hook, is called after the
			brewing process has been completed.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World where the brewing stand resides." },
			{ Name = "Brewingstand", Type = "{{cBrewingstand}}", Notes = "The brewing stand that completes the brewing process." },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins with this event. If the function returns true,
			no other plugin's callback is called and the brewing process is canceled.
			<p>
		]],
	},  -- HOOK_BREWING_COMPLETING
}




