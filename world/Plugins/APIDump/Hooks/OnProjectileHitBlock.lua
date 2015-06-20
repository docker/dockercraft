return
{
	HOOK_PROJECTILE_HIT_BLOCK =
	{
		CalledWhen = "A projectile hits a solid block.",
		DefaultFnName = "OnProjectileHitBlock",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cProjectileEntity|projectile}} hits a solid block..
		]],
		Params =
		{
			{ Name = "ProjectileEntity", Type = "{{cProjectileEntity}}", Notes = "The projectile that hit an entity." },
			{ Name = "BlockX", Type = "number", Notes = "The X-coord where the projectile hit." },
			{ Name = "BlockY", Type = "number", Notes = "The Y-coord where the projectile hit." },
			{ Name = "BlockZ", Type = "number", Notes = "The Z-coord where the projectile hit." },
			{ Name = "BlockFace", Type = "number", Notes = "The side of the block where the projectile hit." },
			{ Name = "BlockHitPos", Type = "Vector3d", Notes = "The exact position where the projectile hit." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event and the projectile flies through block..
		]],
	},  -- HOOK_PROJECTILE_HIT_BLOCK
}





