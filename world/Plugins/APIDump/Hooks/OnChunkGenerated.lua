return
{
	HOOK_CHUNK_GENERATED =
	{
		CalledWhen = "After a chunk was generated. Notification only.",
		DefaultFnName = "OnChunkGenerated",  -- also used as pagename
		Desc = [[
			This hook is called when world generator finished its work on a chunk. The chunk data has already
			been generated and is about to be stored in the {{cWorld|world}}. A plugin may provide some
			last-minute finishing touches to the generated data. Note that the chunk is not yet stored in the
			world, so regular {{cWorld}} block API will not work! Instead, use the {{cChunkDesc}} object
			received as the parameter.</p>
			<p>
			See also the {{OnChunkGenerating|HOOK_CHUNK_GENERATING}} hook.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world to which the chunk will be added" },
			{ Name = "ChunkX", Type = "number", Notes = "X-coord of the chunk" },
			{ Name = "ChunkZ", Type = "number", Notes = "Z-coord of the chunk" },
			{ Name = "ChunkDesc", Type = "{{cChunkDesc}}", Notes = "Generated chunk data. Plugins may still modify the chunk data contained." },
		},
		Returns = [[
			If the plugin returns false or no value, Cuberite will call other plugins' callbacks for this event.
			If a plugin returns true, no other callback is called for this event.</p>
			<p>
			In either case, Cuberite will then store the data from ChunkDesc as the chunk's contents in the world.
		]],
		CodeExamples =
		{
			{
				Title = "Generate emerald ore",
				Desc = "This example callback function generates one block of emerald ore in each chunk, under the condition that the randomly chosen location is in an ExtremeHills biome.",
				Code = [[
function OnChunkGenerated(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	-- Generate a psaudorandom value that is always the same for the same X/Z pair, but is otherwise random enough:
	-- This is actually similar to how Cuberite does its noise functions
	local PseudoRandom = (a_ChunkX * 57 + a_ChunkZ) * 57 + 19785486
	PseudoRandom = PseudoRandom * 8192 + PseudoRandom;
	PseudoRandom = ((PseudoRandom * (PseudoRandom * PseudoRandom * 15731 + 789221) + 1376312589) % 0x7fffffff;
	PseudoRandom = PseudoRandom / 7;

	-- Based on the PseudoRandom value, choose a location for the ore:
	local OreX = PseudoRandom % 16;
	local OreY = 2 + ((PseudoRandom / 16) % 20);
	local OreZ = (PseudoRandom / 320) % 16;

	-- Check if the location is in ExtremeHills:
	if (a_ChunkDesc:GetBiome(OreX, OreZ) ~= biExtremeHills) then
		return false;
	end

	-- Only replace allowed blocks with the ore:
	local CurrBlock = a_ChunDesc:GetBlockType(OreX, OreY, OreZ);
	if (
		(CurrBlock == E_BLOCK_STONE) or
		(CurrBlock == E_BLOCK_DIRT) or
		(CurrBlock == E_BLOCK_GRAVEL)
	) then
		a_ChunkDesc:SetBlockTypeMeta(OreX, OreY, OreZ, E_BLOCK_EMERALD_ORE, 0);
	end
end;
				]],
			},
		} ,  -- CodeExamples
	},  -- HOOK_CHUNK_GENERATED
}