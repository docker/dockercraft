
-- Global variables
g_DropSpensersToActivate = {};  -- A list of dispensers and droppers (as {World, X, Y Z} quadruplets) that are to be activated every tick
g_HungerReportTick = 10;
g_ShowFoodStats = false;  -- When true, each player's food stats are sent to them every 10 ticks






function Initialize(a_Plugin)
	--[[
	-- Test multiple hook handlers:
	cPluginManager.AddHook(cPluginManager.HOOK_TICK,                         OnTick1);
	cPluginManager.AddHook(cPluginManager.HOOK_TICK,                         OnTick2);
	--]]
	
	local PM = cPluginManager;
	PM:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK,           OnPlayerUsingBlock);
	PM:AddHook(cPluginManager.HOOK_PLAYER_USING_ITEM,            OnPlayerUsingItem);
	PM:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,                  OnTakeDamage);
	PM:AddHook(cPluginManager.HOOK_TICK,                         OnTick);
	PM:AddHook(cPluginManager.HOOK_CHAT,                         OnChat);
	PM:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICKING_ENTITY, OnPlayerRightClickingEntity);
	PM:AddHook(cPluginManager.HOOK_WORLD_TICK,                   OnWorldTick);
	PM:AddHook(cPluginManager.HOOK_PLUGINS_LOADED,               OnPluginsLoaded);
	PM:AddHook(cPluginManager.HOOK_PLAYER_JOINED,                OnPlayerJoined);
	PM:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_BLOCK,         OnProjectileHitBlock);
	PM:AddHook(cPluginManager.HOOK_CHUNK_UNLOADING,              OnChunkUnloading);
	PM:AddHook(cPluginManager.HOOK_WORLD_STARTED,                OnWorldStarted);
	PM:AddHook(cPluginManager.HOOK_PROJECTILE_HIT_BLOCK,         OnProjectileHitBlock);

	-- _X: Disabled WECUI manipulation:
	-- PM:AddHook(cPluginManager.HOOK_PLUGIN_MESSAGE,               OnPluginMessage);
	-- _X: Disabled so that the normal operation doesn't interfere with anything
	-- PM:AddHook(cPluginManager.HOOK_CHUNK_GENERATED,              OnChunkGenerated);

	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands();
	
	a_Plugin:AddWebTab("Debuggers",  HandleRequest_Debuggers)
	a_Plugin:AddWebTab("StressTest", HandleRequest_StressTest)

	-- Enable the following line for BlockArea / Generator interface testing:
	-- PluginManager:AddHook(Plugin, cPluginManager.HOOK_CHUNK_GENERATED);
	
	-- TestBlockAreas()
	-- TestSQLiteBindings()
	-- TestExpatBindings()
	TestPluginCalls()
	
	TestBlockAreasString()
	TestStringBase64()
	-- TestUUIDFromName()
	-- TestRankMgr()
	TestFileExt()
	TestFileLastMod()
	TestPluginInterface()
	
	local LastSelfMod = cFile:GetLastModificationTime(a_Plugin:GetLocalFolder() .. "/Debuggers.lua")
	LOG("Debuggers.lua last modified on " .. os.date("%Y-%m-%dT%H:%M:%S", LastSelfMod))

	--[[
	-- Test cCompositeChat usage in console-logging:
	LOGINFO(cCompositeChat("This is a simple message with some @2 color formatting @4 and http://links.to .")
		:AddSuggestCommandPart("(Suggested command)", "cmd")
		:AddRunCommandPart("(Run command)", "cmd")
		:SetMessageType(mtInfo)
	)
	--]]
	
	-- Test the crash in #1889:
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICKING_ENTITY,
		function (a_CBPlayer, a_CBEntity)
			a_CBPlayer:GetWorld():DoWithEntityByID(  -- This will crash the server in #1889
				a_CBEntity:GetUniqueID(),
				function(Entity)
					LOG("RightClicking an entity, crash #1889 fixed. Entity is a " .. tolua.type(Entity))
				end
			)
		end
	)
	
	return true
end;





function TestPluginInterface()
	cPluginManager:DoWithPlugin("Core",
		function (a_CBPlugin)
			if (a_CBPlugin:GetStatus() == cPluginManager.psLoaded) then
				LOG("Core plugin was found, version " .. a_CBPlugin:GetVersion())
			else
				LOG("Core plugin is not loaded")
			end
		end
	)
	
	cPluginManager:ForEachPlugin(
		function (a_CBPlugin)
			LOG("Plugin in " .. a_CBPlugin:GetFolderName() .. " has an API name of " .. a_CBPlugin:GetName() .. " and status " .. a_CBPlugin:GetStatus())
		end
	)
end




function TestFileExt()
	assert(cFile:ChangeFileExt("fileless_dir/", "new") == "fileless_dir/")
	assert(cFile:ChangeFileExt("fileless_dir/", ".new") == "fileless_dir/")
	assert(cFile:ChangeFileExt("pathless_file.ext", "new") == "pathless_file.new")
	assert(cFile:ChangeFileExt("pathless_file.ext", ".new") == "pathless_file.new")
	assert(cFile:ChangeFileExt("path/to/file.ext", "new") == "path/to/file.new")
	assert(cFile:ChangeFileExt("path/to/file.ext", ".new") == "path/to/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file", "new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file", ".new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.ext", "new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.ext", ".new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.longext", "new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.longext", ".new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.", "new") == "path/to.dir/file.new")
	assert(cFile:ChangeFileExt("path/to.dir/file.", ".new") == "path/to.dir/file.new")
end





function TestFileLastMod()
	local f = assert(io.open("test.txt", "w"))
	f:write("test")
	f:close()
	local filetime = cFile:GetLastModificationTime("test.txt")
	local ostime = os.time()
	LOG("file time: " .. filetime .. ", OS time: " .. ostime .. ", difference: " .. ostime - filetime)
end





function TestPluginCalls()
	-- In order to test the inter-plugin communication, we're going to call Core's ReturnColorFromChar() function
	-- It is a rather simple function that doesn't need any tables as its params and returns a value, too
	-- Note the signature: function ReturnColorFromChar( Split, char ) ... return cChatColog.Gray ... end
	-- The Split parameter should be a table, but it is not used in that function anyway,
	-- so we can get away with passing nil to it.
	
	LOG("Debuggers: Calling NoSuchPlugin.FnName()...")
	cPluginManager:CallPlugin("NoSuchPlugin", "FnName", "SomeParam")
	LOG("Debuggers: Calling Core.NoSuchFunction()...")
	cPluginManager:CallPlugin("Core", "NoSuchFunction", "SomeParam")
	LOG("Debuggers: Calling Core.ReturnColorFromChar(..., \"8\")...")
	local Gray = cPluginManager:CallPlugin("Core", "ReturnColorFromChar", "split", "8")
	if (Gray ~= cChatColor.Gray) then
		LOGWARNING("Debuggers: Call failed, exp " .. cChatColor.Gray .. ", got " .. (Gray or "<nil>"))
	else
		LOG("Debuggers: Call succeeded")
	end
	LOG("Debuggers: Inter-plugin calls done.")
end





