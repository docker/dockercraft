return
{
	HOOK_WEATHER_CHANGED =
	{
		CalledWhen = "The weather has changed",
		DefaultFnName = "OnWeatherChanged",  -- also used as pagename
		Desc = [[
			This hook is called after the weather has changed in a {{cWorld|world}}. The new weather has already
			been sent to the clients.</p>
			<p>
			See also the {{OnWeatherChanging|HOOK_WEATHER_CHANGING}} hook for a similar hook called before the
			change.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World for which the weather has changed" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event. There is no overridable behavior.
		]],
	},  -- HOOK_WEATHER_CHANGED
}





