return
{
	HOOK_WORLD_STARTED =
	{
		CalledWhen = "A {{cWorld|world}} is initialized",
		DefaultFnName = "OnWorldStarted",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cWorld|world}} is initialized.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World that is started" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event. There is no overridable behavior.
		]],
	},  -- HOOK_WORLD_STARTED
}





