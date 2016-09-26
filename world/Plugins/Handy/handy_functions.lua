--[[
General stuff
]]
-- Returns Handy plugin version number
function GetHandyVersion()
	return HANDY_VERSION
end
-- Checks if handy is in proper version
function CheckForRequiredVersion( inVersion )
	if( inVersion > HANDY_VERSION ) then		return false	end
	return true
end
--[[
MCS-specific _functions and nasty hacks :D
]]
function GetChestHeightCheat( inChest )
	local chestGrid = inChest:GetContents()
	LOGINFO( "This function serves no purpose now! You should consider chest:GetContents():GetHeight() now!" )
	LOGINFO( "Also, you might find Handy's new 'IsChestDouble()' useful for your case" )
	return chestGrid:GetHeight()
end
function IsChestDouble( inChest )
	local chestHeight = inChest:GetContents():GetHeight()
	if( chestHeight == 3 ) then
		return false
	end
	return true
end
-- Those two checks how many items of given inItemID chest and player have, and how much they could fit inside them
function ReadChestForItem( inChest, inItemID )
	return ReadGridForItems( inChest:GetContents(), inItemID )
end
function ReadPlayerForItem( inPlayer, inItemID )
	local inventoryFound, inventoryFree = ReadGridForItems( inPlayer:GetInventory():GetInventoryGrid(), inItemID )
	local hotbarFound, hotbarFree = ReadGridForItems( inPlayer:GetInventory():GetHotbarGrid(), inItemID )
	local itemsFound = inventoryFound + hotbarFound
	local freeSpace = inventoryFree + hotbarFree
	return itemsFound, freeSpace
end
-- Following functions are for chest-related operations
-- BEWARE! Those assume you did checked if chest has items/space in it!
function ReadGridForItems( inGrid, inItemID )
	local itemsFound = 0
	local freeSpace = 0
	local slotsCount = inGrid:GetNumSlots()
	local testerItem = cItem( inItemID )
	local maxStackSize = testerItem:GetMaxStackSize()
	for index = 0, (slotsCount - 1) do
		slotItem = inGrid:GetSlot( index )
		if( slotItem:IsEmpty() ) then
			freeSpace = freeSpace + maxStackSize
		else
			if( slotItem:IsStackableWith( testerItem ) ) then
				itemsFound = itemsFound + slotItem.m_ItemCount
				freeSpace = maxStackSize - slotItem.m_ItemCount
			end
		end
	end
	return itemsFound, freeSpace
end

function TakeItemsFromGrid( inGrid, inItem )
	local slotsCount = inGrid:GetNumSlots()
	local removedItem = cItem( inItem )
	for index = 0, (slotsCount - 1) do
		slotItem = inGrid:GetSlot( index )
		if( slotItem:IsSameType( removedItem ) ) then
			if( slotItem.m_ItemCount <= removedItem.m_ItemCount ) then
				removedItem.m_ItemCount = removedItem.m_ItemCount - slotItem.m_ItemCount
				inGrid:EmptySlot( index )
			else
				removedItem.m_ItemCount = slotItem.m_ItemCount - removedItem.m_ItemCount
				inGrid:SetSlot( index, removedItem )
				removedItem.m_ItemCount = 0
			end
			if( removedItem.m_ItemCount <= 0 ) then		break	end
		end
	end
	return removedItem.m_ItemCount
end
--------------
function TakeItemsFromChest( inChest, inItemID, inAmount )	-- MIGHT BE UNSAFE! CHECK FOR ITEMS FIRST!!
	local chestGrid = inChest:GetContents()
	local removedItem = cItem( inItemID, inAmount )
	TakeItemsFromGrid( chestGrid, removedItem )
end
function PutItemsToChest( inChest, inItemID, inAmount )
	local chestGrid = inChest:GetContents()
	local addedItem = cItem( inItemID, inAmount )
	chestGrid:AddItem( addedItem )
end
-- Similar to chest-related.
function TakeItemsFromPlayer( inPlayer, inItemID, inAmount )	-- MIGHT BE UNSAFE! CHECK FIRST!
	local removedItem = cItem( inItemID, inAmount )
	local inventoryGrid = inPlayer:GetInventory():GetInventoryGrid()
	local hotbarGrid = inPlayer:GetInventory():GetHotbarGrid()
	local itemsLeft = TakeItemsFromGrid( inventoryGrid, removedItem )
	if( itemsLeft > 0 ) then
		removedItem = cItem( inItemID, itemsLeft )
		TakeItemsFromGrid( hotbarGrid, removedItem )
	end
end
function GiveItemsToPlayer( inPlayer, inItemID, inAmount )
	local addedItem = cItem( inItemID, inAmount )
	local inventoryGrid = inPlayer:GetInventory():GetInventoryGrid()
	local hotbarGrid = inPlayer:GetInventory():GetHotbarGrid()
	local itemsAdded = inventoryGrid:AddItem( addedItem )
	if( itemsAdded < inAmount ) then
		addedItem.m_ItemCount = addedItem.m_ItemCount - itemsAdded
		hotbarGrid:AddItem( addedItem )
	end
