return
{
	HOOK_POST_CRAFTING =
	{
		CalledWhen = "After the built-in recipes are checked and a recipe was found.",
		DefaultFnName = "OnPostCrafting",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cPlayer|player}} changes contents of their
			{{cCraftingGrid|crafting grid}}, after the recipe has been established by Cuberite. Plugins may use
			this to modify the resulting recipe or provide an alternate recipe.</p>
			<p>
			If a plugin implements custom recipes, it should do so using the {{OnPreCrafting|HOOK_PRE_CRAFTING}}
			hook, because that will save the server from going through the built-in recipes. The
			HOOK_POST_CRAFTING hook is intended as a notification, with a chance to tweak the result.</p>
			<p>
			Note that this hook is not called if a built-in recipe is not found;
			{{OnCraftingNoRecipe|HOOK_CRAFTING_NO_RECIPE}} is called instead in such a case.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who has changed their crafting grid contents" },
			{ Name = "Grid", Type = "{{cCraftingGrid}}", Notes = "The new crafting grid contents" },
			{ Name = "Recipe", Type = "{{cCraftingRecipe}}", Notes = "The recipe that Cuberite has decided to use (can be tweaked by plugins)" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called. If the function
			returns true, no other callbacks are called for this event. In either case, Cuberite uses the value
			of Recipe as the recipe to be presented to the player.
		]],
	},  -- HOOK_POST_CRAFTING
}