function TestBlockAreas()
	LOG("Testing block areas...");
	
	-- Debug block area merging:
	local BA1 = cBlockArea();
	local BA2 = cBlockArea();
	if (BA1:LoadFromSchematicFile("schematics/test.schematic")) then
		if (BA2:LoadFromSchematicFile("schematics/fountain.schematic")) then
			BA2:SetRelBlockType(0, 0, 0, E_BLOCK_LAPIS_BLOCK);
			BA2:SetRelBlockType(1, 0, 0, E_BLOCK_LAPIS_BLOCK);
			BA2:SetRelBlockType(2, 0, 0, E_BLOCK_LAPIS_BLOCK);
			BA1:Merge(BA2, 1, 10, 1, cBlockArea.msImprint);
			BA1:SaveToSchematicFile("schematics/merge.schematic");
		end
	else
		BA1:Create(16, 16, 16);
	end
	
	-- Debug block area cuboid filling:
	BA1:FillRelCuboid(2, 9, 2, 8, 2, 8, cBlockArea.baTypes, E_BLOCK_GOLD_BLOCK);
	BA1:RelLine(2, 2, 2, 9, 8, 8, cBlockArea.baTypes or cBlockArea.baMetas, E_BLOCK_SAPLING, E_META_SAPLING_BIRCH);
	BA1:SaveToSchematicFile("schematics/fillrel.schematic");

	-- Debug block area mirroring:
	if (BA1:LoadFromSchematicFile("schematics/lt.schematic")) then
		BA1:MirrorXYNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_XY.schematic");
		BA1:MirrorXYNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_XY2.schematic");
		
		BA1:MirrorXZNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_XZ.schematic");
		BA1:MirrorXZNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_XZ2.schematic");
		
		BA1:MirrorYZNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_YZ.schematic");
		BA1:MirrorYZNoMeta();
		BA1:SaveToSchematicFile("schematics/lt_YZ2.schematic");
	end
	
	-- Debug block area rotation:
	if (BA1:LoadFromSchematicFile("schematics/rot.schematic")) then
		BA1:RotateCWNoMeta();
		BA1:SaveToSchematicFile("schematics/rot1.schematic");
		BA1:RotateCWNoMeta();
		BA1:SaveToSchematicFile("schematics/rot2.schematic");
		BA1:RotateCWNoMeta();
		BA1:SaveToSchematicFile("schematics/rot3.schematic");
		BA1:RotateCWNoMeta();
		BA1:SaveToSchematicFile("schematics/rot4.schematic");
	end

	-- Debug block area rotation:
	if (BA1:LoadFromSchematicFile("schematics/rotm.schematic")) then
		BA1:RotateCCW();
		BA1:SaveToSchematicFile("schematics/rotm1.schematic");
		BA1:RotateCCW();
		BA1:SaveToSchematicFile("schematics/rotm2.schematic");
		BA1:RotateCCW();
		BA1:SaveToSchematicFile("schematics/rotm3.schematic");
		BA1:RotateCCW();
		BA1:SaveToSchematicFile("schematics/rotm4.schematic");
	end

	-- Debug block area mirroring:
	if (BA1:LoadFromSchematicFile("schematics/ltm.schematic")) then
		BA1:MirrorXY();
		BA1:SaveToSchematicFile("schematics/ltm_XY.schematic");
		BA1:MirrorXY();
		BA1:SaveToSchematicFile("schematics/ltm_XY2.schematic");
		
		BA1:MirrorXZ();
		BA1:SaveToSchematicFile("schematics/ltm_XZ.schematic");
		BA1:MirrorXZ();
		BA1:SaveToSchematicFile("schematics/ltm_XZ2.schematic");
		
		BA1:MirrorYZ();
		BA1:SaveToSchematicFile("schematics/ltm_YZ.schematic");
		BA1:MirrorYZ();
		BA1:SaveToSchematicFile("schematics/ltm_YZ2.schematic");
	end
	
	LOG("Block areas test ended");
end


	



function TestBlockAreasString()
	-- Write one area to string, then to file:
	local BA1 = cBlockArea()
	BA1:Create(5, 5, 5, cBlockArea.baTypes + cBlockArea.baMetas)
	BA1:Fill(cBlockArea.baTypes, E_BLOCK_DIAMOND_BLOCK)
	BA1:FillRelCuboid(1, 3, 1, 3, 1, 3, cBlockArea.baTypes, E_BLOCK_GOLD_BLOCK)
	local Data = BA1:SaveToSchematicString()
	if ((type(Data) ~= "string") or (Data == "")) then
		LOG("Cannot save schematic to string")
		return
	end
	cFile:CreateFolder("schematics")
	local f = io.open("schematics/StringTest.schematic", "wb")
	f:write(Data)
	f:close()
	
	-- Load a second area from that file:
	local BA2 = cBlockArea()
	if not(BA2:LoadFromSchematicFile("schematics/StringTest.schematic")) then
		LOG("Cannot read schematic from string test file")
		return
	end
	BA2:Clear()
	
	-- Load another area from a string in that file:
	f = io.open("schematics/StringTest.schematic", "rb")
	Data = f:read("*all")
	if not(BA2:LoadFromSchematicString(Data)) then
		LOG("Cannot load schematic from string")
	end
end





function TestStringBase64()
	-- Create a binary string:
	local s = ""
	for i = 0, 255 do
		s = s .. string.char(i)
	end
	
	-- Roundtrip through Base64:
	local Base64 = Base64Encode(s)
	local UnBase64 = Base64Decode(Base64)
	
	assert(UnBase64 == s)
end





function TestUUIDFromName()
	LOG("Testing UUID-from-Name resolution...")
	
	-- Test by querying a few existing names, along with a non-existent one:
	local PlayerNames =
	{
		"xoft",
		"aloe_vera",
		"nonexistent_player",
	}
	-- WARNING: Blocking operation! DO NOT USE IN TICK THREAD!
	local UUIDs = cMojangAPI:GetUUIDsFromPlayerNames(PlayerNames)
	
	-- Log the results:
	for _, name in ipairs(PlayerNames) do
		local UUID = UUIDs[name]
		if (UUID == nil) then
			LOG("  UUID(" .. name .. ") not found.")
		else
			LOG("  UUID(" .. name .. ") = \"" .. UUID .. "\"")
		end
	end
	
	-- Test once more with the same players, valid-only. This should go directly from cache, so fast.
	LOG("Testing again with the same valid players...")
	local ValidPlayerNames =
	{
		"xoft",
		"aloe_vera",
	}
	UUIDs = cMojangAPI:GetUUIDsFromPlayerNames(ValidPlayerNames);

	-- Log the results:
	for _, name in ipairs(ValidPlayerNames) do
		local UUID = UUIDs[name]
		if (UUID == nil) then
			LOG("  UUID(" .. name .. ") not found.")
		else
			LOG("  UUID(" .. name .. ") = \"" .. UUID .. "\"")
		end
	end

	-- Test yet again, cache-only:
	LOG("Testing once more, cache only...")
	local PlayerNames3 =
	{
		"xoft",
		"aloe_vera",
		"notch",  -- Valid player name, but not cached (most likely :)
	}
	UUIDs = cMojangAPI:GetUUIDsFromPlayerNames(PlayerNames3, true)
	
	-- Log the results:
	for _, name in ipairs(PlayerNames3) do
		local UUID = UUIDs[name]
		if (UUID == nil) then
			LOG("  UUID(" .. name .. ") not found.")
		else
			LOG("  UUID(" .. name .. ") = \"" .. UUID .. "\"")
		end
	end

	LOG("UUID-from-Name resolution tests finished.")
	
	LOG("Performing a Name-from-UUID test...")
	-- local NameToTest = "aloe_vera"
	local NameToTest = "xoft"
	local Name = cMojangAPI:GetPlayerNameFromUUID(UUIDs[NameToTest])
	LOG("Name(" .. UUIDs[NameToTest] .. ") = '" .. Name .. "', expected '" .. NameToTest .. "'.")
	LOG("Name-from-UUID test finished.")
end





function TestRankMgr()
	LOG("Testing the rank manager")
	cRankManager:AddRank("LuaRank")
	cRankManager:AddGroup("LuaTestGroup")
	cRankManager:AddGroupToRank("LuaTestGroup", "LuaRank")
	cRankManager:AddPermissionToGroup("luaperm", "LuaTestGroup")
end





function TestSQLiteBindings()
	LOG("Testing SQLite bindings...");
	
	-- Debug SQLite binding
	local TestDB, ErrCode, ErrMsg = sqlite3.open("test.sqlite");
	if (TestDB ~= nil) then
		local function ShowRow(UserData, NumCols, Values, Names)
			assert(UserData == 'UserData');
			LOG("New row");
			for i = 1, NumCols do
				LOG("  " .. Names[i] .. " = " .. Values[i]);
			end
			return 0;
		end
		local sql = [=[
			CREATE TABLE numbers(num1,num2,str);
			INSERT INTO numbers VALUES(1, 11, "ABC");
			INSERT INTO numbers VALUES(2, 22, "DEF");
			INSERT INTO numbers VALUES(3, 33, "UVW");
			INSERT INTO numbers VALUES(4, 44, "XYZ");
			SELECT * FROM numbers;
		]=]
		local Res = TestDB:exec(sql, ShowRow, 'UserData');
		if (Res ~= sqlite3.OK) then
			LOG("TestDB:exec() failed: " .. Res .. " (" .. TestDB:errmsg() .. ")");
		end;
		TestDB:close();
	else
		-- This happens if for example SQLite cannot open the file (eg. a folder with the same name exists)
		LOG("SQLite3 failed to open DB! (" .. ErrCode .. ", " .. ErrMsg ..")");
	end
	
	LOG("SQLite bindings test ended");
end





