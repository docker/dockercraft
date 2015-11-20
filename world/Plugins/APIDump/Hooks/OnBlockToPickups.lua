return
{
	HOOK_BLOCK_TO_PICKUPS =
	{
		CalledWhen = "A block is about to be dug ({{cPlayer|player}}, {{cEntity|entity}} or natural reason), plugins may override what pickups that will produce.",
		DefaultFnName = "OnBlockToPickups",  -- also used as pagename
		Desc = [[
			This callback gets called whenever a block is about to be dug. This includes {{cPlayer|players}}
			digging blocks, entities causing blocks to disappear ({{cTNTEntity|TNT}}, Endermen) and natural
			causes (water washing away a block). Plugins may override the amount and kinds of pickups this
			action produces.
		]],
		Params =
		{
			{ Name = "World", Type = "{{cWorld}}", Notes = "The world in which the block resides" },
			{ Name = "Digger", Type = "{{cEntity}} descendant", Notes = "The entity causing the digging. May be a {{cPlayer}}, {{cTNTEntity}} or even nil (natural causes)" },
			{ Name = "BlockX", Type = "number", Notes = "X-coord of the block" },
			{ Name = "BlockY", Type = "number", Notes = "Y-coord of the block" },
			{ Name = "BlockZ", Type = "number", Notes = "Z-coord of the block" },
			{ Name = "BlockType", Type = "BLOCKTYPE", Notes = "Block type of the block" },
			{ Name = "BlockMeta", Type = "NIBBLETYPE", Notes = "Block meta of the block" },
			{ Name = "Pickups", Type = "{{cItems}}", Notes = "Items that will be spawned as pickups" },
		},
		Returns = [[
			If the function returns false or no value, the next callback in the hook chain will be called. If
			the function returns true, no other callbacks in the chain will be called.</p>
			<p>
			Either way, the server will then spawn pickups specified in the Pickups parameter, so to disable
			pickups, you need to Clear the object first, then return true.
		]],
		CodeExamples =
		{
			{
				Title = "Modify pickups",
				Desc = "This example callback function makes tall grass drop diamonds when digged by natural causes (washed away by water).",
				Code = [[
function OnBlockToPickups(a_World, a_Digger, a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta, a_Pickups)
	if (a_Digger ~= nil) then
		-- Not a natural cause
		return false;
	end
	if (a_BlockType ~= E_BLOCK_TALL_GRASS) then
		-- Not a tall grass being washed away
		return false;
	end

	-- Remove all pickups suggested by Cuberite:
	a_Pickups:Clear();

	-- Drop a diamond:
	a_Pickups:Add(cItem(E_ITEM_DIAMOND));
	return true;
end;
				]],
			},
		} ,  -- CodeExamples
	},  -- HOOK_BLOCK_TO_PICKUPS
}




