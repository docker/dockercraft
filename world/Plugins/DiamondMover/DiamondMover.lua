
-- DiamondMover.lua

-- An example Lua plugin using the cBlockArea object
-- When a player rclks with a diamond in their hand, an area around the clicked block is moved in the direction the player is facing





-- Global variables
MOVER_SIZE_X = 4;
MOVER_SIZE_Y = 4;
MOVER_SIZE_Z = 4;





function Initialize(Plugin)
	Plugin:SetName("DiamondMover");
	Plugin:SetVersion(1);
	
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_USED_ITEM, OnPlayerUsedItem);

	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion());
	return true;
end





function OnPlayerUsedItem(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)

	-- Don't check if the direction is in the air
	if (BlockFace == -1) then
		return false;
	end;

	if (not Player:HasPermission("diamondmover.move")) then
		return false;
	end;

	-- Rclk with a diamond to push in the direction the player is facing
	if (Player:GetEquippedItem().m_ItemType == E_ITEM_DIAMOND) then
		local Area = cBlockArea();
		Area:Read(Player:GetWorld(),
			BlockX - MOVER_SIZE_X, BlockX + MOVER_SIZE_X,
			BlockY - MOVER_SIZE_Y, BlockY + MOVER_SIZE_Y,
			BlockZ - MOVER_SIZE_Z, BlockZ + MOVER_SIZE_Z
		);

		local PlayerPitch = Player:GetPitch();
		if (PlayerPitch < -70) then  -- looking up
			BlockY = BlockY + 1;
		else
			if (PlayerPitch > 70) then  -- looking down
				BlockY = BlockY - 1;
			else
				local PlayerRot = Player:GetYaw() + 180;  -- Convert [-180, 180] into [0, 360] for simpler conditions
				if ((PlayerRot < 45) or (PlayerRot > 315)) then
					BlockZ = BlockZ - 1;
				else
					if (PlayerRot < 135) then
						BlockX = BlockX + 1;
					else
						if (PlayerRot < 225) then
							BlockZ = BlockZ + 1;
						else
							BlockX = BlockX - 1;
						end;
					end;
				end;
			end;
		end;

		Area:Write(Player:GetWorld(), BlockX - MOVER_SIZE_X, BlockY - MOVER_SIZE_Y, BlockZ - MOVER_SIZE_Z);
		return false;
	end
end




