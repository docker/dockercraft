return
{
	HOOK_EXPLODING =
	{
		CalledWhen = "An explosion is about to be processed",
		DefaultFnName = "OnExploding",  -- also used as pagename
		Desc = [[
			This hook is called before an explosion has been processed in a world.</p>
			<p>
			See also {{OnExploded|HOOK_EXPLODED}} for a similar hook called after the explosion.</p>
			<p>
			The explosion carries with it the type of its source - whether it's a creeper exploding, or TNT,
			etc. It also carries the identification of the actual source. The exact type of the identification
			depends on the source kind:
			<table>
			<tr><th>Source</th><th>SourceData Type</th><th>Notes</th></tr>
			<tr><td>esPrimedTNT</td><td>{{cTNTEntity}}</td><td>An exploding primed TNT entity</td></tr>
			<tr><td>esCreeper</td><td>{{cCreeper}}</td><td>An exploding creeper or charged creeper</td></tr>
			<tr><td>esBed</td><td>{{Vector3i}}</td><td>A bed exploding in the Nether or in the End. The bed coords are given.</td></tr>
			<tr><td>esEnderCrystal</td><td>{{Vector3i}}</td><td>An ender crystal exploding upon hit. The block coords are given.</td></tr>
			<tr><td>esGhastFireball</td><td>{{cGhastFireballEntity}}</td><td>A ghast fireball hitting ground or an {{cEntity|entity}}.</td></tr>
			<tr><td>esWitherSkullBlack</td><td><i>TBD</i></td><td>A black wither skull hitting ground or an {{cEntity|entity}}.</td></tr>
			<tr><td>esWitherSkullBlue</td><td><i>TBD</i></td><td>A blue wither skull hitting ground or an {{cEntity|entity}}.</td></tr>
			<tr><td>esWitherBirth</td><td><i>TBD</i></td><td>A wither boss being created</td></tr>
			<tr><td>esOther</td><td><i>TBD</i></td><td>Any other previously unspecified type.</td></tr>
			<tr><td>esPlugin</td><td>object</td><td>An explosion created by a plugin. The plugin may specify any kind of data.</td></tr>
			</table></p>
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world where the explosion happens" },
			{ Name = "ExplosionSize", Type = "number", Notes = "The relative explosion size" },
			{ Name = "CanCauseFire", Type = "bool", Notes = "True if the explosion will turn random air blocks to fire (such as a ghast fireball)" },
			{ Name = "X", Type = "number", Notes = "X-coord of the explosion center" },
			{ Name = "Y", Type = "number", Notes = "Y-coord of the explosion center" },
			{ Name = "Z", Type = "number", Notes = "Z-coord of the explosion center" },
			{ Name = "Source", Type = "eExplosionSource", Notes = "Source of the explosion. See the table above." },
			{ Name = "SourceData", Type = "varies", Notes = "Additional data for the source. The exact type varies by the source. See the table above." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called, and finally
			Cuberite will process the explosion - destroy blocks and push + hurt entities. If the function
			returns true, no other callback is called for this event and the explosion will not occur.
		]],
	},  -- HOOK_EXPLODING
}




