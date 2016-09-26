return
{
	HOOK_PRE_CRAFTING =
	{
		CalledWhen = "Before the built-in recipes are checked.",
		DefaultFnName = "OnPreCrafting",  -- also used as pagename
		Desc = [[
			This hook is called when a {{cPlayer|player}} changes contents of their
			{{cCraftingGrid|crafting grid}}, before the built-in recipes are searched for a match by Cuberite.
			Plugins may use this hook to provide a custom recipe.</p>
			<p>
			If you intend to tweak built-in recipes, use the {{OnPostCrafting|HOOK_POST_CRAFTING}} hook, because
			that will be called once the built-in recipe is matched.</p>
			<p>
			Also note a third hook, {{OnCraftingNoRecipe|HOOK_CRAFTING_NO_RECIPE}}, that is called when Cuberite
			cannot find any built-in recipe for the given ingredients.
		]],
		Params =
		{
			{ Name = "Player", Type = "{{cPlayer}}", Notes = "The player who has changed their crafting grid contents" },
			{ Name = "Grid", Type = "{{cCraftingGrid}}", Notes = "The new crafting grid contents" },
			{ Name = "Recipe", Type = "{{cCraftingRecipe}}", Notes = "The recipe that Cuberite will use. Modify this object to change the recipe" },
		},
		Returns = [[
			If the function returns false or no value, other plugins' callbacks are called and then Cuberite
			searches the built-in recipes. The Recipe output parameter is ignored in this case.</p>
			<p>
			If the function returns true, no other callbacks are called for this event and Cuberite uses the
			recipe stored in the Recipe output parameter.
		]],
	},  -- HOOK_PRE_CRAFTING
}





