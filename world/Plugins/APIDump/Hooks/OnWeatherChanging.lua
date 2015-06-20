return
{
	HOOK_WEATHER_CHANGING =
	{
		CalledWhen = "The weather is about to change",
		DefaultFnName = "OnWeatherChanging",  -- also used as pagename
		Desc = [[
			This hook is called when the current weather has expired and a new weather is selected. Plugins may
			override the new weather being set.</p>
			<p>
			The new weather setting is sent to the clients only after this hook has been processed.</p>
			<p>
			See also the {{OnWeatherChanged|HOOK_WEATHER_CHANGED}} hook for a similar hook called after the
			change.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "World for which the weather is changing" },
			{ Name = "Weather", Type = "number", Notes = "The newly selected weather. One of wSunny, wRain, wStorm" },
		},
		Returns = [[
			The hook handler can return up to two values. If the first value is false or not present, the server
			calls other plugins' callbacks and finally sets the weather. If it is true, the server doesn't call any
			more callbacks for this hook. The second value returned is used as the new weather. If no value is
			given, the weather from the parameters is used as the weather. Returning false as the first value and a
			specific weather constant as the second value makes the server call the rest of the hook handlers with
			the new weather value.
		]],
	},  -- HOOK_WEATHER_CHANGING
}





