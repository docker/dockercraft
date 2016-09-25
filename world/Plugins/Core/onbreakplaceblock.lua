-- Copyright (c) 2012-2014 Alexander Harkness

-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	-- Don't fail if the block is air.
	if (BlockFace == -1) then
		return false
	end

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

	if not (Player:HasPermission("core.build")) then
		SendMessageFailure( Player, "You do not have the 'core.build' permission, thou cannot build" )
		return true
	end
	
	if not (Player:HasPermission("core.spawnprotect.bypass")) and (PROTECTRADIUS ~= 0) then
		local World = Player:GetWorld()
		local xcoord = World:GetSpawnX()
		local ycoord = World:GetSpawnY()
		local zcoord = World:GetSpawnZ()
		if not ((BlockX <= (xcoord + PROTECTRADIUS)) and (BlockX >= (xcoord - PROTECTRADIUS))) then
			return false -- Not in spawn area.
		end
		if not ((BlockY <= (ycoord + PROTECTRADIUS)) and (BlockY >= (ycoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
		if not ((BlockZ <= (zcoord + PROTECTRADIUS)) and (BlockZ >= (zcoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
			SendMessageFailure( Player, "Go further from spawn to build" )
			return true
	end
	
	return false
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, OldBlockType, OldBlockMeta)
	-- Don't fail if the block is air.
	if BlockFace == -1 then
		return false
	end

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

	if not (Player:HasPermission("core.build")) then
		SendMessageFailure( Player, "You do not have the 'core.build' permission, thou cannot build" )
		return true
	end
	
	if not (Player:HasPermission("core.spawnprotect.bypass")) and not (PROTECTRADIUS == 0) then
		local World = Player:GetWorld()
		local xcoord = World:GetSpawnX()
		local ycoord = World:GetSpawnY()
		local zcoord = World:GetSpawnZ()

		if not ((BlockX <= (xcoord + PROTECTRADIUS)) and (BlockX >= (xcoord - PROTECTRADIUS))) then
			return false -- Not in spawn area.
		end
		if not ((BlockY <= (ycoord + PROTECTRADIUS)) and (BlockY >= (ycoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
		if not ((BlockZ <= (zcoord + PROTECTRADIUS)) and (BlockZ >= (zcoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
	
		SendMessageFailure( Player, "Go further from spawn to build" )

		return true
	end

	return false
end
