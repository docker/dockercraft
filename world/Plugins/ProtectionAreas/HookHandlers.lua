
-- HookHandlers.lua
-- Implements the handlers for individual hooks





--- Registers all the hooks that the plugin needs to know about
function InitializeHooks(a_Plugin)
	local PlgMgr = cRoot:Get():GetPluginManager();
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,   OnPlayerDestroyed);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_LEFT_CLICK,  OnPlayerLeftClick);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING,      OnPlayerMoving);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_SPAWNED,     OnPlayerSpawned);
end





--- Called by MCS when a player disconnects
function OnPlayerDestroyed(a_Player)
	-- Remove the player's cProtectionArea object
	g_PlayerAreas[a_Player:GetUniqueID()] = nil;
	
	-- If the player is a VIP, they had a command state, remove that as well
	g_CommandStates[a_Player:GetUniqueID()] = nil;
	
	return false;
end;





--- Called by MCS whenever a player enters a world (is spawned)
function OnPlayerSpawned(a_Player)
	-- Create a new cPlayerAreas object for this player
	if (g_PlayerAreas[a_Player:GetUniqueID()] == nil) then
		LoadPlayerAreas(a_Player);
	end;

	return false;
end





--- Called by MCS whenever a player is moving (at most once every tick)
function OnPlayerMoving(a_Player)
	local PlayerID = a_Player:GetUniqueID();
	
	-- If for some reason we don't have a cPlayerAreas object for this player, load it up
	local PlayerAreas = g_PlayerAreas[PlayerID];
	if (PlayerAreas == nil) then
		LoadPlayerAreas(a_Player);
		return false;
	end;
	
	-- If the player is outside their areas' safe space, reload
	if (not(PlayerAreas:IsInSafe(a_Player:GetPosX(), a_Player:GetPosZ()))) then
		LoadPlayerAreas(a_Player);
	end
	return false;
end





--- Called by MCS when a player left-clicks
function OnPlayerLeftClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_Status)
	-- If the player has lclked with the wand; regardless of their permissions, let's set the coords:
	if (cConfig:IsWand(a_Player:GetEquippedItem())) then
		-- BlockFace < 0 means "use item", for which the coords are not given by the client
		if (a_BlockFace < 0) then
			return true;
		end

		-- Convert the clicked coords into the block space
		a_BlockX, a_BlockY, a_BlockZ = AddFaceDirection(a_BlockX, a_BlockY, a_BlockZ, a_BlockFace);

		-- Set the coords in the CommandState
		GetCommandStateForPlayer(a_Player):SetCoords1(a_BlockX, a_BlockZ);
		a_Player:SendMessage(string.format(g_Msgs.Coords1Set, a_BlockX, a_BlockZ));
		return true;
	end;
	
	-- Check the player areas to see whether to disable this action
	local Areas = g_PlayerAreas[a_Player:GetUniqueID()];
	if not(Areas:CanInteractWithBlock(a_BlockX, a_BlockZ)) then
		a_Player:SendMessage(g_Msgs.NotAllowedToDig);
		return true;
	end
	
	-- Allow interaction
	return false;
end





--- Called by MCS when a player right-clicks
function OnPlayerRightClick(a_Player, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_CursorX, a_CursorY, a_CursorZ, a_Status)

	-- BlockFace < 0 means "use item", for which the coords are not given by the client
	if (a_BlockFace < 0) then
		return false;
	end

	-- Convert the clicked coords into the block space
	a_BlockX, a_BlockY, a_BlockZ = AddFaceDirection(a_BlockX, a_BlockY, a_BlockZ, a_BlockFace);
	
	-- If the player has rclked with the wand; regardless of their permissions, let's set the coords
	if (cConfig:IsWand(a_Player:GetEquippedItem())) then
		-- Set the coords in the CommandState
		GetCommandStateForPlayer(a_Player):SetCoords2(a_BlockX, a_BlockZ);
		a_Player:SendMessage(string.format(g_Msgs.Coords2Set, a_BlockX, a_BlockZ));
		return true;
	end;
	
	-- Check the player areas to see whether to disable this action
	local Areas = g_PlayerAreas[a_Player:GetUniqueID()];
	if not(Areas:CanInteractWithBlock(a_BlockX, a_BlockZ)) then
		a_Player:SendMessage(g_Msgs.NotAllowedToBuild);
		return true;
	end

	-- Allow interaction
	return false;
end




