return
{
	cBeaconEntity =
	{
		Desc = [[
			A beacon entity is a {{cBlockEntityWithItems}} descendant that represents a beacon
			in the world.
		]],
		Functions =
		{
			CalculatePyramidLevel =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Calculate the amount of layers the pyramid below the beacon has.",
			},
			GetBeaconLevel =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the beacon level. (0 - 4)",
			},
			GetPrimaryEffect =
			{
				Returns =
				{
					{
						Name = "EffectType",
						Type = "cEntityEffect#eType",
					},
				},
				Notes = "Returns the primary effect.",
			},
			GetSecondaryEffect =
			{
				Returns =
				{
					{
						Name = "EffectType",
						Type = "cEntityEffect#eType",
					},
				},
				Notes = "Returns the secondary effect.",
			},
			GiveEffects =
			{
				Notes = "Give the near-players the effects.",
			},
			IsActive =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Is the beacon active?",
			},
			IsBeaconBlocked =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Is the beacon blocked by non-transparent blocks that are higher than the beacon?",
			},
			IsMineralBlock =
			{
				IsStatic = true,
				Params =
				{
					{
						Name = "BlockType",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the block is a diamond block, a golden block, an iron block or an emerald block.",
			},
			IsValidEffect =
			{
				IsStatic = true,
				Params =
				{
					{
						Name = "EffectType",
						Type = "cEntityEffect#eType",
					},
					{
						Name = "BeaconLevel",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the effect can be used.",
			},
			SetPrimaryEffect =
			{
				Params =
				{
					{
						Name = "EffectType",
						Type = "cEntityEffect#eType",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Select the primary effect. Returns false when the effect is invalid.",
			},
			SetSecondaryEffect =
			{
				Params =
				{
					{
						Name = "EffectType",
						Type = "cEntityEffect#eType",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Select the secondary effect. Returns false when the effect is invalid.",
			},
			UpdateBeacon =
			{
				Notes = "Update the beacon.",
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cBlockEntity =
	{
		Desc = [[
			Block entities are simply blocks in the world that have persistent data, such as the text for a sign
			or contents of a chest. All block entities are also saved in the chunk data of the chunk they reside in.
			The cBlockEntity class acts as a common ancestor for all the individual block entities.
		]],
		Functions =
		{
			GetBlockType =
			{
				Returns =
				{
					{
						Name = "BLOCKTYPE",
						Type = "number",
					},
				},
				Notes = "Returns the blocktype which is represented by this blockentity. This is the primary means of type-identification",
			},
			GetChunkX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the chunk X-coord of the block entity's chunk",
			},
			GetChunkZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the chunk Z-coord of the block entity's chunk",
			},
			GetPos =
			{
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
				Notes = "Returns the name of the parent class, or empty string if no parent class.",
			},
			GetPosX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the block X-coord of the block entity's block",
			},
			GetPosY =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the block Y-coord of the block entity's block",
			},
			GetPosZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the block Z-coord of the block entity's block",
			},
			GetRelX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the relative X coord of the block entity's block within the chunk",
			},
			GetRelZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the relative Z coord of the block entity's block within the chunk",
			},
			GetWorld =
			{
				Returns =
				{
					{
						Type = "cWorld",
					},
				},
				Notes = "Returns the world to which the block entity belongs",
			},
		},
	},
	cBlockEntityWithItems =
	{
		Desc = [[
			This class is a common ancestor for all {{cBlockEntity|block entities}} that provide item storage.
			Internally, the object has a {{cItemGrid|cItemGrid}} object for storing the items; this ItemGrid is
			accessible through the API. The storage is a grid of items, items in it can be addressed either by a slot
			number, or by XY coords within the grid. If a UI window is opened for this block entity, the item storage
			is monitored for changes and the changes are immediately sent to clients of the UI window.
		]],
		Functions =
		{
			GetContents =
			{
				Returns =
				{
					{
						Type = "cItemGrid",
					},
				},
				Notes = "Returns the cItemGrid object representing the items stored within this block entity",
			},
			GetSlot =
			{
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the cItem for the specified slot number. Returns nil for invalid slot numbers",
				},
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the cItem for the specified slot coords. Returns nil for invalid slot coords",
				},
			},
			SetSlot =
			{
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the cItem for the specified slot number. Ignored if invalid slot number",
				},
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the cItem for the specified slot coords. Ignored if invalid slot coords",
				},
			},
		},
		Inherits = "cBlockEntity",
	},
	cBrewingstandEntity =
	{
		Desc = [[
			This class represents a brewingstand entity in the world.</p>
			<p>
			See also the {{cRoot}}:GetBrewingRecipe() function.
		]],
		Functions =
		{
			GetBrewingTimeLeft =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the time until the current items finishes brewing, in ticks",
			},
			GetIndgredientSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the ingredient slot",
			},
			GetLeftBottleSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the left bottle slot",
			},
			GetMiddleBottleSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the middle bottle slot",
			},
			GetResultItem =
			{
				Params =
				{
					{
						Name = "SlotNumber",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the expected result item for the given slot number.",
			},
			GetRightBottleSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the right bottle slot",
			},
			GetTimeBrewed =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the time that the current items has been brewing, in ticks",
			},
			SetIngredientSlot =
			{
				Params =
				{
					{
						Name = "Ingredient",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the ingredient bottle slot",
			},
			SetLeftBottleSlot =
			{
				Params =
				{
					{
						Name = "LeftSlot",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the left bottle slot",
			},
			SetMiddleBottleSlot =
			{
				Params =
				{
					{
						Name = "MiddleSlot",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the middle bottle slot",
			},
			SetRightBottleSlot =
			{
				Params =
				{
					{
						Name = "RightSlot",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the right bottle slot",
			},
		},
		Constants =
		{
			bsIngredient =
			{
				Notes = "Index of the ingredient slot",
			},
			bsLeftBottle =
			{
				Notes = "Index of the left bottle slot",
			},
			bsMiddleBottle =
			{
				Notes = "Index of the middle bottle slot",
			},
			bsRightBottle =
			{
				Notes = "Index of the right bottle slot",
			},
			ContentsHeight =
			{
				Notes = "Height (Y) of the {{cItemGrid|cItemGrid}} representing the contents",
			},
			ContentsWidth =
			{
				Notes = "Width (X) of the {{cItemGrid|cItemGrid}} representing the contents",
			},
		},
		ConstantGroups =
		{
			SlotIndices =
			{
				Include = "bs.*",
				TextBefore = "When using the GetSlot() or SetSlot() function, use these constants for slot index:",
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cChestEntity =
	{
		Desc = [[
			A chest entity is a {{cBlockEntityWithItems|cBlockEntityWithItems}} descendant that represents a chest
			in the world. Note that doublechests consist of two separate cChestEntity objects, they do not collaborate
			in any way.</p>
			<p>
			To manipulate a chest already in the game, you need to use {{cWorld}}'s callback mechanism with
			either DoWithChestAt() or ForEachChestInChunk() function. See the code example below
		]],
		Constants =
		{
			ContentsHeight =
			{
				Notes = "Height of the contents' {{cItemGrid|ItemGrid}}, as required by the parent class, {{cBlockEntityWithItems}}",
			},
			ContentsWidth =
			{
				Notes = "Width of the contents' {{cItemGrid|ItemGrid}}, as required by the parent class, {{cBlockEntityWithItems}}",
			},
		},
		AdditionalInfo =
		{
			{
				Header = "Code example",
				Contents = [[
					The following example code sets the top-left item of each chest in the same chunk as Player to
					64 * diamond:
<pre class="prettyprint lang-lua">
-- Player is a {{cPlayer}} object instance
local World = Player:GetWorld();
World:ForEachChestInChunk(Player:GetChunkX(), Player:GetChunkZ(),
	function (ChestEntity)
		ChestEntity:SetSlot(0, 0, cItem(E_ITEM_DIAMOND, 64));
	end
);
</pre>
				]],
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cCommandBlockEntity =
	{
		Functions =
		{
			Activate =
			{
				Notes = "Sets the command block to execute a command in the next tick",
			},
			GetCommand =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Retrieves stored command",
			},
			GetLastOutput =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Retrieves the last line of output generated by the command block",
			},
			GetResult =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Retrieves the result (signal strength) of the last operation",
			},
			SetCommand =
			{
				Params =
				{
					{
						Name = "Command",
						Type = "string",
					},
				},
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Sets the command",
			},
		},
		Inherits = "cBlockEntity",
	},
	cDispenserEntity =
	{
		Desc = [[
			This class represents a dispenser block entity in the world. Most of this block entity's
			functionality is implemented in the {{cDropSpenserEntity}} class that represents
			the behavior common with the {{cDropperEntity|dropper}} block entity.
		]],
		Functions =
		{
			GetShootVector =
			{
				IsStatic = true,
				Params =
				{
					{
						Name = "BlockMeta",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "Vector3d",
					},
				},
				Notes = "Returns a unit vector in the cardinal direction of where the dispenser with the specified meta would be facing.",
			},
			SpawnProjectileFromDispenser =
			{
				Params =
				{
					{
						Name = "BlockX",
						Type = "number",
					},
					{
						Name = "BlockY",
						Type = "number",
					},
					{
						Name = "BlockZ",
						Type = "number",
					},
					{
						Name = "Kind",
						Type = "cProjectileEntity#eKind",
					},
					{
						Name = "Speed",
						Type = "Vector3d",
					},
					{
						Name = "Item",
						Type = "cItem",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Spawns a projectile of the given kind in front of the dispenser with the specified speed. Returns the UniqueID of the spawned projectile, or {{cEntity#INVALID_ID|cEntity.INVALID_ID}} on failure.",
			},
		},
		Inherits = "cDropSpenserEntity",
	},
	cDropperEntity =
	{
		Desc = [[
			This class represents a dropper block entity in the world. Most of this block entity's functionality
			is implemented in the {{cDropSpenserEntity|cDropSpenserEntity}} class that represents the behavior
			common with the {{cDispenserEntity|dispenser}} entity.</p>
			<p>
			An object of this class can be created from scratch when generating chunks ({{OnChunkGenerated|OnChunkGenerated}} and {{OnChunkGenerating|OnChunkGenerating}} hooks).
		]],
		Inherits = "cDropSpenserEntity",
	},
	cDropSpenserEntity =
	{
		Desc = [[
			This is a class that implements behavior common to both {{cDispenserEntity|dispensers}} and {{cDropperEntity|droppers}}.
		]],
		Functions =
		{
			Activate =
			{
				Notes = "Sets the block entity to dropspense an item in the next tick",
			},
			AddDropSpenserDir =
			{
				Params =
				{
					{
						Name = "BlockX",
						Type = "number",
					},
					{
						Name = "BlockY",
						Type = "number",
					},
					{
						Name = "BlockZ",
						Type = "number",
					},
					{
						Name = "BlockMeta",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Name = "BlockX",
						Type = "number",
					},
					{
						Name = "BlockY",
						Type = "number",
					},
					{
						Name = "BlockZ",
						Type = "number",
					},
				},
				Notes = "Adjusts the block coords to where the dropspenser items materialize",
			},
			SetRedstonePower =
			{
				Params =
				{
					{
						Name = "IsPowered",
						Type = "boolean",
					},
				},
				Notes = "Sets the redstone status of the dropspenser. If the redstone power goes from off to on, the dropspenser will be activated",
			},
		},
		Constants =
		{
			ContentsHeight =
			{
				Notes = "Height (Y) of the {{cItemGrid}} representing the contents",
			},
			ContentsWidth =
			{
				Notes = "Width (X) of the {{cItemGrid}} representing the contents",
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cFlowerPotEntity =
	{
		Desc = [[
			This class represents a flower pot entity in the world.
		]],
		Functions =
		{
			GetItem =
			{
				Returns =
				{
					{
						Name = "Item",
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the flower pot.",
			},
			IsItemInPot =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Is a flower in the pot?",
			},
			SetItem =
			{
				Params =
				{
					{
						Name = "Item",
						Type = "cItem",
					},
				},
				Notes = "Set the item in the flower pot",
			},
		},
		Inherits = "cBlockEntity",
	},
	cFurnaceEntity =
	{
		Desc = [[
			This class represents a furnace block entity in the world.</p>
			<p>
			See also {{cRoot}}'s GetFurnaceRecipe() and GetFurnaceFuelBurnTime() functions
		]],
		Functions =
		{
			GetCookTimeLeft =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the time until the current item finishes cooking, in ticks",
			},
			GetFuelBurnTimeLeft =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the time until the current fuel is depleted, in ticks",
			},
			GetFuelSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the fuel slot",
			},
			GetInputSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the input slot",
			},
			GetOutputSlot =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item in the output slot",
			},
			GetTimeCooked =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the time that the current item has been cooking, in ticks",
			},
			HasFuelTimeLeft =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if there's time before the current fuel is depleted",
			},
			SetFuelSlot =
			{
				Params =
				{
					{
						Name = "Fuel",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the fuel slot",
			},
			SetInputSlot =
			{
				Params =
				{
					{
						Name = "Input",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the input slot",
			},
			SetOutputSlot =
			{
				Params =
				{
					{
						Name = "Output",
						Type = "cItem",
					},
				},
				Notes = "Sets the item in the output slot",
			},
		},
		Constants =
		{
			ContentsHeight =
			{
				Notes = "Height (Y) of the {{cItemGrid|cItemGrid}} representing the contents",
			},
			ContentsWidth =
			{
				Notes = "Width (X) of the {{cItemGrid|cItemGrid}} representing the contents",
			},
			fsFuel =
			{
				Notes = "Index of the fuel slot",
			},
			fsInput =
			{
				Notes = "Index of the input slot",
			},
			fsOutput =
			{
				Notes = "Index of the output slot",
			},
		},
		ConstantGroups =
		{
			SlotIndices =
			{
				Include = "fs.*",
				TextBefore = "When using the GetSlot() or SetSlot() function, use these constants for slot index:",
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cHopperEntity =
	{
		Desc = [[
			This class represents a hopper block entity in the world.
		]],
		Functions =
		{
			GetOutputBlockPos =
			{
				Params =
				{
					{
						Name = "BlockMeta",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Name = "IsAttached",
						Type = "boolean",
					},
					{
						Name = "BlockX",
						Type = "number",
					},
					{
						Name = "BlockY",
						Type = "number",
					},
					{
						Name = "BlockZ",
						Type = "number",
					},
				},
				Notes = "Returns whether the hopper is attached, and if so, the block coords of the block receiving the output items, based on the given meta.",
			},
		},
		Constants =
		{
			ContentsHeight =
			{
				Notes = "Height (Y) of the internal {{cItemGrid}} representing the hopper contents.",
			},
			ContentsWidth =
			{
				Notes = "Width (X) of the internal {{cItemGrid}} representing the hopper contents.",
			},
			TICKS_PER_TRANSFER =
			{
				Notes = "Number of ticks between when the hopper transfers items.",
			},
		},
		Inherits = "cBlockEntityWithItems",
	},
	cJukeboxEntity =
	{
		Desc = [[
			This class represents a jukebox in the world. It can play the records, either when the
			{{cPlayer|player}} uses the record on the jukebox, or when a plugin instructs it to play.
		]],
		Functions =
		{
			EjectRecord =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Ejects the current record as a {{cPickup|pickup}}. No action if there's no current record. To remove record without generating the pickup, use SetRecord(0). Returns true if pickup ejected.",
			},
			GetRecord =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the record currently present. Zero for no record, E_ITEM_*_DISC for records.",
			},
			IsPlayingRecord =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the jukebox is playing a record.",
			},
			IsRecordItem =
			{
				Params =
				{
					{
						Name = "ItemType",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the specified item is a record that can be played.",
			},
			PlayRecord =
			{
				Params =
				{
					{
						Name = "RecordItemType",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Plays the specified Record. Return false if the parameter isn't a playable Record (E_ITEM_XXX_DISC). If there is a record already playing, ejects it first.",
			},
			SetRecord =
			{
				Params =
				{
					{
						Name = "RecordItemType",
						Type = "number",
					},
				},
				Notes = "Sets the currently present record. Use zero for no record, or E_ITEM_*_DISC for records.",
			},
		},
		Inherits = "cBlockEntity",
	},
	cMobHeadEntity =
	{
		Desc = [[
			This class represents a mob head block entity in the world.
		]],
		Functions =
		{
			GetOwnerName =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the player name of the mob head",
			},
			GetOwnerTexture =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the player texture of the mob head",
			},
			GetOwnerTextureSignature =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the signature of the player texture of the mob head",
			},
			GetOwnerUUID =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the player UUID of the mob head",
			},
			GetRotation =
			{
				Returns =
				{
					{
						Type = "eMobHeadRotation",
					},
				},
				Notes = "Returns the rotation of the mob head",
			},
			GetType =
			{
				Returns =
				{
					{
						Type = "eMobHeadType",
					},
				},
				Notes = "Returns the type of the mob head",
			},
			SetOwner =
			{
				{
					Params =
					{
						{
							Name = "cPlayer",
							Type = "cPlayer",
						},
					},
					Notes = "Set the {{cPlayer|player}} for mob heads with player type",
				},
				{
					Params =
					{
						{
							Name = "OwnerUUID",
							Type = "string",
						},
						{
							Name = "OwnerName",
							Type = "string",
						},
						{
							Name = "OwnerTexture",
							Type = "string",
						},
						{
							Name = "OwnerTextureSignature",
							Type = "string",
						},
					},
					Notes = "Sets the player components for the mob heads with player type",
				},
			},
			SetRotation =
			{
				Params =
				{
					{
						Name = "Rotation",
						Type = "eMobHeadRotation",
					},
				},
				Notes = "Sets the rotation of the mob head.",
			},
			SetType =
			{
				Params =
				{
					{
						Name = "HeadType",
						Type = "eMobHeadType",
					},
				},
				Notes = "Set the type of the mob head",
			},
		},
		Inherits = "cBlockEntity",
	},
	cMobSpawnerEntity =
	{
		Desc = [[
			This class represents a mob spawner block entity in the world.
		]],
		Functions =
		{
			GetEntity =
			{
				Returns =
				{
					{
						Name = "MobType",
						Type = "Globals#MobType",
					},
				},
				Notes = "Returns the entity type that will be spawn by this mob spawner.",
			},
			GetNearbyMonsterNum =
			{
				Params =
				{
					{
						Name = "MobType",
						Type = "eMonsterType",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the amount of this monster type in a 8-block radius (Y: 4-block radius).",
			},
			GetNearbyPlayersNum =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the amount of the nearby players in a 16-block radius.",
			},
			GetSpawnDelay =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the spawn delay. This is the tick delay that is needed to spawn new monsters.",
			},
			ResetTimer =
			{
				Notes = "Sets the spawn delay to a new random value.",
			},
			SetEntity =
			{
				Params =
				{
					{
						Name = "MobType",
						Type = "Globals#MobType",
					},
				},
				Notes = "Sets the type of the mob that will be spawned by this mob spawner.",
			},
			SetSpawnDelay =
			{
				Params =
				{
					{
						Name = "SpawnDelayTicks",
						Type = "number",
					},
				},
				Notes = "Sets the spawn delay.",
			},
			SpawnEntity =
			{
				Notes = "Spawns the entity. This function automaticly change the spawn delay!",
			},
			UpdateActiveState =
			{
				Notes = "Upate the active flag from the mob spawner. This function is called every 5 seconds from the Tick() function.",
			},
		},
		Inherits = "cBlockEntity",
	},
	cNoteEntity =
	{
		Desc = [[
			This class represents a note block entity in the world. It takes care of the note block's pitch,
			and also can play the sound, either when the {{cPlayer|player}} right-clicks it, redstone activates
			it, or upon a plugin's request.</p>
			<p>
			The pitch is stored as an integer between 0 and 24.
		]],
		Functions =
		{
			GetPitch =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the current pitch set for the block",
			},
			IncrementPitch =
			{
				Notes = "Adds 1 to the current pitch. Wraps around to 0 when the pitch cannot go any higher.",
			},
			MakeSound =
			{
				Notes = "Plays the sound for all {{cClientHandle|clients}} near this block.",
			},
			SetPitch =
			{
				Params =
				{
					{
						Name = "Pitch",
						Type = "number",
					},
				},
				Notes = "Sets a new pitch for the block.",
			},
		},
		Inherits = "cBlockEntity",
	},
	cSignEntity =
	{
		Desc = [[
			A sign entity represents a sign in the world. This class is only used when generating chunks, so
			that the plugins may generate signs within new chunks. See the code example in {{cChunkDesc}}.
		]],
		Functions =
		{
			GetLine =
			{
				Params =
				{
					{
						Name = "LineIndex",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the specified line. LineIndex is expected between 0 and 3. Returns empty string and logs to server console when LineIndex is invalid.",
			},
			SetLine =
			{
				Params =
				{
					{
						Name = "LineIndex",
						Type = "number",
					},
					{
						Name = "LineText",
						Type = "string",
					},
				},
				Notes = "Sets the specified line. LineIndex is expected between 0 and 3. Logs to server console when LineIndex is invalid.",
			},
			SetLines =
			{
				Params =
				{
					{
						Name = "Line1",
						Type = "string",
					},
					{
						Name = "Line2",
						Type = "string",
					},
					{
						Name = "Line3",
						Type = "string",
					},
					{
						Name = "Line4",
						Type = "string",
					},
				},
				Notes = "Sets all the sign's lines at once. Note that plugins should prefer to use {{cWorld}}:SetSignLines(), so that they can specify the player on whose behalf the sign is being set.",
			},
		},
		Inherits = "cBlockEntity",
	},
}
