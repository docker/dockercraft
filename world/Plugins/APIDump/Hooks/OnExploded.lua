return
{
	HOOK_EXPLODED =
	{
		CalledWhen = "An explosion has happened",
		DefaultFnName = "OnExploded",  -- also used as pagename
		Desc = [[
			This hook is called after an explosion has been processed in a world.</p>
			<p>
			See also {{OnExploding|HOOK_EXPLODING}} for a similar hook called before the explosion.</p>
			<p>
			The explosion carries with it the type of its source - whether it's a creeper exploding, or TNT,
			etc. It also carries the identification of the actual source. The exact type of the identification
			depends on the source kind, see the {{Globals#ExplosionSource|esXXX}} constants' descriptions for details.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world where the explosion happened" },
			{ Name = "ExplosionSize", Type = "number", Notes = "The relative explosion size" },
			{ Name = "CanCauseFire", Type = "bool", Notes = "True if the explosion has turned random air blocks to fire (such as a ghast fireball)" },
			{ Name = "X", Type = "number", Notes = "X-coord of the explosion center" },
			{ Name = "Y", Type = "number", Notes = "Y-coord of the explosion center" },
			{ Name = "Z", Type = "number", Notes = "Z-coord of the explosion center" },
			{ Name = "Source", Type = "eExplosionSource", Notes = "Source of the explosion. See the table above." },
			{ Name = "SourceData", Type = "varies", Notes = "Additional data for the source. The exact type varies by the source. See the {{Globals#ExplosionSource|esXXX}} constants' descriptions." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event. There is no overridable behaviour.
		]],
	},  -- HOOK_EXPLODED
}




