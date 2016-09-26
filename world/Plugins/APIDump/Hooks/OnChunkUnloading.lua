return
{
	HOOK_CHUNK_UNLOADING =
	{
		CalledWhen = " 	A chunk is about to be unloaded from the memory. Plugins may refuse the unload.",
		DefaultFnName = "OnChunkUnloading",  -- also used as pagename
		Desc = [[
			Cuberite calls this function when a chunk is about to be unloaded from the memory. A plugin may
			force Cuberite to keep the chunk in memory by returning true.</p>
			<p>
			FIXME: The return value should be used only for event propagation stopping, not for the actual
			decision whether to unload.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world from which the chunk is unloading" },
			{ Name = "ChunkX", Type = "number", Notes = "X-coord of the chunk" },
			{ Name = "ChunkZ", Type = "number", Notes = "Z-coord of the chunk" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called and finally Cuberite
			unloads the chunk. If the function returns true, no other callback is called for this event and the
			chunk is left in the memory.
		]],
	},  -- HOOK_CHUNK_UNLOADING
}




