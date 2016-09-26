return
{
	HOOK_KILLING =
	{
		CalledWhen = "A player or a mob is dying.",
		DefaultFnName = "OnKilling",  -- also used as pagename
		Desc = [[
			This hook is called whenever a {{cPawn|pawn}}'s (a player's or a mob's) health reaches zero. This
			means that the pawn is about to be killed, unless a plugin "revives" them by setting their health
			back to a positive value.
		]],
		Params =
		{
			{ Name = "Victim", Type = "{{cPawn}}", Notes = "The player or mob that is about to be killed" },
			{ Name = "Killer", Type = "{{cEntity}}", Notes = "The entity that has caused the victim to lose the last point of health. May be nil for environment damage" },
			{ Name = "TDI", Type = "{{TakeDamageInfo}}", Notes = "The damage type, cause and effects." },
		},
		Returns = [[
			If the function returns false or no value, Cuberite calls other plugins with this event. If the
			function returns true, no other plugin is called for this event.</p>
			<p>
			In either case, the victim's health is then re-checked and if it is greater than zero, the victim is
			"revived" with that health amount. If the health is less or equal to zero, the victim is killed.
		]],
	},  -- HOOK_KILLING
}




