
-- Storage.lua
-- Implements the storage access object, shielding the rest of the code away from the DB

--[[
The cStorage class is the interface to the underlying storage, the SQLite database.
This class knows how to load player areas from the DB, how to add or remove areas in the DB
and other such operations.

Also, a g_Storage global variable is declared, it holds the single instance of the storage.
--]]





cStorage = {};

g_Storage = {};





--- Initializes the storage subsystem, creates the g_Storage object
-- Returns true if successful, false if not
function InitializeStorage()
	g_Storage = cStorage:new();
	if (not(g_Storage:OpenDB())) then
		return false;
	end
	
	return true;
end





function cStorage:new(obj)
	obj = obj or {};
	setmetatable(obj, self);
	self.__index = self;
	return obj;
end




--- Opens the DB and makes sure it has all the columns needed
-- Returns true if successful, false otherwise
function cStorage:OpenDB()
	local ErrCode, ErrMsg;
	self.DB, ErrCode, ErrMsg = sqlite3.open("ProtectionAreas.sqlite");
	if (self.DB == nil) then
		LOGWARNING(PluginPrefix .. "Cannot open ProtectionAreas.sqlite, error " .. ErrCode .. " (" .. ErrMsg ..")");
		return false;
	end
	
	if (
		not(self:CreateTable("Areas", {"ID INTEGER PRIMARY KEY AUTOINCREMENT", "MinX", "MaxX", "MinZ", "MaxZ", "WorldName", "CreatorUserName"})) or
		not(self:CreateTable("AllowedUsers", {"AreaID", "UserName"}))
	) then
		LOGWARNING(PluginPrefix .. "Cannot create DB tables!");
		return false;
	end
	
	return true;
end





--- Executes the SQL command given, calling the a_Callback for each result
-- If the SQL command fails, prints it out on the server console and returns false
-- Returns true on success
function cStorage:DBExec(a_SQL, a_Callback, a_CallbackParam)
	local ErrCode = self.DB:exec(a_SQL, a_Callback, a_CallbackParam);
	if (ErrCode ~= sqlite3.OK) then
		LOGWARNING(PluginPrefix .. "Error " .. ErrCode .. " (" .. self.DB:errmsg() .. 
			") while processing SQL command >>" .. a_SQL .. "<<"
		);
		return false;
	end
	return true;
end





