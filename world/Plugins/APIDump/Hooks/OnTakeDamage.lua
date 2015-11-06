return
{
	HOOK_TAKE_DAMAGE =
	{
		CalledWhen = "An {{cEntity|entity}} is taking any kind of damage",
		DefaultFnName = "OnTakeDamage",  -- also used as pagename
		Desc = [[
			This hook is called when any {{cEntity}} descendant, such as a {{cPlayer|player}} or a
			{{cMonster|mob}}, takes any kind of damage. The plugins may modify the amount of damage or effects
			with this hook by editting the {{TakeDamageInfo}} object passed.</p>
			<p>
			This hook is called after the final damage is calculated, including all the possible weapon
			{{cEnchantments|enchantments}}, armor protection and potion effects.
		]],
		Params =
		{
			{ Name = "Receiver", Type = "{{cEntity}} descendant", Notes = "The entity taking damage" },
			{ Name = "TDI", Type = "{{TakeDamageInfo}}", Notes = "The damage type, cause and effects. Plugins may modify this object to alter the final damage applied." },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called and then the server
			applies the final values from the TDI object to Receiver. If the function returns true, no other
			callbacks are called, and no damage nor effects are applied.
		]],
	},  -- HOOK_TAKE_DAMAGE
}





