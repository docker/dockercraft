
-- Config.lua

-- Implements the cConfig class that holds the general plugin configuration





cConfig = {
	m_Wand = cItem(E_ITEM_STICK, 1, 1);  -- The item to be used as the selection wand
	m_AllowInteractNoArea = true;  -- If there's no area, is a player allowed to build / dig?
};





--- Initializes the cConfig object, loads the configuration from an INI file
function InitializeConfig()
	local ini = cIniFile();
	if (not(ini:ReadFile("ProtectionAreas.ini"))) then
		LOGINFO(PluginPrefix .. "Cannot read ProtectionAreas.ini, all plugin configuration is set to defaults");
	end
	local WandItem = cItem();
	if (
		StringToItem(ini:GetValueSet("ProtectionAreas", "WandItem", ItemToString(cConfig.m_Wand)), WandItem) and
		IsValidItem(WandItem.m_ItemType)
	) then
		cConfig.m_Wand = WandItem;
	end
	cConfig.m_AllowInteractNoArea = ini:GetValueSetB("ProtectionAreas", "AllowInteractNoArea", cConfig.m_AllowInteractNoArea);
	ini:WriteFile("ProtectionAreas.ini");
end





--- Returns true if a_Item is the wand tool item
function cConfig:IsWand(a_Item)
	return (
		(a_Item.m_ItemType   == self.m_Wand.m_ItemType) and
		(a_Item.m_ItemDamage == self.m_Wand.m_ItemDamage)
	);
end





--- Returns the wand tool item as a cItem object
function cConfig:GetWandItem()
	return self.m_Wand;
end