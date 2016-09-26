return
{
	HOOK_UPDATING_SIGN =
	{
		CalledWhen = "Before the sign text is updated. Plugin may modify the text / refuse.",
		DefaultFnName = "OnUpdatingSign",  -- also used as pagename
		Desc = [[
			This hook is called when a sign text is about to be updated, either as a result of player's
			manipulation or any other event, such as a plugin setting the sign text. Plugins may modify the text
			or refuse the update altogether.</p>
			<p>
			See also the {{OnUpdatedSign|HOOK_UPDATED_SIGN}} hook for a similar hook called after the update.
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
			The function may return up to five values. If the function returns true as the first value, no other
			callbacks are called for this event and the sign is not updated. If the function returns no value or
			false as its first value, other plugins' callbacks are called.</p>
			<p>
			The other up to four values returned are used to update the sign text, line by line, respectively.
			Note that other plugins may again update the texts (if the first value returned is false).
		]],
		CodeExamples =
		{
			{
				Title = "Add player signature",
				Desc = "The following example appends a player signature to the last line, if the sign is updated by a player:",
				Code = [[
function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
	if (Player == nil) then
		-- Not changed by a player
		return false;
	end

	-- Sign with playername, allow other plugins to interfere:
	return false, Line1, Line2, Line3, Line4 .. Player:GetName();
end
				]],
			}
		} ,
	},  -- HOOK_UPDATING_SIGN
}