end
-- This function returns item max stack for a given itemID. It uses vanilla max stack size, and uses several non-common items notations;
-- Those are:
-- oneonerecord( because aparently 11record wasn't the best idea in lua scripting application )
-- carrotonastick( because it wasn't added to items.txt yet )
-- waitrecord( for same reason )
-- Feel free to ignore the difference, or to add those to items.txt
function GetItemMaxStack( inItemID )
	local testerItem = cItem( inItemID )
	LOGINFO( "This function serves no real purpose now, maybe consider using cItem:GetMaxStackSize()?" )
	return testerItem:GetMaxStackSize()
end
function ItemIsArmor( inItemID, inCheckForHorseArmor )
	inCheckForHorseArmor = inCheckForHorseArmor or false
	if( inItemID == E_ITEM_LEATHER_CAP )		then	return true		end
	if( inItemID == E_ITEM_LEATHER_TUNIC )		then	return true		end
	if( inItemID == E_ITEM_LEATHER_PANTS )		then	return true		end
	if( inItemID == E_ITEM_LEATHER_BOOTS )		then	return true		end
	
	if( inItemID == E_ITEM_CHAIN_HELMET )		then	return true		end
	if( inItemID == E_ITEM_CHAIN_CHESTPLATE )	then	return true		end
	if( inItemID == E_ITEM_CHAIN_LEGGINGS )		then	return true		end
	if( inItemID == E_ITEM_CHAIN_BOOTS )		then	return true		end
	
	if( inItemID == E_ITEM_IRON_HELMET )		then	return true		end
	if( inItemID == E_ITEM_IRON_CHESTPLATE )	then	return true		end
	if( inItemID == E_ITEM_IRON_LEGGINGS )		then	return true		end
	if( inItemID == E_ITEM_IRON_BOOTS )			then	return true		end
	
	if( inItemID == E_ITEM_DIAMOND_HELMET )		then	return true		end
	if( inItemID == E_ITEM_DIAMOND_CHESTPLATE )	then	return true		end
	if( inItemID == E_ITEM_DIAMOND_LEGGINGS )	then	return true		end
	if( inItemID == E_ITEM_DIAMOND_BOOTS )		then	return true		end
	
	if( inItemID == E_ITEM_GOLD_HELMET )		then	return true		end
	if( inItemID == E_ITEM_GOLD_CHESTPLATE )	then	return true		end
	if( inItemID == E_ITEM_GOLD_LEGGINGS )		then	return true		end
	if( inItemID == E_ITEM_GOLD_BOOTS )			then	return true		end
	
	if( inCheckForHorseArmor ) then
		if( inItemID == E_ITEM_IRON_HORSE_ARMOR )		then	return true		end
		if( inItemID == E_ITEM_GOLD_HORSE_ARMOR )		then	return true		end
		if( inItemID == E_ITEM_DIAMOND_HORSE_ARMOR )	then	return true		end
	end
	return false
end
-- Returns full-length playername for a short name( usefull for parsing commands )
function GetExactPlayername( inPlayerName )
	local _result = inPlayerName
	local function SetProcessingPlayername( inPlayer )
		_result = inPlayer:GetName()
	end
	cRoot:Get():FindAndDoWithPlayer( inPlayerName, SetProcessingPlayername )
	return _result
end
function GetPlayerByName( inPlayerName )
	local _player
	local PlayerSetter = function( Player )
		_player = Player
	end
	cRoot:Get():FindAndDoWithPlayer( inPlayerName, PlayerSetter )
	return _player
end
--[[
Not-so-usual math _functions
]]
-- Rounds floating point number. Because lua guys think this function doesn't deserve to be presented in lua's math
function round( inX )
  if( inX%2 ~= 0.5 ) then
    return math.floor( inX + 0.5 )
  end
  return inX - 0.5
end
--[[
Functions I use for filework and stringswork
]]
function PluralString( inValue, inSingularString, inPluralString )
	local _value_string = tostring( inValue )
	if( _value_string[#_value_string] == "1" ) then
		return inSingularString
	end
	return inPluralString
end
function PluralItemName( inItemID, inAmount )	-- BEWARE! TEMPORAL SOLUTION THERE! :D
	local _value_string = tostring( inValue )
	local _name = ""
	if( _value_string[#_value_string] == "1" ) then
		-- singular names
		_name = ItemTypeToString( inItemID )
	else
		-- plural names
		_name = ItemTypeToString( inItemID ).."s"
	end
	return _name
end
-- for filewriting purposes. 0 = false, 1 = true
function StringToBool( inValue )
	if( inValue == "1" ) then return true end
	return false
end
-- same, but reversal
function BoolToString( inValue )
	if( inValue == true ) then return 1 end
	return 0
end
