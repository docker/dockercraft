
-- CommandState.lua

-- Implements the cCommandState class representing a command state for each VIP player

--[[
The command state holds internal info, such as the coords they selected using the wand
The command state needs to be held in a per-entity manner, so that we can support multiple logins
from the same account (just for the fun of it)
The OOP class implementation follows the PiL 16.1

Also, a global table g_CommandStates is the map of PlayerEntityID -> cCommandState
--]]





cCommandState = {
	-- Default coords
	m_Coords1 = {x = 0, z = 0};  -- lclk coords
	m_Coords2 = {x = 0, z = 0};  -- rclk coords
	m_LastCoords = 0;  -- When Coords1 or Coords2 is set, this gets set to 1 or 2, signifying the last changed set of coords
	m_HasCoords1 = false;  -- Set to true when m_Coords1 has been set by the user
	m_HasCoords2 = false;  -- Set to true when m_Coords2 has been set by the user
};

g_CommandStates = {};





function cCommandState:new(obj)
	obj = obj or {};
	setmetatable(obj, self);
	self.__index = self;
	return obj;
end





--- Returns the current coord pair as a cCuboid object
function cCommandState:GetCurrentCuboid()
	if (not(self.m_HasCoords1) or not(self.m_HasCoords2)) then
		-- Some of the coords haven't been set yet
		return nil;
	end
	
	local res = cCuboid(
		self.m_Coords1.x, 0,   self.m_Coords1.z,
		self.m_Coords2.x, 255, self.m_Coords2.z
	);
	res:Sort();
	return res;
end





--- Returns the x, z coords that were the set last,
-- That is, either m_Coords1 or m_Coords2, based on m_LastCoords member
-- Returns nothing if no coords were set yet
function cCommandState:GetLastCoords()
	if (self.m_LastCoords == 0) then
		-- No coords have been set yet
		return;
	elseif (self.m_LastCoords == 1) then
		return self.m_Coords1.x, self.m_Coords1.z;
	elseif (self.m_LastCoords == 2) then
		return self.m_Coords2.x, self.m_Coords2.z;
	else
		LOGWARNING(PluginPrefix .. "cCommandState is in an unexpected state, m_LastCoords == " .. self.m_LastCoords);
		return;
	end
end





--- Sets the first set of coords (upon rclk with a wand)
function cCommandState:SetCoords1(a_BlockX, a_BlockZ)
	self.m_Coords1.x = a_BlockX;
	self.m_Coords1.z = a_BlockZ;
	self.m_LastCoords = 1;
	self.m_HasCoords1 = true;
end





--- Sets the second set of coords (upon lclk with a wand)
function cCommandState:SetCoords2(a_BlockX, a_BlockZ)
	self.m_Coords2.x = a_BlockX;
	self.m_Coords2.z = a_BlockZ;
	self.m_LastCoords = 2;
	self.m_HasCoords2 = true;
end





--- Returns the cCommandState for the specified player; creates one if not existant
function GetCommandStateForPlayer(a_Player)
	local res = g_CommandStates[a_Player:GetUniqueID()];
	if (res == nil) then
		res = cCommandState:new();
		g_CommandStates[a_Player:GetUniqueID()] = res;
	end
	return res;
end;