--- Creates the table of the specified name and columns[]
-- If the table exists, any columns missing are added; existing data is kept
function cStorage:CreateTable(a_TableName, a_Columns)
	-- Try to create the table first
	local sql = "CREATE TABLE IF NOT EXISTS '" .. a_TableName .. "' (";
	sql = sql .. table.concat(a_Columns, ", ");
	sql = sql .. ")";
	if (not(self:DBExec(sql))) then
		LOGWARNING(PluginPrefix .. "Cannot create DB Table " .. a_TableName);
		return false;
	end
	-- SQLite doesn't inform us if it created the table or not, so we have to continue anyway
	
	-- Check each column whether it exists
	-- Remove all the existing columns from a_Columns:
	local RemoveExistingColumn = function(UserData, NumCols, Values, Names)
		-- Remove the received column from a_Columns. Search for column name in the Names[] / Values[] pairs
		for i = 1, NumCols do
			if (Names[i] == "name") then
				local ColumnName = Values[i]:lower();
				-- Search the a_Columns if they have that column:
				for j = 1, #a_Columns do
					-- Cut away all column specifiers (after the first space), if any:
					local SpaceIdx = string.find(a_Columns[j], " ");
					if (SpaceIdx ~= nil) then
						SpaceIdx = SpaceIdx - 1;
					end
					local ColumnTemplate = string.lower(string.sub(a_Columns[j], 1, SpaceIdx));
					-- If it is a match, remove from a_Columns:
					if (ColumnTemplate == ColumnName) then
						table.remove(a_Columns, j);
						break;  -- for j
					end
				end  -- for j - a_Columns[]
			end
		end  -- for i - Names[] / Values[]
		return 0;
	end
	if (not(self:DBExec("PRAGMA table_info(" .. a_TableName .. ")", RemoveExistingColumn))) then
		LOGWARNING(PluginPrefix .. "Cannot query DB table structure");
		return false;
	end
	
	-- Create the missing columns
	-- a_Columns now contains only those columns that are missing in the DB
	if (#a_Columns > 0) then
		LOGINFO(PluginPrefix .. "Database table \"" .. a_TableName .. "\" is missing " .. #a_Columns .. " columns, fixing now.");
		for idx, ColumnName in ipairs(a_Columns) do
			if (not(self:DBExec("ALTER TABLE '" .. a_TableName .. "' ADD COLUMN " .. ColumnName))) then
				LOGWARNING(PluginPrefix .. "Cannot add DB table \"" .. a_TableName .. "\" column \"" .. ColumnName .. "\"");
				return false;
			end
		end
		LOGINFO(PluginPrefix .. "Database table \"" .. a_TableName .. "\" columns fixed.");
	end
	
	return true;
end





--- Returns true if the specified area is allowed for the specified player
function cStorage:IsAreaAllowed(a_AreaID, a_PlayerName, a_WorldName)
	assert(a_AreaID);
	assert(a_PlayerName);
	assert(a_WorldName);
	assert(self);
	
	local lcPlayerName = string.lower(a_PlayerName);
	local res = false;
	local sql = "SELECT COUNT(*) FROM AllowedUsers WHERE (AreaID = " .. a_AreaID .. 
		") AND (UserName ='" .. lcPlayerName .. "')";
	local function SetResTrue(UserData, NumValues, Values, Names)
		res = (tonumber(Values[1]) > 0);
		return 0;
	end
	if (not(self:DBExec(sql, SetResTrue))) then
		LOGWARNING("SQL error while determining area allowance");
		return false;
	end
	return res;
end





--- Loads cPlayerAreas for the specified player from the DB. Returns a cPlayerAreas object
function cStorage:LoadPlayerAreas(a_PlayerName, a_PlayerX, a_PlayerZ, a_WorldName)
	assert(a_PlayerName);
	assert(a_PlayerX);
	assert(a_PlayerZ);
	assert(a_WorldName);
	assert(self);
	
	-- Bounds for which the areas are loaded
	local BoundsMinX = a_PlayerX - g_AreaBounds;
	local BoundsMaxX = a_PlayerX + g_AreaBounds;
	local BoundsMinZ = a_PlayerZ - g_AreaBounds;
	local BoundsMaxZ = a_PlayerZ + g_AreaBounds;

	local res = cPlayerAreas:new(
		BoundsMinX + g_AreaSafeEdge, BoundsMinZ + g_AreaSafeEdge,
		BoundsMaxX - g_AreaSafeEdge, BoundsMaxZ - g_AreaSafeEdge
	);
	
	--[[
	LOG("Loading protection areas for player " .. a_PlayerName .. " centered around {" .. a_PlayerX .. ", " .. a_PlayerZ ..
		"}, bounds are {" .. BoundsMinX .. ", " .. BoundsMinZ .. "} - {" ..
		BoundsMaxX .. ", " .. BoundsMaxZ .. "}"
	);
	--]]
	
	-- Load the areas from the DB, based on the player's location
	local lcWorldName = string.lower(a_WorldName);
	local sql = 
		"SELECT ID, MinX, MaxX, MinZ, MaxZ FROM Areas WHERE " ..
		"MinX < " .. BoundsMaxX .. " AND MaxX > " .. BoundsMinX .. " AND " ..
		"MinZ < " .. BoundsMaxZ .. " AND MaxZ > " .. BoundsMinZ .. " AND " ..
		"WorldName = '" .. lcWorldName .."'";
	
	local function AddAreas(UserData, NumValues, Values, Names)
		if ((NumValues < 5) or ((Values[1] and Values[2] and Values[3] and Values[4] and Values[5]) == nil)) then
			LOGWARNING("SQL query didn't return all data");
			return 0;
		end
		res:AddArea(cCuboid(Values[2], 0, Values[4], Values[3], 255, Values[5]), self:IsAreaAllowed(Values[1], a_PlayerName, a_WorldName));
		return 0;
	end
	
	if (not(self:DBExec(sql, AddAreas))) then
		LOGWARNING("SQL error while querying areas");
		return res;
	end
	
	return res;
end





--- Adds a new area into the DB. a_AllowedNames is a table listing all the players that are allowed in the area
-- Returns the ID of the new area, or -1 on failure
function cStorage:AddArea(a_Cuboid, a_WorldName, a_CreatorName, a_AllowedNames)
	assert(a_Cuboid);
	assert(a_WorldName);
	assert(a_CreatorName);
	assert(a_AllowedNames);
	assert(self);
	
	-- Store the area in the DB
	local ID = -1;
	local function RememberID(UserData, NumCols, Values, Names)
		for i = 1, NumCols do
			if (Names[i] == "ID") then
				ID = Values[i];
			end
		end
		return 0;
	end
	local lcWorldName = string.lower(a_WorldName);
	local lcCreatorName = string.lower(a_CreatorName);
	local sql = 
		"INSERT INTO Areas (ID, MinX, MaxX, MinZ, MaxZ, WorldName, CreatorUserName) VALUES (NULL, " ..
		a_Cuboid.p1.x .. ", " .. a_Cuboid.p2.x .. ", " .. a_Cuboid.p1.z .. ", " .. a_Cuboid.p2.z .. 
		", '"  .. lcWorldName .. "', '" .. lcCreatorName ..
		"'); SELECT last_insert_rowid() AS ID";
	if (not(self:DBExec(sql, RememberID))) then
		LOGWARNING(PluginPrefix .. "SQL Error while inserting new area");
		return -1;
	end
	if (ID == -1) then
		LOGWARNING(PluginPrefix .. "SQL Error while retrieving INSERTion ID");
		return -1;
	end
	
	-- Store each allowed player in the DB
	for idx, Name in ipairs(a_AllowedNames) do
		local lcName = string.lower(Name);
		local sql = "INSERT INTO AllowedUsers (AreaID, UserName) VALUES (" .. ID .. ", '" .. lcName .. "')";
		if (not(self:DBExec(sql))) then
			LOGWARNING(PluginPrefix .. "SQL Error while inserting new area's allowed player " .. Name);
		end
	end
	return ID;
end





function cStorage:DelArea(a_WorldName, a_AreaID)
	assert(a_WorldName);
	assert(a_AreaID);
	assert(self);
	
	-- Since all areas are stored in a single DB (for now), the worldname parameter isn't used at all
	-- Later if we change to a per-world DB, we'll need the world name
	
	-- Delete from both tables simultaneously
	local sql = 
		"DELETE FROM Areas          WHERE ID = "     .. a_AreaID .. ";" ..
		"DELETE FROM AllowedUsers WHERE AreaID = " .. a_AreaID;
	if (not(self:DBExec(sql))) then
		LOGWARNING(PluginPrefix .. "SQL error while deleting area " .. a_AreaID .. " from world \"" .. a_WorldName .. "\"");
		return false;
	end
	
	return true;
end





--- Removes the user from the specified area
function cStorage:RemoveUser(a_AreaID, a_UserName, a_WorldName)
	assert(a_AreaID);
	assert(a_UserName);
	assert(a_WorldName);
	assert(self);
	
	-- WorldName is not used yet, because all the worlds share the same DB in this version
	
	local lcUserName = string.lower(a_UserName);
	local sql = "DELETE FROM AllowedUsers WHERE " .. 
		"AreaID = " ..  a_AreaID .. " AND UserName = '" .. lcUserName .. "'";
	if (not(self:DBExec(sql))) then	
		LOGWARNING("SQL error while removing user " .. a_UserName .. " from area ID " .. a_AreaID);
		return false;
	end
	return true;
end





--- Removes the user from all areas in the specified world
function cStorage:RemoveUserAll(a_UserName, a_WorldName)
	assert(a_UserName);
	assert(a_WorldName);
	assert(self);
	
	local lcUserName = string.lower(a_UserName);
	local sql = "DELETE FROM AllowedUsers WHERE UserName = '" .. lcUserName .."'";
	if (not(self:DBExec(sql))) then
		LOGWARNING("SQL error while removing user " .. a_UserName .. " from all areas");
		return false;
	end
	return true;
end





--- Calls the callback for each area intersecting the specified coords
-- Callback signature: function(ID, MinX, MinZ, MaxX, MaxZ, CreatorName)
function cStorage:ForEachArea(a_BlockX, a_BlockZ, a_WorldName, a_Callback)
	assert(a_BlockX);
	assert(a_BlockZ);
	assert(a_WorldName);
	assert(a_Callback);
	assert(self);

	-- SQL callback that parses the values and calls our callback
	function CallCallback(UserData, NumValues, Values, Names)
		if (NumValues ~= 6) then
			-- Not enough values returned, skip this row
			return 0;
		end
		local ID          = Values[1];
		local MinX        = Values[2];
		local MinZ        = Values[3];
		local MaxX        = Values[4];
		local MaxZ        = Values[5];
		local CreatorName = Values[6];
		a_Callback(ID, MinX, MinZ, MaxX, MaxZ, CreatorName);
		return 0;
	end
	
	local lcWorldName = string.lower(a_WorldName);
	local sql = "SELECT ID, MinX, MinZ, MaxX, MaxZ, CreatorUserName FROM Areas WHERE " ..
		"MinX <= " .. a_BlockX .. " AND MaxX >= " .. a_BlockX .. " AND " ..
		"MinZ <= " .. a_BlockZ .. " AND MaxZ >= " .. a_BlockZ .. " AND " ..
		"WorldName = '" .. lcWorldName .. "'";
	if (not(self:DBExec(sql, CallCallback))) then
		LOGWARNING("SQL Error while iterating through areas (cStorage:ForEachArea())");
		return false;
	end
	return true;
end





--- Returns the info on the specified area
-- Returns MinX, MinZ, MaxX, MaxZ, CreatorName on success, or nothing on failure
function cStorage:GetArea(a_AreaID, a_WorldName)
	assert(a_AreaID);
	assert(a_WorldName);
	assert(self);

	local MinX, MinZ, MaxX, MaxZ, CreatorName;
	local HasValues = false;
	
	-- SQL callback that parses the values and remembers them in variables
	function RememberValues(UserData, NumValues, Values, Names)
		if (NumValues ~= 5) then
			-- Not enough values returned, skip this row
			return 0;
		end
		MinX        = Values[1];
		MinZ        = Values[2];
		MaxX        = Values[3];
		MaxZ        = Values[4];
		CreatorName = Values[5];
		HasValues = true;
		return 0;
	end
	
	local lcWorldName = string.lower(a_WorldName);
	local sql = "SELECT MinX, MinZ, MaxX, MaxZ, CreatorUserName FROM Areas WHERE " ..
		"ID = " .. a_AreaID .. " AND WorldName = '" .. lcWorldName .. "'";
	if (not(self:DBExec(sql, RememberValues))) then
		LOGWARNING("SQL Error while getting area info (cStorage:ForEachArea())");
		return;
	end
	
	-- If no data has been retrieved, return nothing
	if (not(HasValues)) then
		return;
	end
	
	return MinX, MinZ, MaxX, MaxZ, CreatorName;
end





--- Calls the callback for each allowed user for the specified area
-- Callback signature: function(UserName)
function cStorage:ForEachUserInArea(a_AreaID, a_WorldName, a_Callback)
	assert(a_AreaID);
	assert(a_WorldName);
	assert(a_Callback);
	assert(self);
	
	-- Since in this version all the worlds share a single DB, the a_WorldName parameter is not actually used
	-- But this may change in the future, when we have a per-world DB
	
	local function CallCallback(UserData, NumValues, Values)
		if (NumValues ~= 1) then
			return 0;
		end
		a_Callback(Values[1]);
		return 0;
	end
	local sql = "SELECT UserName FROM AllowedUsers WHERE AreaID = " .. a_AreaID;
	if (not(self:DBExec(sql, CallCallback))) then
		LOGWARNING("SQL error while iterating area users for AreaID" .. a_AreaID);
		return false;
	end
	return true;
end





--- Adds the specified usernames to the specified area, if not already present
-- a_Users is an array table of usernames to add
function cStorage:AddAreaUsers(a_AreaID, a_WorldName, a_AddedBy, a_Users)
	assert(a_AreaID);
	assert(a_WorldName);
	assert(a_Users);
	assert(self);
	
	-- Convert all usernames to lowercase
	for idx, Name in ipairs(a_Users) do
		a_Users[idx] = string.lower(Name);
	end
	
	-- Remove from a_Users the usernames already present in the area
	local sql = "SELECT UserName FROM AllowedUsers WHERE AreaID = " .. a_AreaID;
	local function RemovePresent(UserData, NumValues, Values, Names)
		if (NumValues ~= 1) then
			-- Invalid response format
			return 0;
		end
		local DBName = Values[1];
		-- Remove the name from a_Users, if exists
		for idx, Name in ipairs(a_Users) do
			if (Name == DBName) then
				table.remove(a_Users, idx);
				return 0;
			end
		end
		return 0;
	end
	if (not(self:DBExec(sql, RemovePresent))) then
		LOGWARNING("SQL error while iterating through users");
		return false;
	end
	
	-- Add the users
	for idx, Name in ipairs(a_Users) do
		local sql = "INSERT INTO AllowedUsers (AreaID, UserName) VALUES (" .. a_AreaID .. ", '" .. Name .. "')";
		if (not(self:DBExec(sql))) then
			LOGWARNING("SQL error while adding user " .. Name .. " to area " .. a_AreaID);
		end
	end
	
	return true;
end





