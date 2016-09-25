return
{
	HOOK_CHUNK_UNLOADED =
	{
		CalledWhen = "A chunk has been unloaded from the memory.",
		DefaultFnName = "OnChunkUnloaded",  -- also used as pagename
		Desc = [[
			This hook is called when a chunk is unloaded from the memory. Though technically still in memory,
			the plugin should behave as if the chunk was already not present. In particular, {{cWorld}} block
			API should not be used in the area of the specified chunk.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world from which the chunk is unloading" },
			{ Name = "ChunkX", Type = "number", Notes = "X-coord of the chunk" },
			{ Name = "ChunkZ", Type = "number", Notes = "Z-coord of the chunk" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event. There is no behavior that plugins could
			override.
		]],
	},  -- HOOK_CHUNK_UNLOADED
}




