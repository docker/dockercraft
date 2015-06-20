
-- PlayerAreas.lua
-- Implements the cPlayerAreas class representing the per-player area storage object

--[[
Each player instance is expected to have a separate object of type cPlayerAreas.
Each object has an array of {cuboid, IsAllowed} tables, one for each area that is "within reach"
The code can then ask each object, whether the player can interact with a certain block or not.
A player can interact with a block if either one of these is true:
1, There are no areas covering the block
2, There is at least one area covering the block with IsAllowed set to true
The object also has a m_SafeCuboid object that specified the area within which the player may move
without the PlayerAreas needing a re-query.

Also, a global table g_PlayerAreas is the actual map of PlayerID -> cPlayerAreas
--]]




cPlayerAreas = {};

g_PlayerAreas = {};





function cPlayerAreas:new(a_SafeMinX, a_SafeMinZ, a_SafeMaxX, a_SafeMaxZ)
	assert(a_SafeMinX);
	assert(a_SafeMinZ);
	assert(a_SafeMaxX);
	assert(a_SafeMaxZ);
	
	local obj = {};
	setmetatable(obj, self);
	self.__index = self;
	self.m_SafeCuboid = cCuboid(a_SafeMinX, 0, a_SafeMinZ, a_SafeMaxX, 255, a_SafeMaxZ);
	return obj;
end




-- Adds a new cuboid to the area list, where the player is either allowed or not, depending on the IsAllowed param
function cPlayerAreas:AddArea(a_Cuboid, a_IsAllowed)
	table.insert(self, {m_Cuboid = a_Cuboid, m_IsAllowed = a_IsAllowed});
end





--- returns true if the player owning this object can interact with the specified block
function cPlayerAreas:CanInteractWithBlock(a_BlockX, a_BlockZ)
	assert(self);
	
	-- iterate through all the stored areas:
	local IsInsideAnyArea = false;
	for idx, Area in ipairs(self) do
		if (Area.m_Cuboid:IsInside(a_BlockX, 1, a_BlockZ)) then  -- We don't care about Y coords, so use a dummy value
			if (Area.m_IsAllowed) then
				return true;
			end
			-- The coords are inside a cuboid for which the player doesn't have access, take a note of it
			IsInsideAnyArea = true;
		end
	end
	
	if (IsInsideAnyArea) then
		-- The specified coords are inside at least one area, but none of them allow the player to interact
		return false;
	end
	
	-- The coords are not inside any area
	return cConfig.m_AllowInteractNoArea;
end





--- Calls the specified callback for each area contained within
-- a_Callback has a signature: function(a_Cuboid, a_IsAllowed)
-- Returns true if all areas have been enumerated, false if the callback has aborted by returning true
function cPlayerAreas:ForEachArea(a_Callback)
	assert(self);
	
	for idx, Area in ipairs(self) do
		if (a_Callback(Area.m_Cuboid, Area.m_IsAllowed)) then
			return false;
		end
	end
	return true;
end





--- Returns true if the player is withing the safe cuboid (no need to re-query the areas)
function cPlayerAreas:IsInSafe(a_BlockX, a_BlockZ)
	assert(self);
	return self.m_SafeCuboid:IsInside(a_BlockX, 0, a_BlockZ);
end




