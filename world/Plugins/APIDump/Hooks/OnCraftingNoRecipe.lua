return
{
	HOOK_CRAFTING_NO_RECIPE =
	{
		CalledWhen = " 	No built-in crafting recipe is found. Plugin may provide a recipe.",
		DefaultFnName = "OnCraftingNoRecipe",  -- also used as pagename
		Desc = [[
			This callback is called when a player places items in their {{cCraftingGrid|crafting grid}} and
			Cuberite cannot find a built-in {{cCraftingRecipe|recipe}} for the combination. Plugins may provide
			a recipe for the ingredients given.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player whose crafting is reported in this hook" },
			{ Name = "Grid", Type = "{{cCraftingGrid}}", Notes = "Contents of the player's crafting grid" },
			{ Name = "Recipe", Type = "{{cCraftingRecipe}}", Notes = "The recipe that will be used (can be filled by plugins)" },
		},
		Returns = [[
			If the function returns false or no value, no recipe will be used. If the function returns true, no
			other plugin will have their callback called for this event and Cuberite will use the crafting
			recipe in Recipe.</p>
			<p>
			FIXME: To allow plugins give suggestions and overwrite other plugins' suggestions, we should change
			the behavior with returning false, so that the recipe will still be used, but fill the recipe with
			empty values by default.
		]],
	},  -- HOOK_CRAFTING_NO_RECIPE
}




