-- how much "extra" points are healed per a repair operation (fraction of full health)
local BONUS = 0.05

function OnCraftingNoRecipe(Player, Grid, Recipe)
	local Items = {}
	for x = 0, Grid:GetWidth() - 1 do
		for y = 0, Grid:GetHeight() - 1 do
			local Item = Grid:GetItem(x, y)
			if (Item.m_ItemType ~= E_ITEM_EMPTY) then
				Item.x = x
				Item.y = y
				table.insert(Items, Item)
			end
		end
	end

	if (#Items ~= 2) then
		-- Only two items together can be fixed
		return false
	end

	if (not Items[1]:IsSameType(Items[2])) then
		-- Only items of the same type can be fixed
		return false
	end

	local MaxDamage = Items[1]:GetMaxDamage()
	if (MaxDamage == 0) then
		-- Not repairable
		return false
	end

	local BonusHealth = MaxDamage * BONUS
	local FirstItemHealth = MaxDamage - Items[1].m_ItemDamage
	local SecondItemHealth = MaxDamage - Items[2].m_ItemDamage
	local NewDamage = MaxDamage - (FirstItemHealth + SecondItemHealth + BonusHealth)
	NewDamage = math.max(0, NewDamage)  -- Not lower than zero

	Recipe:SetResult(Items[1].m_ItemType, 1, NewDamage)
	Recipe:SetIngredient(Items[1].x, Items[1].y, Items[1]);
	Recipe:SetIngredient(Items[2].x, Items[2].y, Items[2]);
	return true
end
