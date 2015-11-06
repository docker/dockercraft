-- enchant.lua


-- Handles enchant console and in-game commands


-- Table containing the properties of the various possible enchantments
local EnchantmentInformation = {

	[ cEnchantments.enchProtection ] = {
		Name = "Protection",
		MaxLevel = 4,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
		},
		CannotCombineWith = {
			cEnchantments.enchFireProtection,
			cEnchantments.enchBlastProtection,
			cEnchantments.enchProjectileProtection,
		},
	},

	[ cEnchantments.enchFireProtection ] = {
		Name = "Fire Protection",
		MaxLevel = 4,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
		},
		CannotCombineWith = {
			cEnchantments.enchProtection,
			cEnchantments.enchBlastProtection,
			cEnchantments.enchProjectileProtection,
		},
	},

	[ cEnchantments.enchFeatherFalling ] = {
		Name = "Feather Falling",
		MaxLevel = 4,
		ApplicableItems = {
			[ E_ITEM_LEATHER_BOOTS ] = true,
			[ E_ITEM_IRON_BOOTS ]    = true,
			[ E_ITEM_CHAIN_BOOTS ]   = true,
			[ E_ITEM_GOLD_BOOTS ]    = true,
			[ E_ITEM_DIAMOND_BOOTS ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchBlastProtection ] = {
		Name = "Blast Protection",
		MaxLevel = 4,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
		},
		CannotCombineWith = {
			cEnchantments.enchFireProtection,
			cEnchantments.enchProtection,
			cEnchantments.enchProjectileProtection,
		},
	},

	[ cEnchantments.enchProjectileProtection ] = {
		Name = "Projectile Protection",
		MaxLevel = 4,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
		},
		CannotCombineWith = {
			cEnchantments.enchFireProtection,
			cEnchantments.enchBlastProtection,
			cEnchantments.enchProtection,
		},
	},

	[ cEnchantments.enchRespiration ] = {
		Name = "Respiration",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]    = true,
			[ E_ITEM_IRON_HELMET ]    = true,
			[ E_ITEM_CHAIN_HELMET ]   = true,
			[ E_ITEM_GOLD_HELMET ]    = true,
			[ E_ITEM_DIAMOND_HELMET ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchAquaAffinity ] = {
		Name = "Aqua Affinity",
		MaxLevel = 1,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]    = true,
			[ E_ITEM_IRON_HELMET ]    = true,
			[ E_ITEM_CHAIN_HELMET ]   = true,
			[ E_ITEM_GOLD_HELMET ]    = true,
			[ E_ITEM_DIAMOND_HELMET ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchThorns ] = {
		Name = "Thorns",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchDepthStrider ] = {
			Name = "Depth Strider",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_LEATHER_BOOTS ] = true,
			[ E_ITEM_IRON_BOOTS ]    = true,
			[ E_ITEM_CHAIN_BOOTS ]   = true,
			[ E_ITEM_GOLD_BOOTS ]    = true,
			[ E_ITEM_DIAMOND_BOOTS ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchSharpness ] = {
		Name = "Sharpness",
		MaxLevel = 5,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
			[ E_ITEM_WOODEN_AXE ]    = true,
			[ E_ITEM_STONE_AXE ]     = true,
			[ E_ITEM_IRON_AXE ]      = true,
			[ E_ITEM_GOLD_AXE ]      = true,
			[ E_ITEM_DIAMOND_AXE ]   = true,
		},
		CannotCombineWith = {
			cEnchantments.enchSmite,
			cEnchantments.enchBaneOfArthropods,
		},
	},

	[ cEnchantments.enchSmite ] = {
		Name = "Smite",
		MaxLevel = 5,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
			[ E_ITEM_WOODEN_AXE ]    = true,
			[ E_ITEM_STONE_AXE ]     = true,
			[ E_ITEM_IRON_AXE ]      = true,
			[ E_ITEM_GOLD_AXE ]      = true,
			[ E_ITEM_DIAMOND_AXE ]   = true,
		},
		CannotCombineWith = {
			cEnchantments.enchSharpness,
			cEnchantments.enchBaneOfArthropods,
		},
	},

	[ cEnchantments.enchBaneOfArthropods ] = {
		Name = "Bane of Arthropods",
		MaxLevel = 5,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
			[ E_ITEM_WOODEN_AXE ]    = true,
			[ E_ITEM_STONE_AXE ]     = true,
			[ E_ITEM_IRON_AXE ]      = true,
			[ E_ITEM_GOLD_AXE ]      = true,
			[ E_ITEM_DIAMOND_AXE ]   = true,
		},
		CannotCombineWith = {
			cEnchantments.enchSharpness,
			cEnchantments.enchSmite,
		},
	},

	[ cEnchantments.enchKnockback ] = {
		Name = "Knockback",
		MaxLevel = 2,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchFireAspect ] = {
		Name = "Fire Aspect",
		MaxLevel = 2,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchLooting ] = {
		Name = "Looting",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchEfficiency ] = {
		Name = "Efficiency",
		MaxLevel = 5,
		ApplicableItems = {
			[ E_ITEM_WOODEN_PICKAXE ]  = true,
			[ E_ITEM_STONE_PICKAXE ]   = true,
			[ E_ITEM_IRON_PICKAXE ]    = true,
			[ E_ITEM_GOLD_PICKAXE ]    = true,
			[ E_ITEM_DIAMOND_PICKAXE ] = true,
			[ E_ITEM_WOODEN_SHOVEL ]   = true,
			[ E_ITEM_STONE_SHOVEL ]    = true,
			[ E_ITEM_IRON_SHOVEL ]     = true,
			[ E_ITEM_GOLD_SHOVEL ]     = true,
			[ E_ITEM_DIAMOND_SHOVEL ]  = true,
			[ E_ITEM_WOODEN_AXE ]      = true,
			[ E_ITEM_STONE_AXE ]       = true,
			[ E_ITEM_IRON_AXE ]        = true,
			[ E_ITEM_GOLD_AXE ]        = true,
			[ E_ITEM_DIAMOND_AXE ]     = true,
			[ E_ITEM_SHEARS ]          = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchSilkTouch ] = {
		Name = "Silk Touch",
		MaxLevel = 1,
		ApplicableItems = {
			[ E_ITEM_WOODEN_PICKAXE ]  = true,
			[ E_ITEM_STONE_PICKAXE ]   = true,
			[ E_ITEM_IRON_PICKAXE ]    = true,
			[ E_ITEM_GOLD_PICKAXE ]    = true,
			[ E_ITEM_DIAMOND_PICKAXE ] = true,
			[ E_ITEM_WOODEN_SHOVEL ]   = true,
			[ E_ITEM_STONE_SHOVEL ]    = true,
			[ E_ITEM_IRON_SHOVEL ]     = true,
			[ E_ITEM_GOLD_SHOVEL ]     = true,
			[ E_ITEM_DIAMOND_SHOVEL ]  = true,
			[ E_ITEM_WOODEN_AXE ]      = true,
			[ E_ITEM_STONE_AXE ]       = true,
			[ E_ITEM_IRON_AXE ]        = true,
			[ E_ITEM_GOLD_AXE ]        = true,
			[ E_ITEM_DIAMOND_AXE ]     = true,
			[ E_ITEM_SHEARS ]          = true,
		},
		CannotCombineWith = {
			cEnchantments.enchFortune,
		},
	},

	[ cEnchantments.enchUnbreaking ] = {
		Name = "Unbreaking",
		MaxLevel = 3,
		ApplicableItems = {
			-- Tools
			[ E_ITEM_WOODEN_PICKAXE ]  = true,
			[ E_ITEM_STONE_PICKAXE ]   = true,
			[ E_ITEM_IRON_PICKAXE ]    = true,
			[ E_ITEM_GOLD_PICKAXE ]    = true,
			[ E_ITEM_DIAMOND_PICKAXE ] = true,
			[ E_ITEM_WOODEN_SHOVEL ]   = true,
			[ E_ITEM_STONE_SHOVEL ]    = true,
			[ E_ITEM_IRON_SHOVEL ]     = true,
			[ E_ITEM_GOLD_SHOVEL ]     = true,
			[ E_ITEM_DIAMOND_SHOVEL ]  = true,
			[ E_ITEM_WOODEN_AXE ]      = true,
			[ E_ITEM_STONE_AXE ]       = true,
			[ E_ITEM_IRON_AXE ]        = true,
			[ E_ITEM_GOLD_AXE ]        = true,
			[ E_ITEM_DIAMOND_AXE ]     = true,
			[ E_ITEM_FISHING_ROD ]     = true,
			
			-- Armor
			[ E_ITEM_LEATHER_CAP ]        = true,
			[ E_ITEM_IRON_HELMET ]        = true,
			[ E_ITEM_CHAIN_HELMET ]       = true,
			[ E_ITEM_GOLD_HELMET ]        = true,
			[ E_ITEM_DIAMOND_HELMET ]     = true,
			[ E_ITEM_LEATHER_TUNIC ]      = true,
			[ E_ITEM_IRON_CHESTPLATE ]    = true,
			[ E_ITEM_CHAIN_CHESTPLATE ]   = true,
			[ E_ITEM_GOLD_CHESTPLATE ]    = true,
			[ E_ITEM_DIAMOND_CHESTPLATE ] = true,
			[ E_ITEM_LEATHER_PANTS ]      = true,
			[ E_ITEM_IRON_LEGGINGS ]      = true,
			[ E_ITEM_CHAIN_LEGGINGS ]     = true,
			[ E_ITEM_GOLD_LEGGINGS ]      = true,
			[ E_ITEM_DIAMOND_LEGGINGS ]   = true,
			[ E_ITEM_LEATHER_BOOTS ]      = true,
			[ E_ITEM_IRON_BOOTS ]         = true,
			[ E_ITEM_CHAIN_BOOTS ]        = true,
			[ E_ITEM_GOLD_BOOTS ]         = true,
			[ E_ITEM_DIAMOND_BOOTS ]      = true,
			
			-- Weapons
			[ E_ITEM_WOODEN_SWORD ]  = true,
			[ E_ITEM_STONE_SWORD ]   = true,
			[ E_ITEM_IRON_SWORD ]    = true,
			[ E_ITEM_GOLD_SWORD ]    = true,
			[ E_ITEM_DIAMOND_SWORD ] = true,
			[ E_ITEM_BOW ]           = true,
			
			-- Secondary Items
			[ E_ITEM_WOODEN_HOE ]      = true,
			[ E_ITEM_STONE_HOE ]       = true,
			[ E_ITEM_IRON_HOE ]        = true,
			[ E_ITEM_GOLD_HOE ]        = true,
			[ E_ITEM_DIAMOND_HOE ]     = true,
			[ E_ITEM_SHEARS ]          = true,
			[ E_ITEM_FLINT_AND_STEEL ] = true,
			[ E_ITEM_CARROT_ON_STICK ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchFortune ] = {
		Name = "Fortune",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_WOODEN_PICKAXE ]  = true,
			[ E_ITEM_STONE_PICKAXE ]   = true,
			[ E_ITEM_IRON_PICKAXE ]    = true,
			[ E_ITEM_GOLD_PICKAXE ]    = true,
			[ E_ITEM_DIAMOND_PICKAXE ] = true,
			[ E_ITEM_WOODEN_SHOVEL ]   = true,
			[ E_ITEM_STONE_SHOVEL ]    = true,
			[ E_ITEM_IRON_SHOVEL ]     = true,
			[ E_ITEM_GOLD_SHOVEL ]     = true,
			[ E_ITEM_DIAMOND_SHOVEL ]  = true,
			[ E_ITEM_WOODEN_AXE ]      = true,
			[ E_ITEM_STONE_AXE ]       = true,
			[ E_ITEM_IRON_AXE ]        = true,
			[ E_ITEM_GOLD_AXE ]        = true,
			[ E_ITEM_DIAMOND_AXE ]     = true,
		},
		CannotCombineWith = {
			cEnchantments.enchSilkTouch
		},
	},

	[ cEnchantments.enchPower ] = {
		Name = "Power",
		MaxLevel = 5,
		ApplicableItems = {
			[ E_ITEM_BOW ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchPunch ] = {
		Name = "Punch",
		MaxLevel = 2,
		ApplicableItems = {
			[ E_ITEM_BOW ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchFlame ] = {
		Name = "Flame",
		MaxLevel = 1,
		ApplicableItems = {
			[ E_ITEM_BOW ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchInfinity ] = {
		Name = "Infinity",
		MaxLevel = 1,
		ApplicableItems = {
			[ E_ITEM_BOW ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchLuckOfTheSea ] = {
		Name = "Luck of the Sea",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_FISHING_ROD ] = true,
		},
		CannotCombineWith = {
		},
	},

	[ cEnchantments.enchLure ] = {
		Name = "Lure",
		MaxLevel = 3,
		ApplicableItems = {
			[ E_ITEM_FISHING_ROD ] = true,
		},
		CannotCombineWith = {
		},
	},

}


local EnchantCommandUsage = "Usage: %s <player> <enchantment ID> [level]"
local IEnchantCommandUsage = "Usage: %s <enchantment ID> [level]"
local UnknownEnchantment = "There is no known enchantment %s"
local LevelNAN = "%s is not a number, level must be a number"
local LevelIsZero = "Level must be greater than 0"
local LevelTooHigh = "The level you have entered: %d is too high, it must be at most: %d"
local ItemNotEnchantable = "The enchantment %s cannot be used with the selected item"
local IncompatableEnchantments = "%s cannot be combined with %s"
local NoItemPresent = "The player %s doesn't have an item selected"
local ConsoleMessage = "%s: %s"
local MessagePlayerFailure = "Player %s not found"
local MismatchedItemsError = "Player's currently selected item (%s) no longer matches previously selected item (%s)"
local MessageSuccess = "Enchantment Successful"
local LogMessageSuccess = "Applied the enchantment %s to a %s held by player %s"


--- Converts the given enchantment ID to a string
--  
--  @param EnchantmentID The Enchantment ID to convert to a string
--  @param Level the level of the enchantment
--  
--  @return A string in the format of <EnchantmentName> <Level> or,
--  @return if the name is not known, ID: <EnchantmentID> <Level>
--  
local function EnchantmentIDToString( EnchantmentID, Level )

	local EnchantmentName

	if EnchantmentInformation[EnchantmentID] then
		EnchantmentName = EnchantmentInformation[EnchantmentID].Name
	else
		EnchantmentName = "ID: " .. tostring( EnchantmentID )
	end

	return string.format( "%s %d", EnchantmentName, Level )
end


--- Processes the Enchant command, checks the given options, 
--  and enchants the selected players item if successful
--  
--  @return False with an error message if a probem occurs, 
--  @return true with the name of the item enchanted and the enchantment name if successful
--  
local function EnchantItem( Split )

	local PlayerName = Split[2]
	local lcPlayerName = string.lower(PlayerName)
	local EnchantmentID = cEnchantments:StringToEnchantmentID( Split[3] )
	local EnchantmentName
	local Level = tonumber( Split[4] or 1 )

	if not Level then
		return false, string.format( LevelNAN, Split[4] )
	elseif Level == 0 then
		return false, LevelIsZero
	end

	-- Check if the enchantment was given as a string, and the string contained an unknown value
	if EnchantmentID == -1 then
		return false, string.format( UnknownEnchantment, Split[3] )
	end

	EnchantmentName = EnchantmentIDToString( EnchantmentID, Level )

	-- If the enchantment is not known, stop
	if not EnchantmentInformation[ EnchantmentID ] then
		return false, string.format( UnknownEnchantment, EnchantmentName )
	end

	-- Place to hold any messages generated by the DoEnchantment function
	local ReturnMessage

	--- Attempt to apply the selected enchantment to the targeted player's item
	--  
	--  @param NewPlayer The player targeted by the command
	--  
	--  @return true if successful, false otherwise
	--  
	local function DoEnchantment( NewPlayer )

		-- Make sure that the names match
		if string.lower( NewPlayer:GetName() ) ~= lcPlayerName then
			return false
		end

		-- Make sure that the targeted player has an item selected
		local Item = NewPlayer:GetEquippedItem()
		if Item:IsEmpty() then
			ReturnMessage = string.format( NoItemPresent, PlayerName )
			return false
		end

		local ItemEnchantments = Item.m_Enchantments
		local ItemType = Item.m_ItemType

		-- First, make sure that the item is enchantable
		if not cItem:IsEnchantable( ItemType, true ) then
			ReturnMessage = string.format( ItemNotEnchantable, EnchantmentName )
			return false
		end

		local EnchantInfo = EnchantmentInformation[ EnchantmentID ]

		-- The selected item is not enchantable using the selected enchantment
		if not EnchantInfo.ApplicableItems[ ItemType ] then
			ReturnMessage = string.format( ItemNotEnchantable, EnchantmentName )
			return false
		end

		-- If the chosen level is greater then the max enchant level, return false
		local MaxLvl = EnchantInfo.MaxLevel
		if Level > MaxLvl then
			ReturnMessage = string.format( LevelTooHigh, Level, MaxLvl)
			return false
		end

		-- Check if the selected item carries an incompatible enchantment
		for _, IncoEnch in ipairs( EnchantInfo.CannotCombineWith ) do
			local IncoEnchLvl = ItemEnchantments:GetLevel( IncoEnch )
			if IncoEnchLvl ~= 0 then
				ReturnMessage = string.format( IncompatableEnchantments, EnchantmentName, EnchantmentIDToString( IncoEnch, IncoEnchLvl ) )
				return false
			end
		end

		-- Now, actually enchant the item
		ItemEnchantments:SetLevel( EnchantmentID, Level )
		local Inventory = NewPlayer:GetInventory()
		local SlotNumber = Inventory:GetEquippedSlotNum()
		local CurrentSelItem = Inventory:GetHotbarSlot( SlotNumber )

		-- Make sure that the item we give back is the same item is selected
		if not CurrentSelItem:IsSameType( Item ) then
			ReturnMessage = string.format( MismatchedItemsError, ItemToString( CurrentSelItem ), ItemToString( Item ) )
			return false
		end

		ReturnMessage = ItemToString( Item )
		Inventory:SetHotbarSlot( SlotNumber, Item )

		return true
	end

	-- Try to enchant the item
	local Success = cRoot:Get():FindAndDoWithPlayer( PlayerName, DoEnchantment )

	if not Success and not ReturnMessage then
		ReturnMessage = string.format( MessagePlayerFailure, PlayerName )
	end

	return Success, ReturnMessage, EnchantmentName
end


--- Handles the enchant in-game command
--  Usage: /enchant <player> <enchantment ID> [level]
function HandleEnchantCommand( Split, Player )

	if not Split[3] then
		SendMessage( Player, string.format( EnchantCommandUsage, Split[1] ) )
		return true
	end

	local Result, ReturnMessage, Enchantment = EnchantItem( Split )

	if not Result then
		SendMessage( Player, ReturnMessage )
	else
		SendMessage( Player, MessageSuccess )
		local MsgString = string.format( LogMessageSuccess, Enchantment, ReturnMessage, Split[2] )
		LOG( string.format( ConsoleMessage, Player:GetName(), MsgString ) )
	end

	return true
end


--- Handles the ienchant in-game command
--  Usage: /ienchant <enchantment ID> [level]
function HandleIEnchantCommand( Split, Player )

	if not Split[2] then
		SendMessage( Player, string.format( IEnchantCommandUsage, Split[1] ) )
		return true
	end

	table.insert( Split, 2, Player:GetName() )

	local Result, ReturnMessage, Enchantment = EnchantItem( Split )

	if not Result then
		SendMessage( Player, ReturnMessage )
	else
		SendMessage( Player, MessageSuccess )
		local MsgString = string.format( LogMessageSuccess, Enchantment, ReturnMessage, Split[2] )
		LOG( string.format( ConsoleMessage, Player:GetName(), MsgString ) )
	end

	return true
end


--- Handles the enchant console command
--  Usage: enchant <player> <enchantment ID> [level]
function HandleConsoleEnchant( Split )

	if not Split[3] then
		LOG( string.format( EnchantCommandUsage, Split[1] ) )
		return true
	end

	local Result, ReturnMessage, Enchantment = EnchantItem( Split )

	if not Result then
		LOG( ReturnMessage )
	else
		local MsgString = string.format( LogMessageSuccess, Enchantment, ReturnMessage, Split[2] )
		LOG( string.format( ConsoleMessage, "Console", MsgString ) )
	end

	return true
end
