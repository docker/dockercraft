return
{
	HOOK_UPDATED_SIGN =
	{
		CalledWhen = "After the sign text is updated. Notification only.",
		DefaultFnName = "OnUpdatedSign",  -- also used as pagename
		Desc = [[
			This hook is called after a sign has had its text updated. The text is already updated at this
			point.</p>
			<p>The update may have been caused either by a {{cPlayer|player}} directly updating the sign, or by
			a plugin changing the sign text using the API.</p>
			<p>
			See also the {{OnUpdatingSign|HOOK_UPDATING_SIGN}} hook for a similar hook called before the update,
			with a chance to modify the text.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the sign resides" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the sign" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the sign" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the sign" },
			{ Name = "Line1", Type = "string", Notes = "1st line of the new text" },
			{ Name = "Line2", Type = "string", Notes = "2nd line of the new text" },
			{ Name = "Line3", Type = "string", Notes = "3rd line of the new text" },
			{ Name = "Line4", Type = "string", Notes = "4th line of the new text" },
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who is changing the text. May be nil for non-player updates." }
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called. There is no overridable behavior.
		]],
	},  -- HOOK_UPDATED_SIGN
}





