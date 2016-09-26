return
{
	HOOK_CHUNK_GENERATING =
	{
		CalledWhen = "A chunk is about to be generated. Plugin can override the built-in generator.",
		DefaultFnName = "OnChunkGenerating",  -- also used as pagename
		Desc = [[
			This hook is called before the world generator starts generating a chunk. The plugin may provide
			some or all parts of the generation, by-passing the built-in generator. The function is given access
			to the {{cChunkDesc|ChunkDesc}} object representing the contents of the chunk. It may override parts
			of the built-in generator by using the object's <i>SetUseDefaultXXX(false)</i> functions. After all
			the callbacks for a chunk have been processed, the server will generate the chunk based on the
			{{cChunkDesc|ChunkDesc}} description - those parts that are set for generating (by default
			everything) are generated, the rest are read from the ChunkDesc object.</p>
			<p>
			See also the {{OnChunkGenerated|HOOK_CHUNK_GENERATED}} hook.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world to which the chunk will be added" },
			{ Name = "ChunkX", Type = "number", Notes = "X-coord of the chunk" },
			{ Name = "ChunkZ", Type = "number", Notes = "Z-coord of the chunk" },
			{ Name = "ChunkDesc", Type = "{{cChunkDesc}}", Notes = "Generated chunk data." },
		},
		Returns = [[
			If this function returns true, the server will not call any other plugin with the same chunk. If
			this function returns false, the server will call the rest of the plugins with the same chunk,
			possibly overwriting the ChunkDesc's contents.
		]],
	},  -- HOOK_CHUNK_GENERATING
}




