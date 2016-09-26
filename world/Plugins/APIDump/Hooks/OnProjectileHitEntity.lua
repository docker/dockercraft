return
{
	HOOK_PROJECTILE_HIT_ENTITY =
	{
		CalledWhen = "A projectile hits another entity.",
		DefaultFnName = "OnProjectileHitEntity",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cProjectileEntity|projectile}} hits another entity.
		]],
		Params =
		{
			{ Name = "ProjectileEntity", Type = "{{cProjectileEntity}}", Notes = "The projectile that hit an entity." },
			{ Name = "Entity", Type = "{{cEntity}}", Notes = "The entity wich was hit." },
		},
		Returns = [[
			If the function returns false or no value, the next plugin's callback is called. If the function
			returns true, no other callback is called for this event and the projectile flies through the entity.
		]],
	},  -- HOOK_PROJECTILE_HIT_ENTITY
}





