return
{
	HOOK_CHUNK_AVAILABLE =
	{
		CalledWhen = "A chunk has just been added to world, either generated or loaded. ",
		DefaultFnName = "OnChunkAvailable",  -- also used as pagename
		Desc = [[
			This hook is called after a chunk is either generated or loaded from the disk. The chunk is
			already available for manipulation using the {{cWorld}} API. This is a notification-only callback,
			there is no behavior that plugins could override.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world to which the chunk belongs" },
			{ Name = "ChunkX", Type = "number", Notes = "X-coord of the chunk" },
			{ Name = "ChunkZ", Type = "number", Notes = "Z-coord of the chunk" },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event.
		]],
	},  -- HOOK_CHUNK_AVAILABLE
}




