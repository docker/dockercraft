return
{
	HOOK_BLOCK_SPREAD =
	{
		CalledWhen = "Called when a block spreads based on world conditions",
		DefaultFnName = "OnBlockSpread",  -- also used as pagename
		Desc = [[
			This hook is called when a block spreads.</p>
			<p>
			The spread carries with it the type of its source - whether it's a block spreads.
			It also carries the identification of the actual source. The exact type of the identification
			depends on the source kind:
			<table>
			<tr><th>Source</th><th>Notes</th></tr>
			<tr><td>ssFireSpread</td><td>Fire spreading</td></tr>
			<tr><td>ssGrassSpread</td><td>Grass spreading</td></tr>
			<tr><td>ssMushroomSpread</td><td>Mushroom spreading</td></tr>
			<tr><td>ssMycelSpread</td><td>Mycel spreading</td></tr>
			<tr><td>ssVineSpread</td><td>Vine spreading</td></tr>
			</table></p>
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the block resides" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "Source", Type = "eSpreadSource", Notes = "Source of the spread. See the table above." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called, and finally
			Cuberite will process the spread. If the function
			returns true, no other callback is called for this event and the spread will not occur.
		]],
	},  -- HOOK_BLOCK_SPREAD
}




