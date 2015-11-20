
-- CommandHandlers.lua
-- Defines the individual command handlers





--- Handles the ProtAdd command
function HandleAddArea(a_Split, a_Player)
	-- Command syntax: /protection add username1 [username2] [username3] ...
	if (#a_Split < 3) then
		a_Player:SendMessage(g_Msgs.ErrExpectedListOfUsernames);
		return true;
	end
	
	-- Get the cuboid that the player had selected
	local CmdState = GetCommandStateForPlayer(a_Player);
	if (CmdState == nil) then
		a_Player:SendMessage(g_Msgs.ErrCmdStateNilAddArea);
		return true;
	end
	local Cuboid = CmdState:GetCurrentCuboid();
	if (Cuboid == nil) then
		a_Player:SendMessage(g_Msgs.ErrNoAreaWanded);
		return true;
	end
	
	-- Put all allowed players into a table:
	AllowedNames = {};
	for i = 3, #a_Split do
		table.insert(AllowedNames, a_Split[i]);
	end
	
	-- Add the area to the storage
	local AreaID = g_Storage:AddArea(Cuboid, a_Player:GetWorld():GetName(), a_Player:GetName(), AllowedNames);
	a_Player:SendMessage(string.format(g_Msgs.AreaAdded, AreaID));
	
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





function HandleAddAreaCoords(a_Split, a_Player)
	-- Command syntax: /protection addc x1 z1 x2 z2 username1 [username2] [username3] ...
	if (#a_Split < 7) then
		a_Player:SendMessage(g_Msgs.ErrExpectedCoordsUsernames);
		return true;
	end
	
	-- Convert the coords to a cCuboid
	local x1, z1 = tonumber(a_Split[3]), tonumber(a_Split[4]);
	local x2, z2 = tonumber(a_Split[5]), tonumber(a_Split[6]);
	if ((x1 == nil) or (z1 == nil) or (x2 == nil) or (z2 == nil)) then
		a_Player:SendMessage(g_Msgs.ErrParseCoords);
		return true;
	end
	local Cuboid = cCuboid(x1, 0, z1, x2, 255, z1);
	Cuboid:Sort();
	
	-- Put all allowed players into a table:
	AllowedNames = {};
	for i = 7, #a_Split do
		table.insert(AllowedNames, a_Split[i]);
	end
	
	-- Add the area to the storage
	local AreaID = g_Storage:AddArea(Cuboid, a_Player:GetWorld():GetName(), a_Player:GetName(), AllowedNames);
	a_Player:SendMessage(string.format(g_Msgs.AreaAdded, AreaID));
	
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





function HandleAddAreaUser(a_Split, a_Player)
	-- Command syntax: /protection user add AreaID username1 [username2] [username3] ...
	if (#a_Split < 5) then
		a_Player:SendMessage(g_Msgs.ErrExpectedAreaIDUsernames);
		return true;
	end
	
	-- Put all allowed players into a table:
	AllowedNames = {};
	for i = 5, #a_Split do
		table.insert(AllowedNames, a_Split[i]);
	end
	
	-- Add the area to the storage
	if (not(g_Storage:AddAreaUsers(
		tonumber(a_Split[4]), a_Player:GetWorld():GetName(), a_Player:GetName(), AllowedNames))
	) then
		LOGWARNING("g_Storage:AddAreaUsers failed");
		a_Player:SendMessage(g_Msgs.ErrDBFailAddUsers);
		return true;
	end
	if (#AllowedNames == 0) then
		a_Player:SendMessage(g_Msgs.AllUsersAlreadyAllowed);
	else
		a_Player:SendMessage(string.format(g_Msgs.UsersAdded, table.concat(AllowedNames, ", ")));
	end
	
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





function HandleDelArea(a_Split, a_Player)
	-- Command syntax: /protection del AreaID
	if (#a_Split ~= 3) then
		a_Player:SendMessage(g_Msgs.ErrExpectedAreaID);
		return true;
	end
	
	-- Parse the AreaID
	local AreaID = tonumber(a_Split[3]);
	if (AreaID == nil) then
		a_Player:SendMessage(g_Msgs.ErrParseAreaID);
		return true;
	end
	
	-- Delete the area
	g_Storage:DelArea(a_Player:GetWorld():GetName(), AreaID);

	a_Player:SendMessage(string.format(g_Msgs.AreaDeleted, AreaID));
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





function HandleGiveWand(a_Split, a_Player)
	local NumGiven = a_Player:GetInventory():AddItem(cConfig:GetWandItem());
	if (NumGiven == 1) then
		a_Player:SendMessage(g_Msgs.WandGiven);
	else
		a_Player:SendMessage(g_Msgs.ErrNoSpaceForWand);
	end
	return true;
end





function HandleListAreas(a_Split, a_Player)
	-- Command syntax: /protection list [x z]
	
	local x, z;
	if (#a_Split == 2) then
		-- Get the last "wanded" coord
		local CmdState = GetCommandStateForPlayer(a_Player);
		if (CmdState == nil) then
			a_Player:SendMessage(g_Msgs.ErrCmdStateNilListAreas);
			return true;
		end
		x, z = CmdState:GetLastCoords();
		if ((x == nil) or (z == nil)) then
			a_Player:SendMessage(g_Msgs.ErrListNotWanded);
			return true;
		end
	elseif (#a_Split == 4) then
		-- Parse the coords from the command params
		x = tonumber(a_Split[3]);
		z = tonumber(a_Split[4]);
		if ((x == nil) or (z == nil)) then
			a_Player:SendMessage(g_Msgs.ErrParseCoordsListAreas);
			return true;
		end
	else
		-- Wrong number of params, report back to the user
		a_Player:SendMessage(g_Msgs.ErrSyntaxErrorListAreas);
		return true;
	end
	
	a_Player:SendMessage(string.format(g_Msgs.ListAreasHeader, x, z));
	
	-- List areas intersecting the coords
	local PlayerName = a_Player:GetName();
	local WorldName = a_Player:GetWorld():GetName();
	g_Storage:ForEachArea(x, z, WorldName,
		function(AreaID, MinX, MinZ, MaxX, MaxZ, CreatorName)
			local Coords = string.format("%s: {%d, %d} - {%d, %d} ", AreaID, MinX, MinZ, MaxX, MaxZ);
			local Allowance;
			if (g_Storage:IsAreaAllowed(AreaID, PlayerName, WorldName)) then
				Allowance = g_Msgs.AreaAllowed;
			else
				Allowance = g_Msgs.AreaNotAllowed;
			end
			a_Player:SendMessage(string.format(g_Msgs.ListAreasRow, Coords, Allowance, CreatorName));
		end
	);
	
	a_Player:SendMessage(g_Msgs.ListAreasFooter);
	return true;
end




--- Lists all allowed users for a particular area
function HandleListUsers(a_Split, a_Player)
	-- Command syntax: /protection user list AreaID
	if (#a_Split ~= 4) then
		a_Player:SendMessage(g_Msgs.ErrExpectedAreaID);
		return true
	end
	
	-- Get the general info about the area
	local AreaID = a_Split[4];
	local WorldName = a_Player:GetWorld():GetName();
	local MinX, MinZ, MaxX, MaxZ, CreatorName = g_Storage:GetArea(AreaID, WorldName);
	if (MinX == nil) then
		a_Player:SendMessage(string.format(g_Msgs.ErrNoSuchArea, AreaID));
		return true;
	end
	
	-- Send the header
	a_Player:SendMessage(string.format(g_Msgs.ListUsersHeader, AreaID, MinX, MinZ, MaxX, MaxZ, CreatorName));
	
	-- List and count the allowed users
	local NumUsers = 0;
	g_Storage:ForEachUserInArea(AreaID, WorldName, 
		function(UserName)
			a_Player:SendMessage(string.format(g_Msgs.ListUsersRow, UserName));
			NumUsers = NumUsers + 1;
		end
	);
	
	-- Send the footer
	a_Player:SendMessage(string.format(g_Msgs.ListUsersFooter, AreaID, NumUsers));
	
	return true;
end





function HandleRemoveUser(a_Split, a_Player)
	-- Command syntax: /protection user remove AreaID UserName
	if (#a_Split ~= 5) then
		a_Player:SendMessage(g_Msgs.ErrExpectedAreaIDUserName);
		return true;
	end
	
	-- Parse the AreaID
	local AreaID = tonumber(a_Split[4]);
	if (AreaID == nil) then
		a_Player:SendMessage(g_Msgs.ErrParseAreaID);
		return true;
	end
	
	-- Remove the user from the DB
	local UserName = a_Split[5];
	g_Storage:RemoveUser(AreaID, UserName, a_Player:GetWorld():GetName());
	
	-- Send confirmation
	a_Player:SendMessage(string.format(g_Msgs.RemovedUser, UserName, AreaID));
	
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





function HandleRemoveUserAll(a_Split, a_Player)
	-- Command syntax: /protection user strip UserName
	if (#a_Split ~= 4) then
		a_Player:SendMessage(g_Msgs.ErrExpectedUserName);
		return true;
	end
	
	-- Remove the user from the DB
	g_Storage:RemoveUserAll(a_Split[4], a_Player:GetWorld():GetName());

	-- Send confirmation
	a_Player:SendMessage(string.format(g_Msgs.RemovedUserAll, UserName));
	
	-- Reload all currently logged in players
	ReloadAllPlayersInWorld(a_Player:GetWorld():GetName());
	
	return true;
end





