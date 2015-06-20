return
{
	cArrowEntity =
	{
		Desc = [[
			Represents the arrow when it is shot from the bow. A subclass of the {{cProjectileEntity}}.
		]],
		Functions =
		{
			CanPickup      = { Params = "{{cPlayer|Player}}", Return = "bool", Notes = "Returns true if the specified player can pick the arrow when it's on the ground" },
			GetDamageCoeff = { Params = "", Return = "number", Notes = "Returns the damage coefficient stored within the arrow. The damage dealt by this arrow is multiplied by this coeff" },
			GetPickupState = { Params = "", Return = "PickupState", Notes = "Returns the pickup state (one of the psXXX constants, above)" },
			IsCritical     = { Params = "", Return = "bool", Notes = "Returns true if the arrow should deal critical damage. Based on the bow charge when the arrow was shot." },
			SetDamageCoeff = { Params = "number", Return = "", Notes = "Sets the damage coefficient. The damage dealt by this arrow is multiplied by this coeff" },
			SetIsCritical  = { Params = "bool", Return = "", Notes = "Sets the IsCritical flag on the arrow. Critical arrow deal additional damage" },
			SetPickupState = { Params = "PickupState", Return = "", Notes = "Sets the pickup state (one of the psXXX constants, above)" },
		},
		Constants =
		{
			psInCreative           = { Notes = "The arrow can be picked up only by players in creative gamemode" },
			psInSurvivalOrCreative = { Notes = "The arrow can be picked up by players in survival or creative gamemode" },
			psNoPickup             = { Notes = "The arrow cannot be picked up at all" },
		},
		ConstantGroups =
		{
			PickupState =
			{
				Include = "ps.*",
				TextBefore = [[
					The following constants are used to signalize whether the arrow, once it lands, can be picked by
					players:
				]],
			},
		},
		Inherits = "cProjectileEntity",
	},  -- cArrowEntity

	cExpBottleEntity =
	{
		Desc = [[
			Represents a thrown ExpBottle. A subclass of the {{cProjectileEntity}}.
		]],
		Functions =
		{
		},
		Inherits = "cProjectileEntity",
	},  -- cExpBottleEntity

	cFireChargeEntity =
	{
		Desc = [[
			Represents a fire charge that has been shot by a Blaze or a {{cDispenserEntity|Dispenser}}. A subclass
			of the {{cProjectileEntity}}.
		]],
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cFireChargeEntity
	
	cFireworkEntity =
	{
		Desc = [[
			Represents a firework rocket.
		]],
			Functions =
			{
				GetItem = { Params = "", Return = "{{cItem}}", Notes = "Returns the item that has been used to create the firework rocket. The item's m_FireworkItem member contains all the firework-related data." },
				GetTicksToExplosion = { Params = "", Return = "number", Notes = "Returns the number of ticks left until the firework explodes." },
				SetItem = { Params = "{{cItem}}", Return = "", Notes = "Sets a new item to be used for the firework." },
				SetTicksToExplosion = { Params = "NumTicks", Return = "", Notes = "Sets the number of ticks left until the firework explodes." },
			},

		Inherits = "cProjectileEntity",
	},  -- cFireworkEntity

	cFloater =
	{
		Desc = "",
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cFloater

	cGhastFireballEntity =
	{
		Desc = "",
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cGhastFireballEntity

	cProjectileEntity =
	{
		Desc = "",
		Functions =
		{
			GetCreator = { Params = "", Return = "{{cEntity}} descendant", Notes = "Returns the entity who created this projectile. May return nil." },
			GetMCAClassName = { Params = "", Return = "string", Notes = "Returns the string that identifies the projectile type  (class name) in MCA files" },
			GetProjectileKind = { Params = "", Return = "ProjectileKind", Notes = "Returns the kind of this projectile (pkXXX constant)" },
			IsInGround = { Params = "", Return = "bool", Notes = "Returns true if this projectile has hit the ground." },
		},
		Constants =
		{
			pkArrow = { Notes = "The projectile is an {{cArrowEntity|arrow}}" },
			pkEgg = { Notes = "The projectile is a {{cThrownEggEntity|thrown egg}}" },
			pkEnderPearl = { Notes = "The projectile is a {{cThrownEnderPearlEntity|thrown enderpearl}}" },
			pkExpBottle = { Notes = "The projectile is a {{cExpBottleEntity|thrown exp bottle}}" },
			pkFireCharge = { Notes = "The projectile is a {{cFireChargeEntity|fire charge}}" },
			pkFirework = { Notes = "The projectile is a (flying) {{cFireworkEntity|firework}}" },
			pkFishingFloat = { Notes = "The projectile is a {{cFloater|fishing float}}" },
			pkGhastFireball = { Notes = "The projectile is a {{cGhastFireballEntity|ghast fireball}}" },
			pkSnowball = { Notes = "The projectile is a {{cThrownSnowballEntity|thrown snowball}}" },
			pkSplashPotion = { Notes = "The projectile is a {{cSplashPotionEntity|thrown splash potion}}" },
			pkWitherSkull = { Notes = "The projectile is a {{cWitherSkullEntity|wither skull}}" },
		},
		ConstantGroups =
		{
			ProjectileKind =
			{
				Include = "pk.*",
				TextBefore = "The following constants are used to distinguish between the different projectile kinds:",
			},
		},
		Inherits = "cEntity",
	},  -- cProjectileEntity

	cSplashPotionEntity =
	{
		Desc = [[
			Represents a thrown splash potion.
		]],
			Functions =
			{
				GetEntityEffect = { Params = "", Return = "{{cEntityEffect}}", Notes = "Returns the entity effect in this potion" },
				GetEntityEffectType = { Params = "", Return = "{{cEntityEffect|Entity effect type}}", Notes = "Returns the effect type of this potion" },
				GetPotionColor = { Params = "", Return = "number", Notes = "Returns the color index of the particles emitted by this potion" },
				SetEntityEffect = { Params = "{{cEntityEffect}}", Return = "", Notes = "Sets the entity effect for this potion" },
				SetEntityEffectType = { Params = "{{cEntityEffect|Entity effect type}}", Return = "", Notes = "Sets the effect type of this potion" },
				SetPotionColor = { Params = "number", Return = "", Notes = "Sets the color index of the particles for this potion" },
			},
		Inherits = "cProjectileEntity",
	},  -- cSplashPotionEntity

	cThrownEggEntity =
	{
		Desc = [[
			Represents a thrown egg.
		]],
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cThrownEggEntity

	cThrownEnderPearlEntity =
	{
		Desc = "Represents a thrown ender pearl.",
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cThrownEnderPearlEntity
	
	cThrownSnowballEntity =
	{
		Desc = "Represents a thrown snowball.",
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cThrownSnowballEntity

	cWitherSkullEntity =
	{
		Desc = "Represents a wither skull being shot.",
		Functions = {},
		Inherits = "cProjectileEntity",
	},  -- cWitherSkullEntity
}




