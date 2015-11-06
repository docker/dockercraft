return
{
	HOOK_PLAYER_ANIMATION =
	{
		CalledWhen = "A client has sent an Animation packet (0x12)",
		DefaultFnName = "OnPlayerAnimation",  -- also used as pagename
		Desc = [[
			This hook is called when the server receives an Animation packet (0x12) from the client.</p>
			<p>
			For the list of animations that are sent by the client, see the
			<a href="http://wiki.vg/Protocol#0x12">Protocol wiki</a>.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player from whom the packet was received" },
			{ Name = "Animation", Type = "number", Notes = "The kind of animation" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. Afterwards, the
			server broadcasts the animation packet to all nearby clients. If the function returns true, no other
			callback is called for this event and the packet is not broadcasted.
		]],
	},  -- HOOK_PLAYER_ANIMATION
}




