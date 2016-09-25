return
{
	HOOK_ENTITY_ADD_EFFECT =
	{
		CalledWhen = "An entity effect is about to get added to an entity.",
		DefaultFnName = "OnEntityAddEffect",  -- also used as pagename
		Desc = [[
			This hook is called whenever an entity effect is about to be added to an entity. The plugin may
			disallow the addition by returning true.</p>
			<p>Note that this hook only fires for adding the effect, but not for the actual effect application. See
			also the {{OnEntityRemoveEffect|HOOK_ENTITY_REMOVE_EFFECT}} for notification about effects expiring /
			removing, and {{OnEntityApplyEffect|HOOK_ENTITY_APPLY_EFFECT}} for the actual effect application to the
			entity.
		]],
		Params =
		{
			{ Name = "Entity", Type = "{{cEntity}}", Notes = "The entity to which the effect is about to be added" },
			{ Name = "EffectType", Type = "number", Notes = "The type of the effect to be added. One of the effXXX constants." },
			{ Name = "EffectDuration", Type = "number", Notes = "The duration of the effect to be added, in ticks." },
			{ Name = "EffectIntensity", Type = "number", Notes = "The intensity (level) of the effect to be added. " },
			{ Name = "DistanceModifier", Type = "number", Notes = "The modifier for the effect intensity, based on distance. Used mainly for splash potions." },
		},
		Returns = [[
			If the plugin returns true, the effect will not be added and none of the remaining hook handlers will
			be called. If the plugin returns false, Cuberite calls all the remaining hook handlers and finally
			the effect is added to the entity.
		]],
	},  -- HOOK_EXECUTE_COMMAND
}




