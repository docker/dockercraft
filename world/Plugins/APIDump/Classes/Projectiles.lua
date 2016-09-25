return
{
	cArrowEntity =
	{
		Desc = [[
			Represents the arrow when it is shot from the bow. A subclass of the {{cProjectileEntity}}.
		]],
		Functions =
		{
			CanPickup =
			{
				Params =
				{
					{
						Name = "Player",
						Type = "cPlayer",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the specified player can pick the arrow when it's on the ground",
			},
			GetBlockHit =
			{
				Desc = "Gets the block arrow is in",
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
			},
			GetDamageCoeff =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the damage coefficient stored within the arrow. The damage dealt by this arrow is multiplied by this coeff",
			},
			GetPickupState =
			{
				Returns =
				{
					{
						Type = "cArrowEntity#ePickupState",
					},
				},
				Notes = "Returns the pickup state (one of the psXXX constants, above)",
			},
			IsCritical =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the arrow should deal critical damage. Based on the bow charge when the arrow was shot.",
			},
			SetDamageCoeff =
			{
				Params =
				{
					{
						Name = "DamageCoeff",
						Type = "number",
					},
				},
				Notes = "Sets the damage coefficient. The damage dealt by this arrow is multiplied by this coeff",
			},
			SetIsCritical =
			{
				Params =
				{
					{
						Name = "IsCritical",
						Type = "boolean",
					},
				},
				Notes = "Sets the IsCritical flag on the arrow. Critical arrow deal additional damage",
			},
			SetPickupState =
			{
				Params =
				{
					{
						Name = "PickupState",
						Type = "cArrowEntity#ePickupState",
					},
				},
				Notes = "Sets the pickup state (one of the psXXX constants, above)",
			},
		},
		Constants =
		{
			psInCreative =
			{
				Notes = "The arrow can be picked up only by players in creative gamemode",
			},
			psInSurvivalOrCreative =
			{
				Notes = "The arrow can be picked up by players in survival or creative gamemode",
			},
			psNoPickup =
			{
				Notes = "The arrow cannot be picked up at all",
			},
		},
		ConstantGroups =
		{
			ePickupState =
			{
				Include = "ps.*",
				TextBefore = [[
					The following constants are used to signalize whether the arrow, once it lands, can be picked by
					players:
				]],
			},
		},
		Inherits = "cProjectileEntity",
	},
	cExpBottleEntity =
	{
		Desc = [[
			Represents a thrown ExpBottle. A subclass of the {{cProjectileEntity}}.
		]],
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cFireChargeEntity =
	{
		Desc = [[
			Represents a fire charge that has been shot by a Blaze or a {{cDispenserEntity|Dispenser}}. A subclass
			of the {{cProjectileEntity}}.
		]],
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cFireworkEntity =
	{
		Desc = [[
			Represents a firework rocket.
		]],
		Functions =
		{
			GetItem =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Returns the item that has been used to create the firework rocket. The item's m_FireworkItem member contains all the firework-related data.",
			},
			GetTicksToExplosion =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the number of ticks left until the firework explodes.",
			},
			SetItem =
			{
				Params =
				{
					{
						Name = "FireworkItem",
						Type = "cItem",
					},
				},
				Notes = "Sets a new item to be used for the firework.",
			},
			SetTicksToExplosion =
			{
				Params =
				{
					{
						Name = "NumTicks",
						Type = "number",
					},
				},
				Notes = "Sets the number of ticks left until the firework explodes.",
			},
		},
		Inherits = "cProjectileEntity",
	},
	cGhastFireballEntity =
	{
		Desc = "",
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cProjectileEntity =
	{
		Desc = "Base class for all projectiles, such as arrows and fireballs.",
		Functions =
		{
			GetCreator =
			{
				Returns =
				{
					{
						Type = "cEntity",
					},
				},
				Notes = "Returns the entity who created this projectile. May return nil.",
			},
			GetCreatorName =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the name of the player that created the projectile. Will be empty for non-player creators",
			},
			GetCreatorUniqueID =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the unique ID of the entity who created this projectile, or {{cEntity#INVALID_ID|cEntity.INVALID_ID}} if the projectile wasn't created by an entity.",
			},
			GetMCAClassName =
			{
				Returns =
				{
					{
						Type = "string",
					},
				},
				Notes = "Returns the string that identifies the projectile type (class name) in MCA files",
			},
			GetProjectileKind =
			{
				Returns =
				{
					{
						Type = "cProjectileEntity#eKind",
					},
				},
				Notes = "Returns the kind of this projectile (pkXXX constant)",
			},
			IsInGround =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this projectile has hit the ground.",
			},
		},
		Constants =
		{
			pkArrow =
			{
				Notes = "The projectile is an {{cArrowEntity|arrow}}",
			},
			pkEgg =
			{
				Notes = "The projectile is a {{cThrownEggEntity|thrown egg}}",
			},
			pkEnderPearl =
			{
				Notes = "The projectile is a {{cThrownEnderPearlEntity|thrown enderpearl}}",
			},
			pkExpBottle =
			{
				Notes = "The projectile is a {{cExpBottleEntity|thrown exp bottle}}",
			},
			pkFireCharge =
			{
				Notes = "The projectile is a {{cFireChargeEntity|fire charge}}",
			},
			pkFirework =
			{
				Notes = "The projectile is a (flying) {{cFireworkEntity|firework}}",
			},
			pkFishingFloat =
			{
				Notes = "The projectile is a {{cFloater|fishing float}}",
			},
			pkGhastFireball =
			{
				Notes = "The projectile is a {{cGhastFireballEntity|ghast fireball}}",
			},
			pkSnowball =
			{
				Notes = "The projectile is a {{cThrownSnowballEntity|thrown snowball}}",
			},
			pkSplashPotion =
			{
				Notes = "The projectile is a {{cSplashPotionEntity|thrown splash potion}}",
			},
			pkWitherSkull =
			{
				Notes = "The projectile is a {{cWitherSkullEntity|wither skull}}",
			},
		},
		ConstantGroups =
		{
			eKind =
			{
				Include = "pk.*",
				TextBefore = "The following constants are used to distinguish between the different projectile kinds:",
			},
		},
		Inherits = "cEntity",
	},
	cSplashPotionEntity =
	{
		Desc = [[
			Represents a thrown splash potion.
		]],
		Functions =
		{
			GetEntityEffect =
			{
				Returns =
				{
					{
						Type = "cEntityEffect",
					},
				},
				Notes = "Returns the entity effect in this potion",
			},
			GetEntityEffectType =
			{
				Returns =
				{
					{
						Type = "cEntityEffect",
					},
				},
				Notes = "Returns the effect type of this potion",
			},
			GetItem =
			{
				Returns =
				{
					{
						Type = "cItem",
					},
				},
				Notes = "Gets the potion item that was thrown.",
			},
			GetPotionColor =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the color index of the particles emitted by this potion",
			},
			SetEntityEffect =
			{
				Params =
				{
					{
						Name = "EntityEffect",
						Type = "cEntityEffect",
					},
				},
				Notes = "Sets the entity effect for this potion",
			},
			SetEntityEffectType =
			{
				Params =
				{
					{
						Name = "EntityEffectType",
						Type = "cEntityEffect#eType",
					},
				},
				Notes = "Sets the effect type of this potion",
			},
			SetPotionColor =
			{
				Params =
				{
					{
						Name = "PotionColor",
						Type = "number",
					},
				},
				Notes = "Sets the color index of the particles for this potion",
			},
		},
		Inherits = "cProjectileEntity",
	},
	cThrownEggEntity =
	{
		Desc = [[
			Represents a thrown egg.
		]],
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cThrownEnderPearlEntity =
	{
		Desc = "Represents a thrown ender pearl.",
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cThrownSnowballEntity =
	{
		Desc = "Represents a thrown snowball.",
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
	cWitherSkullEntity =
	{
		Desc = "Represents a wither skull being shot.",
		Functions =
		{

		},
		Inherits = "cProjectileEntity",
	},
}