function TestExpatBindings()
	LOG("Testing Expat bindings...");
	
	-- Debug LuaExpat bindings:
	local count = 0
	callbacks = {
	    StartElement = function (parser, name)
	        LOG("+ " .. string.rep(" ", count) .. name);
	        count = count + 1;
	    end,
	    EndElement = function (parser, name)
	        count = count - 1;
	        LOG("- " .. string.rep(" ", count) .. name);
	    end
	}

	local p = lxp.new(callbacks);
	p:parse("<elem1>\nnext line\nanother line");
	p:parse("text\n");
	p:parse("<elem2/>\n");
	p:parse("more text");
	p:parse("</elem1>");
	p:parse("\n");
	p:parse();  -- finishes the document
	p:close();  -- closes the parser
	
	LOG("Expat bindings test ended");
end





function OnUsingBlazeRod(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	-- Magic rod of query: show block types and metas for both neighbors of the pointed face
	local Valid, Type, Meta = Player:GetWorld():GetBlockTypeMeta(BlockX, BlockY, BlockZ);

	if (Type == E_BLOCK_AIR) then
		Player:SendMessage(cChatColor.LightGray .. "Block {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}: air:" .. Meta);
	else
		local TempItem = cItem(Type, 1, Meta);
		Player:SendMessage(cChatColor.LightGray .. "Block {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}: " .. ItemToFullString(TempItem) .. " (" .. Type .. ":" .. Meta .. ")");
	end
	
	local X, Y, Z = AddFaceDirection(BlockX, BlockY, BlockZ, BlockFace);
	Valid, Type, Meta = Player:GetWorld():GetBlockTypeMeta(X, Y, Z);
	if (Type == E_BLOCK_AIR) then
		Player:SendMessage(cChatColor.LightGray .. "Block {" .. X .. ", " .. Y .. ", " .. Z .. "}: air:" .. Meta);
	else
		local TempItem = cItem(Type, 1, Meta);
		Player:SendMessage(cChatColor.LightGray .. "Block {" .. X .. ", " .. Y .. ", " .. Z .. "}: " .. ItemToFullString(TempItem) .. " (" .. Type .. ":" .. Meta .. ")");
	end
	return false;
end





function OnUsingDiamond(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	-- Rclk with a diamond to test block area cropping and expanding
	local Area = cBlockArea();
	Area:Read(Player:GetWorld(),
		BlockX - 19, BlockX + 19,
		BlockY - 7, BlockY + 7,
		BlockZ - 19, BlockZ + 19
	);

	LOG("Size before cropping: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("crop0.dat");
	
	Area:Crop(2, 3, 0, 0, 0, 0);
	LOG("Size after cropping 1: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("crop1.dat");
	
	Area:Crop(2, 3, 0, 0, 0, 0);
	LOG("Size after cropping 2: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("crop2.dat");
	
	Area:Expand(2, 3, 0, 0, 0, 0);
	LOG("Size after expanding 1: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("expand1.dat");
	
	Area:Expand(3, 2, 1, 1, 0, 0);
	LOG("Size after expanding 2: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("expand2.dat");
	
	Area:Crop(0, 0, 0, 0, 3, 2);
	LOG("Size after cropping 3: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("crop3.dat");
	
	Area:Crop(0, 0, 3, 2, 0, 0);
	LOG("Size after cropping 4: " .. Area:GetSizeX() .. " x " .. Area:GetSizeY() .. " x " .. Area:GetSizeZ());
	Area:DumpToRawFile("crop4.dat");

	LOG("Crop test done");
	Player:SendMessage("Crop / expand test done.");
	return false;
end





function OnUsingEyeOfEnder(Player, BlockX, BlockY, BlockZ)
	-- Rclk with an eye of ender places a predefined schematic at the cursor
	local Area = cBlockArea();
	if not(Area:LoadFromSchematicFile("schematics/test.schematic")) then
		LOG("Loading failed");
		return false;
	end
	LOG("Schematic loaded, placing now.");
	Area:Write(Player:GetWorld(), BlockX, BlockY, BlockZ);
	LOG("Done.");
	return false;
end





function OnUsingEnderPearl(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	-- Rclk with an ender pearl saves a predefined area around the cursor into a .schematic file. Also tests area copying
	local Area = cBlockArea();
	if not(Area:Read(Player:GetWorld(), 
		BlockX - 8, BlockX + 8, BlockY - 8, BlockY + 8, BlockZ - 8, BlockZ + 8)
	) then
		LOG("LUA: Area couldn't be read");
		return false;
	end
	LOG("LUA: Area read, copying now.");
	local Area2 = cBlockArea();
	Area2:CopyFrom(Area);
	LOG("LUA: Copied, now saving.");
	if not(Area2:SaveToSchematicFile("schematics/test.schematic")) then
		LOG("LUA: Cannot save schematic file.");
		return false;
	end
	LOG("LUA: Done.");
	return false;
end





function OnUsingRedstoneTorch(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	-- Redstone torch activates a rapid dispenser / dropper discharge (at every tick):
	local BlockType = Player:GetWorld():GetBlock(BlockX, BlockY, BlockZ);
	if (BlockType == E_BLOCK_DISPENSER) then
		table.insert(g_DropSpensersToActivate, {World = Player:GetWorld(), x = BlockX, y = BlockY, z = BlockZ});
		Player:SendMessage("Dispenser at {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "} discharging");
		return true;
	elseif (BlockType == E_BLOCK_DROPPER) then
		table.insert(g_DropSpensersToActivate, {World = Player:GetWorld(), x = BlockX, y = BlockY, z = BlockZ});
		Player:SendMessage("Dropper at {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "} discharging");
		return true;
	else
		Player:SendMessage("Neither a dispenser nor a dropper at {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}: " .. BlockType);
	end
	return false;
end





function OnPlayerUsingItem(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)

	-- dont check if the direction is in the air
	if (BlockFace == BLOCK_FACE_NONE) then
		return false
	end

	local HeldItem = Player:GetEquippedItem();
	local HeldItemType = HeldItem.m_ItemType;

	if (HeldItemType == E_ITEM_STICK) then
		-- Magic sTick of ticking: set the pointed block for ticking at the next tick
		Player:SendMessage(cChatColor.LightGray .. "Setting next block tick to {" .. BlockX .. ", " .. BlockY .. ", " .. BlockZ .. "}")
		Player:GetWorld():SetNextBlockTick(BlockX, BlockY, BlockZ);
		return true
	elseif (HeldItemType == E_ITEM_BLAZE_ROD) then
		return OnUsingBlazeRod(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ);
	elseif (HeldItemType == E_ITEM_DIAMOND) then
		return OnUsingDiamond(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ);
	elseif (HeldItemType == E_ITEM_EYE_OF_ENDER) then
		return OnUsingEyeOfEnder(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ);
	elseif (HeldItemType == E_ITEM_ENDER_PEARL) then
		return OnUsingEnderPearl(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ);
	end
	return false;
end





function OnPlayerUsingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType, BlockMeta)
	-- dont check if the direction is in the air
	if (BlockFace == BLOCK_FACE_NONE) then
		return false
	end

	local HeldItem = Player:GetEquippedItem();
	local HeldItemType = HeldItem.m_ItemType;

	if (HeldItemType == E_BLOCK_REDSTONE_TORCH_ON) then
		return OnUsingRedstoneTorch(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ);
	end
end





function OnTakeDamage(Receiver, TDI)
	-- Receiver is cPawn
	-- TDI is TakeDamageInfo

	-- LOG(Receiver:GetClass() .. " was dealt " .. DamageTypeToString(TDI.DamageType) .. " damage: Raw " .. TDI.RawDamage .. ", Final " .. TDI.FinalDamage .. " (" .. (TDI.RawDamage - TDI.FinalDamage) .. " covered by armor)");
	return false;
end





function OnTick1()
	-- For testing multiple hook handlers per plugin
	LOGINFO("Tick1");
end





function OnTick2()
	-- For testing multiple hook handlers per plugin
	LOGINFO("Tick2");
end





--- When set to a positive number, the following OnTick() will perform GC and decrease until 0 again
GCOnTick = 0;





function OnTick()
	-- Activate all dropspensers in the g_DropSpensersToActivate list:
	local ActivateDrSp = function(DropSpenser)
		if (DropSpenser:GetContents():GetFirstUsedSlot() == -1) then
			return true;
		end
		DropSpenser:Activate();
		return false;
	end
	-- Walk the list backwards, because we're removing some items
	local idx = #g_DropSpensersToActivate;
	for i = idx, 1, -1 do
		local DrSp = g_DropSpensersToActivate[i];
		if not(DrSp.World:DoWithDropSpenserAt(DrSp.x, DrSp.y, DrSp.z, ActivateDrSp)) then
			table.remove(g_DropSpensersToActivate, i);
		end
	end
	
	
	-- If GCOnTick > 0, do a garbage-collect and decrease by one
	if (GCOnTick > 0) then
		collectgarbage();
		GCOnTick = GCOnTick - 1;
	end
	
	return false;
end





function OnWorldTick(a_World, a_Dt)
	-- Report food stats, if switched on:
	local Tick = a_World:GetWorldAge();
	if (not(g_ShowFoodStats) or (math.mod(Tick, 10) ~= 0)) then
		return false;
	end
	a_World:ForEachPlayer(
		function(a_Player)
			a_Player:SendMessage(
				tostring(Tick / 10) .. 
				" > FS: fl " .. a_Player:GetFoodLevel() .. 
				"; sat " .. a_Player:GetFoodSaturationLevel() ..
				"; exh " .. a_Player:GetFoodExhaustionLevel()
			);
		end
	);
end





function OnChat(a_Player, a_Message)
	return false, "blabla " .. a_Message;
end





function OnPlayerRightClickingEntity(a_Player, a_Entity)
	LOG("Player " .. a_Player:GetName() .. " right-clicking entity ID " .. a_Entity:GetUniqueID() .. ", a " .. a_Entity:GetClass());
	return false;
end





function OnPluginsLoaded()
	LOG("All plugins loaded");
end





function OnChunkGenerated(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	-- Get the topmost block coord:
	local Height = a_ChunkDesc:GetHeight(0, 0);
	
	-- Create a sign there:
	a_ChunkDesc:SetBlockTypeMeta(0, Height + 1, 0, E_BLOCK_SIGN_POST, 0);
	local BlockEntity = a_ChunkDesc:GetBlockEntity(0, Height + 1, 0);
	if (BlockEntity ~= nil) then
		local SignEntity = tolua.cast(BlockEntity, "cSignEntity");
		SignEntity:SetLines("Chunk:", tonumber(a_ChunkX) .. ", " .. tonumber(a_ChunkZ), "", "(Debuggers)");
	end

	-- Update the heightmap:
	a_ChunkDesc:SetHeight(0, 0, Height + 1);
end





-- Function "round" copied from http://lua-users.org/wiki/SimpleRound
function round(num, idp)
	local mult = 10^(idp or 0)
	if num >= 0 then return math.floor(num * mult + 0.5) / mult
	else return math.ceil(num * mult - 0.5) / mult end
end





function HandleNickCmd(Split, Player)
	if (Split[2] == nil) then
		Player:SendMessage("Usage: /nick [CustomName]");
		return true;
	end

	Player:SetCustomName(Split[2]);
	Player:SendMessageSuccess("Custom name setted to " .. Player:GetCustomName() .. "!")
	return true
end





function HandleListEntitiesCmd(Split, Player)
	local NumEntities = 0;
	
	local ListEntity = function(Entity)
		if (Entity:IsDestroyed()) then
			-- The entity has already been destroyed, don't list it
			return false;
		end;
		local cls = Entity:GetClass();
		Player:SendMessage("  " .. Entity:GetUniqueID() .. ": " .. cls .. "   {" .. round(Entity:GetPosX(), 2) .. ", " .. round(Entity:GetPosY(), 2) .. ", " .. round(Entity:GetPosZ(), 2) .."}");
		if (cls == "cPickup") then
			local Pickup = Entity;
			tolua.cast(Pickup, "cPickup");
			Player:SendMessage("    Age: " .. Pickup:GetAge() .. ", IsCollected: " .. tostring(Pickup:IsCollected()));
		end
		NumEntities = NumEntities + 1;
	end
	
	Player:SendMessage("Listing all entities...");
	Player:GetWorld():ForEachEntity(ListEntity);
	Player:SendMessage("List finished, " .. NumEntities .. " entities listed");
	return true;
end





function HandleKillEntitiesCmd(Split, Player)
	local NumEntities = 0;
	
	local KillEntity = function(Entity)
		-- kill everything except for players:
		if (Entity:GetEntityType() ~= cEntity.etPlayer) then
			Entity:Destroy();
			NumEntities = NumEntities + 1;
		end;
	end
	
	Player:SendMessage("Killing all entities...");
	Player:GetWorld():ForEachEntity(KillEntity);
	Player:SendMessage("Killed " .. NumEntities .. " entities.");
	return true;
end





function HandleWoolCmd(Split, Player)
	local Wool = cItem(E_BLOCK_WOOL, 1, E_META_WOOL_BLUE);
	Player:GetInventory():SetArmorSlot(0, Wool);
	Player:GetInventory():SetArmorSlot(1, Wool);
	Player:GetInventory():SetArmorSlot(2, Wool);
	Player:GetInventory():SetArmorSlot(3, Wool);
	Player:SendMessage("You have been bluewooled :)");
	return true;
end





function HandleTestWndCmd(a_Split, a_Player)
	local WindowType  = cWindow.wtHopper;
	local WindowSizeX = 5;
	local WindowSizeY = 1;
	if (#a_Split == 4) then
		WindowType  = tonumber(a_Split[2]);
		WindowSizeX = tonumber(a_Split[3]);
		WindowSizeY = tonumber(a_Split[4]);
	elseif (#a_Split ~= 1) then
		a_Player:SendMessage("Usage: /testwnd [WindowType WindowSizeX WindowSizeY]");
		return true;
	end
	
	-- Test out the OnClosing callback's ability to refuse to close the window
	local attempt = 1;
	local OnClosing = function(Window, Player, CanRefuse)
		Player:SendMessage("Window closing attempt #" .. attempt .. "; CanRefuse = " .. tostring(CanRefuse));
		attempt = attempt + 1;
		return CanRefuse and (attempt <= 3);  -- refuse twice, then allow, unless CanRefuse is set to true
	end
	
	-- Log the slot changes
	local OnSlotChanged = function(Window, SlotNum)
		LOG("Window \"" .. Window:GetWindowTitle() .. "\" slot " .. SlotNum .. " changed.");
	end
	
	local Window = cLuaWindow(WindowType, WindowSizeX, WindowSizeY, "TestWnd");
	local Item2 = cItem(E_ITEM_DIAMOND_SWORD, 1, 0, "1=1");
	local Item3 = cItem(E_ITEM_DIAMOND_SHOVEL);
	Item3.m_Enchantments:SetLevel(cEnchantments.enchUnbreaking, 4);
	local Item4 = cItem(Item3);  -- Copy
	Item4.m_Enchantments:SetLevel(cEnchantments.enchEfficiency, 3);  -- Add enchantment
	Item4.m_Enchantments:SetLevel(cEnchantments.enchUnbreaking, 5);  -- Overwrite existing level
	local Item5 = cItem(E_ITEM_DIAMOND_CHESTPLATE, 1, 0, "thorns=1;unbreaking=3");
	Window:SetSlot(a_Player, 0, cItem(E_ITEM_DIAMOND, 64));
	Window:SetSlot(a_Player, 1, Item2);
	Window:SetSlot(a_Player, 2, Item3);
	Window:SetSlot(a_Player, 3, Item4);
	Window:SetSlot(a_Player, 4, Item5);
	Window:SetOnClosing(OnClosing);
	Window:SetOnSlotChanged(OnSlotChanged);
	
	a_Player:OpenWindow(Window);
	
	-- To make sure that the object has the correct life-management in Lua,
	-- let's garbage-collect in the following few ticks
	GCOnTick = 10;
	
	return true;
end





function HandleGCCmd(a_Split, a_Player)
	collectgarbage();
	return true;
end






function HandleFastCmd(a_Split, a_Player)
	if (a_Player:GetNormalMaxSpeed() <= 0.11) then
		-- The player has normal speed, set double speed:
		a_Player:SetNormalMaxSpeed(0.2);
		a_Player:SendMessage("You are now fast");
	else
		-- The player has fast speed, set normal speed:
		a_Player:SetNormalMaxSpeed(0.1);
		a_Player:SendMessage("Back to normal speed");
	end
	return true;
end





function HandleDashCmd(a_Split, a_Player)
	if (a_Player:GetSprintingMaxSpeed() <= 0.14) then
		-- The player has normal sprinting speed, set double Sprintingspeed:
		a_Player:SetSprintingMaxSpeed(0.4);
		a_Player:SendMessage("You can now sprint very fast");
	else
		-- The player has fast sprinting speed, set normal sprinting speed:
		a_Player:SetSprintingMaxSpeed(0.13);
		a_Player:SendMessage("Back to normal sprinting");
	end
	return true;
end;





function HandleHungerCmd(a_Split, a_Player)
	a_Player:SendMessage("FoodLevel: " .. a_Player:GetFoodLevel());
	a_Player:SendMessage("FoodSaturationLevel: " .. a_Player:GetFoodSaturationLevel());
	a_Player:SendMessage("FoodTickTimer: " .. a_Player:GetFoodTickTimer());
	a_Player:SendMessage("FoodExhaustionLevel: " .. a_Player:GetFoodExhaustionLevel());
	a_Player:SendMessage("FoodPoisonedTicksRemaining: " .. a_Player:GetFoodPoisonedTicksRemaining());
	return true;
end





function HandlePoisonCmd(a_Split, a_Player)
	a_Player:FoodPoison(15 * 20);
	return true;
end





function HandleStarveCmd(a_Split, a_Player)
	a_Player:SetFoodLevel(0);
	a_Player:SendMessage("You are now starving");
	return true;
end





function HandleFoodLevelCmd(a_Split, a_Player)
	if (#a_Split ~= 2) then
		a_Player:SendMessage("Missing an argument: the food level to set");
		return true;
	end
	
	a_Player:SetFoodLevel(tonumber(a_Split[2]));
	a_Player:SetFoodSaturationLevel(5);
	a_Player:SetFoodExhaustionLevel(0);
	a_Player:SendMessage(
		"Food level set to " .. a_Player:GetFoodLevel() .. 
		", saturation reset to " .. a_Player:GetFoodSaturationLevel() ..
		" and exhaustion reset to " .. a_Player:GetFoodExhaustionLevel()
	);
	return true;
end





function HandleSpideyCmd(a_Split, a_Player)
	-- Place a line of cobwebs from the player's eyes until non-air block, in the line-of-sight of the player
	local World = a_Player:GetWorld();

	local Callbacks = {
		OnNextBlock = function(a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta)
			if (a_BlockType ~= E_BLOCK_AIR) then
				-- abort the trace
				return true;
			end
			World:SetBlock(a_BlockX, a_BlockY, a_BlockZ, E_BLOCK_COBWEB, 0);
		end
	};
	
	local EyePos = a_Player:GetEyePosition();
	local LookVector = a_Player:GetLookVector();
	LookVector:Normalize();
	
	-- Start cca 2 blocks away from the eyes
	local Start = EyePos + LookVector + LookVector;
	local End = EyePos + LookVector * 50;
	
	cLineBlockTracer.Trace(World, Callbacks, Start.x, Start.y, Start.z, End.x, End.y, End.z);
	
	return true;
end





function HandleEnchCmd(a_Split, a_Player)
	local Wnd = cLuaWindow(cWindow.wtEnchantment, 1, 1, "Ench");
	a_Player:OpenWindow(Wnd);
	Wnd:SetProperty(0, 10);
	Wnd:SetProperty(1, 15);
	Wnd:SetProperty(2, 25);
	return true;
end





function HandleFoodStatsCmd(a_Split, a_Player)
	g_ShowFoodStats = not(g_ShowFoodStats);
	return true;
end





function HandleArrowCmd(a_Split, a_Player)
	local World = a_Player:GetWorld();
	local Pos = a_Player:GetEyePosition();
	local Speed = a_Player:GetLookVector();
	Speed:Normalize();
	Pos = Pos + Speed;
	
	World:CreateProjectile(Pos.x, Pos.y, Pos.z, cProjectileEntity.pkArrow, a_Player, Speed * 10);
	return true;
end





function HandleFireballCmd(a_Split, a_Player)
	local World = a_Player:GetWorld();
	local Pos = a_Player:GetEyePosition();
	local Speed = a_Player:GetLookVector();
	Speed:Normalize();
	Pos = Pos + Speed * 2;
	
	World:CreateProjectile(Pos.x, Pos.y, Pos.z, cProjectileEntity.pkGhastFireball, a_Player, Speed * 10);
	return true;
end




function HandleAddExperience(a_Split, a_Player)
	a_Player:DeltaExperience(200);

	return true;
end





function HandleRemoveXp(a_Split, a_Player)
	a_Player:SetCurrentExperience(0);
	
	return true;
end





function HandleFill(a_Split, a_Player)
	local World = a_Player:GetWorld();
	local ChunkX = a_Player:GetChunkX();
	local ChunkZ = a_Player:GetChunkZ();
	World:ForEachBlockEntityInChunk(ChunkX, ChunkZ,
		function(a_BlockEntity)
			local BlockType = a_BlockEntity:GetBlockType();
			if (
				(BlockType == E_BLOCK_CHEST) or
				(BlockType == E_BLOCK_DISPENSER) or
				(BlockType == E_BLOCK_DROPPER) or
				(BlockType == E_BLOCK_FURNACE) or
				(BlockType == E_BLOCK_HOPPER)
			) then
				-- This block entity has items (inherits from cBlockEntityWithItems), fill it:
				-- Note that we're not touching lit furnaces, don't wanna mess them up
				local EntityWithItems = tolua.cast(a_BlockEntity, "cBlockEntityWithItems");
				local ItemGrid = EntityWithItems:GetContents();
				local NumSlots = ItemGrid:GetNumSlots();
				local ItemToSet = cItem(E_ITEM_GOLD_NUGGET);
				for i = 0, NumSlots - 1 do
					if (ItemGrid:GetSlot(i):IsEmpty()) then
						ItemGrid:SetSlot(i, ItemToSet);
					end
				end
			end
		end
	);
	return true;
end





function HandleFurnaceRecipe(a_Split, a_Player)
	local HeldItem = a_Player:GetEquippedItem();
	local Out, NumTicks, In = cRoot:GetFurnaceRecipe(HeldItem);
	if (Out ~= nil) then
		a_Player:SendMessage(
			"Furnace turns " .. ItemToFullString(In) ..
			" to " .. ItemToFullString(Out) ..
			" in " .. NumTicks .. " ticks (" ..
			tostring(NumTicks / 20) .. " seconds)."
		);
	else
		a_Player:SendMessage("There is no furnace recipe that would smelt " .. ItemToString(HeldItem));
	end
	return true;
end





function HandleFurnaceFuel(a_Split, a_Player)
	local HeldItem = a_Player:GetEquippedItem();
	local NumTicks = cRoot:GetFurnaceFuelBurnTime(HeldItem);
	if (NumTicks > 0) then
		a_Player:SendMessage(
			ItemToFullString(HeldItem) .. " would power a furnace for " .. NumTicks ..
			" ticks (" .. tostring(NumTicks / 20) .. " seconds)."
		);
	else
		a_Player:SendMessage(ItemToString(HeldItem) .. " will not power furnaces.");
	end
	return true;
end





function HandleSched(a_Split, a_Player)
	local World = a_Player:GetWorld()
	
	-- Schedule a broadcast of a countdown message:
	for i = 1, 10 do
		World:ScheduleTask(i * 20,
			function(a_World)
				a_World:BroadcastChat("Countdown: " .. 11 - i)
			end
		)
	end
	
	-- Schedule a broadcast of the final message and a note to the originating player
	-- Note that we CANNOT use the a_Player in the callback - what if the player disconnected?
	-- Therefore we store the player's EntityID
	local PlayerID = a_Player:GetUniqueID()
	World:ScheduleTask(220,
		function(a_World)
			a_World:BroadcastChat("Countdown: BOOM")
			a_World:DoWithEntityByID(PlayerID,
				function(a_Entity)
					if (a_Entity:IsPlayer()) then
						-- Although unlikely, it is possible that this player is not the originating player
						-- However, I leave this as an excercise to you to fix this "bug"
						local Player = tolua.cast(a_Entity, "cPlayer")
						Player:SendMessage("Countdown finished")
					end
				end
			)
		end
	)
	
	return true
end





function HandleRMItem(a_Split, a_Player)
	-- Check params:
	if (a_Split[2] == nil) then
		a_Player:SendMessage("Usage: /rmitem <Item> [Count]")
		return true
	end

	-- Parse the item type:
	local Item = cItem()
	if (not StringToItem(a_Split[2], Item)) then
		a_Player:SendMessageFailure(a_Split[2] .. " isn't a valid item")
		return true
	end

	-- Parse the optional item count
	if (a_Split[3] ~= nil) then
		local Count = tonumber(a_Split[3])
		if (Count == nil) then
			a_Player:SendMessageFailure(a_Split[3] .. " isn't a valid number")
			return true
		end

		Item.m_ItemCount = Count
	end

	-- Remove the item:
	local NumRemovedItems = a_Player:GetInventory():RemoveItem(Item)
	a_Player:SendMessageSuccess("Removed " .. NumRemovedItems .. " Items!")
	return true
end





function HandleRequest_Debuggers(a_Request)
	local FolderContents = cFile:GetFolderContents("./");
	return "<p>The following objects have been returned by cFile:GetFolderContents():<ul><li>" .. table.concat(FolderContents, "</li><li>") .. "</li></ul></p>";
end





local g_Counter = 0
local g_JavaScript =
[[
<script>
function createXHR()
{
	var request = false;
	try {
		request = new ActiveXObject('Msxml2.XMLHTTP');
	}
	catch (err2)
	{
		try
		{
			request = new ActiveXObject('Microsoft.XMLHTTP');
		}
		catch (err3)
		{
			try
			{
				request = new XMLHttpRequest();
			}
			catch (err1)
			{
				request = false;
			}
		}
	}
	return request;
}

function RefreshCounter()
{
	var xhr = createXHR();
	xhr.onreadystatechange = function()
	{
		if (xhr.readyState == 4)
		{
			document.getElementById("cnt").innerHTML = xhr.responseText;
		}
	};
	xhr.open("POST", "/~webadmin/Debuggers/StressTest", true);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send("counter=true");
}

setInterval(RefreshCounter, 10)
</script>
]]

function HandleRequest_StressTest(a_Request)
	if (a_Request.PostParams["counter"]) then
		g_Counter = g_Counter + 1
		return tostring(g_Counter)
	end
	return g_JavaScript .. "<p>The counter below should be reloading as fast as possible</p><div id='cnt'>0</div>"
end





function OnPluginMessage(a_Client, a_Channel, a_Message)
	LOGINFO("Received a plugin message from client " .. a_Client:GetUsername() .. ": channel '" .. a_Channel .. "', message '" .. a_Message .. "'");
	
	if (a_Channel == "REGISTER") then
		if (a_Message:find("WECUI")) then
			-- The client has WorldEditCUI mod installed, test the comm by sending a few WECUI messages:
			--[[
			WECUI messages have the following generic format:
			<shape>|<params>
			If shape is p (cuboid selection), the params are sent individually for each corner click and have the following format:
			<point-index>|<x>|<y>|<z>|<volume>
			point-index is 0 or 1 (lclk / rclk)
			volume is the 3D volume of the current cuboid selected (all three coords' deltas multiplied), including the edge blocks; -1 if N/A
			--]]
			-- Select a 51 * 51 * 51 block cuboid:
			a_Client:SendPluginMessage("WECUI", "p|0|50|50|50|-1");
			a_Client:SendPluginMessage("WECUI", "p|1|100|100|100|132651");  -- 132651 = 51 * 51 * 51
		end
	end
end





function HandleChunkStay(a_Split, a_Player)
	-- As an example of using ChunkStay, this call will load 3x3 chunks around the specified chunk coords,
	-- then build an obsidian pillar in the middle of each one.
	-- Once complete, the player will be teleported to the middle pillar
	
	if (#a_Split ~= 3) then
		a_Player:SendMessageInfo("Usage: /cs <ChunkX> <ChunkZ>")
		return true
	end
	
	local ChunkX = tonumber(a_Split[2])
	local ChunkZ = tonumber(a_Split[3])
	if ((ChunkX == nil) or (ChunkZ == nil)) then
		a_Player:SendMessageFailure("Invalid chunk coords.")
		return true
	end
	
	local World = a_Player:GetWorld()
	local PlayerID = a_Player:GetUniqueID()
	a_Player:SendMessageInfo("Loading chunks, stand by...");
	
	-- Set the wanted chunks:
	local Chunks = {}
	for z = -1, 1 do for x = -1, 1 do
		table.insert(Chunks, {ChunkX + x, ChunkZ + z})
	end end
	
	-- The function that is called when all chunks are available
	-- Will perform the actual action with all those chunks
	-- Note that the player needs to be referenced using their EntityID - in case they disconnect before the chunks load
	local OnAllChunksAvailable = function()
		LOGINFO("ChunkStay all chunks now available")
		-- Build something on the neighboring chunks, to verify:
		for z = -1, 1 do for x = -1, 1 do
			local BlockX = (ChunkX + x) * 16 + 8
			local BlockZ = (ChunkZ + z) * 16 + 8
			for y = 20, 80 do
				World:SetBlock(BlockX, y, BlockZ, E_BLOCK_OBSIDIAN, 0)
			end
		end end
		
		-- Teleport the player there for visual inspection:
		World:DoWithEntityByID(PlayerID,
			function (a_CallbackPlayer)
				a_CallbackPlayer:TeleportToCoords(ChunkX * 16 + 8, 85, ChunkZ * 16 + 8)
				a_CallbackPlayer:SendMessageSuccess("ChunkStay fully available")
			end
		)
	end
	
	-- This function will be called for each chunk that is made available
	-- Note that the player needs to be referenced using their EntityID - in case they disconnect before the chunks load
	local OnChunkAvailable = function(a_ChunkX, a_ChunkZ)
		LOGINFO("ChunkStay now has chunk [" .. a_ChunkX .. ", " .. a_ChunkZ .. "]")
		World:DoWithEntityByID(PlayerID,
			function (a_CallbackPlayer)
				a_CallbackPlayer:SendMessageInfo("ChunkStay now has chunk [" .. a_ChunkX .. ", " .. a_ChunkZ .. "]")
			end
		)
	end
	
	-- Process the ChunkStay:
	World:ChunkStay(Chunks, OnChunkAvailable, OnAllChunksAvailable)
	return true
end





function HandleCompo(a_Split, a_Player)
	-- Send one composite message to self:
	local msg = cCompositeChat()
	msg:AddTextPart("Hello! ", "b@e")  -- bold yellow
	msg:AddUrlPart("MCServer", "http://mc-server.org")
	msg:AddTextPart(" rules! ")
	msg:AddRunCommandPart("Set morning", "/time set 0")
	a_Player:SendMessage(msg)
	
	-- Broadcast another one to the world:
	local msg2 = cCompositeChat()
	msg2:AddSuggestCommandPart(a_Player:GetName(), "/tell " .. a_Player:GetName() .. " ")
	msg2:AddTextPart(" knows how to use cCompositeChat!");
	a_Player:GetWorld():BroadcastChat(msg2)
	
	return true
end





function HandleSetBiome(a_Split, a_Player)
	local Biome = biJungle
	local Size = 20
	local SplitSize = #a_Split
	if (SplitSize > 3) then
		a_Player:SendMessage("Too many parameters. Usage: " .. a_Split[1] .. " <BiomeType>")
		return true
	end

	if (SplitSize >= 2) then
		Biome = StringToBiome(a_Split[2])
		if (Biome == biInvalidBiome) then
			a_Player:SendMessage("Unknown biome: '" .. a_Split[2] .. "'. Command ignored.")
			return true
		end
	end
	if (SplitSize >= 3) then
		Size = tostring(a_Split[3])
		if (Size == nil) then
			a_Player:SendMessage("Unknown size: '" .. a_Split[3] .. "'. Command ignored.")
			return true
		end
	end
	
	local BlockX = math.floor(a_Player:GetPosX())
	local BlockZ = math.floor(a_Player:GetPosZ())
	a_Player:GetWorld():SetAreaBiome(BlockX - Size, BlockX + Size, BlockZ - Size, BlockZ + Size, Biome)
	a_Player:SendMessage(
		"Blocks {" .. (BlockX - Size) .. ", " .. (BlockZ - Size) ..
		"} - {" .. (BlockX + Size) .. ", " .. (BlockZ + Size) ..
		"} set to biome #" .. tostring(Biome) .. "."
	)
	return true
end





function HandleWESel(a_Split, a_Player)
	-- Check if the selection is a cuboid:
	local IsCuboid = cPluginManager:CallPlugin("WorldEdit", "IsPlayerSelectionCuboid")
	if (IsCuboid == nil) then
		a_Player:SendMessage(cCompositeChat():SetMessageType(mtFailure):AddTextPart("Cannot adjust selection, WorldEdit is not loaded"))
		return true
	elseif (IsCuboid == false) then
		a_Player:SendMessage(cCompositeChat():SetMessageType(mtFailure):AddTextPart("Cannot adjust selection, the selection is not a cuboid"))
		return true
	end
	
	-- Get the selection:
	local SelCuboid = cCuboid()
	local IsSuccess = cPluginManager:CallPlugin("WorldEdit", "GetPlayerCuboidSelection", a_Player, SelCuboid)
	if not(IsSuccess) then
		a_Player:SendMessage(cCompositeChat():SetMessageType(mtFailure):AddTextPart("Cannot adjust selection, WorldEdit reported failure while getting current selection"))
		return true
	end
	
	-- Adjust the selection:
	local NumBlocks = tonumber(a_Split[2] or "1") or 1
	SelCuboid:Expand(NumBlocks, NumBlocks, 0, 0, NumBlocks, NumBlocks)
	
	-- Set the selection:
	IsSuccess = cPluginManager:CallPlugin("WorldEdit", "SetPlayerCuboidSelection", a_Player, SelCuboid)
	if not(IsSuccess) then
		a_Player:SendMessage(cCompositeChat():SetMessageType(mtFailure):AddTextPart("Cannot adjust selection, WorldEdit reported failure while setting new selection"))
		return true
	end
	a_Player:SendMessage(cCompositeChat():SetMessageType(mtInformation):AddTextPart("Successfully adjusted the selection by " .. NumBlocks .. " block(s)"))
	return true
end





function OnPlayerJoined(a_Player)
	-- Test composite chat chaining:
	a_Player:SendMessage(cCompositeChat()
		:AddTextPart("Hello, ")
		:AddUrlPart(a_Player:GetName(), "http://www.mc-server.org", "u@2")
		:AddSuggestCommandPart(", and welcome.", "/help", "u")
		:AddRunCommandPart(" SetDay", "/time set 0")
	)
end





function OnProjectileHitBlock(a_Projectile, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_BlockHitPos)
	-- Test projectile hooks by setting the blocks they hit on fire:
	local BlockX, BlockY, BlockZ = AddFaceDirection(a_BlockX, a_BlockY, a_BlockZ, a_BlockFace)
	local World = a_Projectile:GetWorld()
	
	World:SetBlock(BlockX, BlockY, BlockZ, E_BLOCK_FIRE, 0)
end





function OnChunkUnloading(a_World, a_ChunkX, a_ChunkZ)
	-- Do not let chunk [0, 0] unload, so that it continues ticking [cWorld:SetChunkAlwaysTicked() test]
	if ((a_ChunkX == 0) and (a_ChunkZ == 0)) then
		return true
	end
end





function OnWorldStarted(a_World)
	-- Make the chunk [0, 0] in every world keep ticking [cWorld:SetChunkAlwaysTicked() test]
	a_World:ChunkStay({{0, 0}}, nil,
		function()
			-- The chunk is loaded, make it always tick:
			a_World:SetChunkAlwaysTicked(0, 0, true)
		end
	)
end





function OnProjectileHitBlock(a_ProjectileEntity, a_BlockX, a_BlockY, a_BlockZ, a_BlockFace, a_BlockHitPos)
	-- This simple test is for testing issue #1326 - simply declaring this hook would crash the server upon call
	LOG("Projectile hit block")
	LOG("  Projectile EntityID: " .. a_ProjectileEntity:GetUniqueID())
	LOG("  Block: {" .. a_BlockX .. ", " .. a_BlockY .. ", " .. a_BlockZ .. "}, face " .. a_BlockFace)
	LOG("  HitPos: {" .. a_BlockHitPos.x .. ", " .. a_BlockHitPos.y .. ", " .. a_BlockHitPos.z .. "}")
end





local PossibleItems =
{
	cItem(E_ITEM_DIAMOND),
	cItem(E_ITEM_GOLD),
	cItem(E_ITEM_IRON),
	cItem(E_ITEM_DYE, 1, E_META_DYE_BLUE),  -- Lapis lazuli
	cItem(E_ITEM_COAL),
}





function HandlePickups(a_Split, a_Player)
	local PlayerX = a_Player:GetPosX()
	local PlayerY = a_Player:GetPosY()
	local PlayerZ = a_Player:GetPosZ()
	local World = a_Player:GetWorld()
	local Range = 12
	for x = 0, Range do for z = 0, Range do
		local px = PlayerX + x - Range / 2
		local pz = PlayerZ + z - Range / 2
		local Items = cItems()
		Items:Add(PossibleItems[math.random(#PossibleItems)])
		World:SpawnItemPickups(Items, px, PlayerY, pz, 0)
	end end  -- for z, for x
	return true
end





function HandlePlugMsg(a_Split, a_Player)
	local ch = a_Player:GetClientHandle()
	ch:SendPluginMessage("TestCh", "some\0string\1with\2funny\3chars")
	return true
end





function HandlePoof(a_Split, a_Player)
	local PlayerPos = Vector3d(a_Player:GetPosition())  -- Create a copy of the position
	PlayerPos.y = PlayerPos.y - 1
	local Box = cBoundingBox(PlayerPos, 4, 2)
	local NumEntities = 0
	a_Player:GetWorld():ForEachEntityInBox(Box,
		function (a_Entity)
			if not(a_Entity:IsPlayer()) then
				local AddSpeed = a_Entity:GetPosition() - PlayerPos  -- Speed away from the player
				a_Entity:AddSpeed(AddSpeed * 32 / (AddSpeed:SqrLength() + 1))  -- The further away, the less speed to add
				NumEntities = NumEntities + 1
			end
		end
	)
	a_Player:SendMessage("Poof! (" .. NumEntities .. " entities)")
	return true
end





-- List of hashing functions to test:
local HashFunctions =
{
	{"md5", md5 },
	{"cCryptoHash.md5", cCryptoHash.md5 },
	{"cCryptoHash.md5HexString", cCryptoHash.md5HexString },
	{"cCryptoHash.sha1", cCryptoHash.sha1 },
	{"cCryptoHash.sha1HexString", cCryptoHash.sha1HexString },
}

-- List of strings to try hashing:
local HashExamples =
{
	"",
	"\0",
	"test",
}

function HandleConsoleHash(a_Split)
	for _, str in ipairs(HashExamples) do
		LOG("Hashing string \"" .. str .. "\":")
		for _, hash in ipairs(HashFunctions) do
			if not(hash[2]) then
				LOG("Hash function " .. hash[1] .. " doesn't exist in the API!")
			else
				LOG(hash[1] .. "() = " .. hash[2](str))
			end
		end  -- for hash - HashFunctions[]
	end  -- for str - HashExamples[]
	return true
end





--- Monitors the state of the "inh" entity-spawning hook
-- if false, the hook is installed before the "inh" command processing
local isInhHookInstalled = false

function HandleConsoleInh(a_Split, a_FullCmd)
	-- Check the param:
	local kindStr = a_Split[2] or "pkArrow"
	local kind = cProjectileEntity[kindStr]
	if (kind == nil) then
		return true, "There's no projectile kind '" .. kindStr .. "'."
	end

	-- Get the world to test in:
	local world = cRoot:Get():GetDefaultWorld()
	if (world == nil) then
		return true, "Cannot test inheritance, no default world"
	end
	
	-- Install the hook, if needed:
	if not(isInhHookInstalled) then
		cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY,
			function (a_CBWorld, a_CBEntity)
				LOG("New entity is spawning:")
				LOG("  Lua type:        '" .. type(a_CBEntity)           .. "'")
				LOG("  ToLua type:      '" .. tolua.type(a_CBEntity)     .. "'")
				LOG("  GetEntityType(): '" .. a_CBEntity:GetEntityType() .. "'")
				LOG("  GetClass():      '" .. a_CBEntity:GetClass()      .. "'")
			end
		)
		isInhHookInstalled = true
	end
	
	-- Create the projectile:
	LOG("Creating a " .. kindStr .. " projectile in world " .. world:GetName() .. "...")
	local msg
	world:ChunkStay({{0, 0}},
		nil,
		function ()
			-- Create a projectile at {8, 100, 8}:
			local entityID = world:CreateProjectile(8, 100, 8, kind, nil, nil)
			if (entityID < 0) then
				msg = "Cannot test inheritance, projectile creation failed."
				return
			end
			LOG("Entity created, ID #" .. entityID)
			
			-- Call a function on the newly created entity:
			local hasExecutedCallback = false
			world:DoWithEntityByID(
				entityID,
				function (a_CBEntity)
					LOG("Projectile created and found using the DoWithEntityByID() callback")
					LOG("Lua type:        '" .. type(a_CBEntity)           .. "'")
					LOG("ToLua type:      '" .. tolua.type(a_CBEntity)     .. "'")
					LOG("GetEntityType(): '" .. a_CBEntity:GetEntityType() .. "'")
					LOG("GetClass():      '" .. a_CBEntity:GetClass()      .. "'")
					hasExecutedCallback = true
				end
			)
			if not(hasExecutedCallback) then
				msg = "The callback failed to execute"
				return
			end
			
			msg = "Inheritance test finished"
		end
	)
	
	return true, msg
end





function HandleConsoleLoadChunk(a_Split)
	-- Check params:
	local numParams = #a_Split
	if (numParams ~= 3) and (numParams ~= 4) then
		return true, "Usage: " .. a_Split[1] .. " <ChunkX> <ChunkZ> [<WorldName>]"
	end
	
	-- Get the chunk coords:
	local chunkX = tonumber(a_Split[2])
	if (chunkX == nil) then
		return true, "Not a number: '" .. a_Split[2] .. "'"
	end
	local chunkZ = tonumber(a_Split[3])
	if (chunkZ == nil) then
		return true, "Not a number: '" .. a_Split[3] .. "'"
	end

	-- Get the world:
	local world
	if (a_Split[4] == nil) then
		world = cRoot:Get():GetDefaultWorld()
	else
		world = cRoot:Get():GetWorld(a_Split[4])
		if (world == nil) then
			return true, "There's no world named '" .. a_Split[4] .. "'."
		end
	end
	
	-- Queue a ChunkStay for the chunk, log a message when the chunk is loaded:
	world:ChunkStay({{chunkX, chunkZ}}, nil,
		function()
			LOG("Chunk [" .. chunkX .. ", " .. chunkZ .. "] is loaded")
		end
	)
	return true
end





function HandleConsolePrepareChunk(a_Split)
	-- Check params:
	local numParams = #a_Split
	if (numParams ~= 3) and (numParams ~= 4) then
		return true, "Usage: " .. a_Split[1] .. " <ChunkX> <ChunkZ> [<WorldName>]"
	end
	
	-- Get the chunk coords:
	local chunkX = tonumber(a_Split[2])
	if (chunkX == nil) then
		return true, "Not a number: '" .. a_Split[2] .. "'"
	end
	local chunkZ = tonumber(a_Split[3])
	if (chunkZ == nil) then
		return true, "Not a number: '" .. a_Split[3] .. "'"
	end

	-- Get the world:
	local world
	if (a_Split[4] == nil) then
		world = cRoot:Get():GetDefaultWorld()
	else
		world = cRoot:Get():GetWorld(a_Split[4])
		if (world == nil) then
			return true, "There's no world named '" .. a_Split[4] .. "'."
		end
	end
	
	-- Queue the chunk for preparing, log a message when prepared:
	world:PrepareChunk(chunkX, chunkZ,
		function(a_CBChunkX, a_CBChunkZ)
			LOG("Chunk [" .. chunkX .. ", " .. chunkZ .. "] has been prepared")
		end
	)
	return true
end





function HandleConsoleSchedule(a_Split)
	local prev = os.clock()
	LOG("Scheduling a task for 2 seconds in the future (current os.clock is " .. prev .. ")")
	cRoot:Get():GetDefaultWorld():ScheduleTask(40,
		function ()
			local current = os.clock()
			local diff = current - prev
			LOG("Scheduled function is called. Current os.clock is " .. current .. ", difference is " .. diff .. ")")
		end
	)
	return true, "Task scheduled"
end





--- Returns the square of the distance from the specified point to the specified line
local function SqDistPtFromLine(x, y, x1, y1, x2, y2)
	local dx = x - x1
	local dy = y - y1
	local px = x2 - x1
	local py = y2 - y1
	local ss = px * dx + py * dy
	local ds = px * px + py * py

	if (ss < 0) then
		-- Return sqdistance from point 1
		return dx * dx + dy * dy
	end
	if (ss > ds) then
		-- Return sqdistance from point 2
		return ((x2 - x) * (x2 - x) + (y2 - y) * (y2 - y))
	end

	-- Return sqdistance from the line
	if ((px * px + py * py) == 0) then
		return dx * dx + dy * dy
	else
		return (py * dx - px * dy) * (py * dx - px * dy) / (px * px + py * py)
	end
end





function HandleConsoleTestTracer(a_Split, a_EntireCmd)
	-- Check required params:
	if not(a_Split[7]) then
		return true, "Usage: " .. a_Split[1] .. " <x1> <y1> <z1> <x2> <y2> <z2> [<WorldName>]"
	end
	local Coords = {}
	for i = 1, 6 do
		local v = tonumber(a_Split[i + 1])
		if not(v) then
			return true, "Parameter " .. (i + 1) .. " (" .. tostring(a_Split[i + 1]) .. ") not a number "
		end
		Coords[i] = v
	end
	
	-- Get the world in which to test:
	local World
	if (a_Split[8]) then
		World = cRoot:GetWorld(a_Split[2])
	else
		World = cRoot:Get():GetDefaultWorld()
	end
	if not(World) then
		return true, "No such world"
	end
	
	-- Define the callbacks to use for tracing:
	local Callbacks =
	{
		OnNextBlock = function(a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta, a_EntryFace)
			LOG(string.format("{%d, %d, %d}: %s", a_BlockX, a_BlockY, a_BlockZ, ItemToString(cItem(a_BlockType, 1, a_BlockMeta))))
		end,
		OnNextBlockNoData = function(a_BlockX, a_BlockY, a_BlockZ, a_EntryFace)
			LOG(string.format("{%d, %d, %d} (no data)", a_BlockX, a_BlockY, a_BlockZ))
		end,
		OnNoChunk = function()
			LOG("Chunk not loaded")
		end,
		OnNoMoreHits = function()
			LOG("Trace finished")
		end,
		OnOutOfWorld = function()
			LOG("Out of world")
		end,
		OnIntoWorld = function()
			LOG("Into world")
		end,
	}

	-- Approximate the chunks needed for the trace by iterating over all chunks and measuring their center's distance from the traced line
	local Chunks = {}
	local sx = math.floor(Coords[1] / 16)
	local sz = math.floor(Coords[3] / 16)
	local ex = math.floor(Coords[4] / 16)
	local ez = math.floor(Coords[6] / 16)
	local sgnx = (sx < ex) and 1 or -1
	local sgnz = (sz < ez) and 1 or -1
	for z = sz, ez, sgnz do
		local ChunkCenterZ = z * 16 + 8
		for x = sx, ex, sgnx do
			local ChunkCenterX = x * 16 + 8
			local sqdist = SqDistPtFromLine(ChunkCenterX, ChunkCenterZ, Coords[1], Coords[3], Coords[4], Coords[6])
			if (sqdist <= 128) then
				table.insert(Chunks, {x, z})
			end
		end
	end
	
	-- Load the chunks and do the trace once loaded:
	World:ChunkStay(Chunks,
		nil,
		function()
			cLineBlockTracer:Trace(World, Callbacks, Coords[1], Coords[2], Coords[3], Coords[4], Coords[5], Coords[6])
		end
	)
	return true
end





function HandleConsoleBBox(a_Split)
	local bbox = cBoundingBox(0, 10, 0, 10, 0, 10)
	local v1 = Vector3d(1, 1, 1)
	local v2 = Vector3d(5, 5, 5)
	local v3 = Vector3d(11, 11, 11)
	
	if (bbox:IsInside(v1)) then
		LOG("v1 is inside bbox")
	else
		LOG("v1 is not inside bbox")
	end
	
	if (bbox:IsInside(v2)) then
		LOG("v2 is inside bbox")
	else
		LOG("v2 is not inside bbox")
	end

	if (bbox:IsInside(v3)) then
		LOG("v3 is inside bbox")
	else
		LOG("v3 is not inside bbox")
	end

	if (bbox:IsInside(v1, v2)) then
		LOG("v1*v2 is inside bbox")
	else
		LOG("v1*v2 is not inside bbox")
	end
	
	if (bbox:IsInside(v2, v1)) then
		LOG("v2*v1 is inside bbox")
	else
		LOG("v2*v1 is not inside bbox")
	end
	
	if (bbox:IsInside(v1, v3)) then
		LOG("v1*v3 is inside bbox")
	else
		LOG("v1*v3 is not inside bbox")
	end
	
	if (bbox:IsInside(v2, v3)) then
		LOG("v2*v3 is inside bbox")
	else
		LOG("v2*v3 is not inside bbox")
	end
	
	return true
end




