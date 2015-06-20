-- Some HTML helper functions
local function HTML_Option(Value, Text, Selected)
	if (Selected) then
		return [[<option value="]] .. Value .. [[" selected>]] .. Text .. [[</option>]]
	else
		return [[<option value="]] .. Value .. [[">]] .. Text .. [[</option>]]
	end
end

local function HTML_Select_On_Off(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("1", "On",  DefaultValue == 1)
		.. HTML_Option("0", "Off", DefaultValue == 0)
		.. [[</select>]]
end


local function ShowGeneralSettings(Request)
	local Content = ""
	local InfoMsg = nil
	
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = "<b style=\"color: red;\">ERROR: Could not read settings.ini!</b>"
	end
	
	if (Request.PostParams["general_submit"] ~= nil) then
		local ServerDescription = Request.PostParams["Server_Description"]
		local MaxPlayers = tonumber(Request.PostParams["Server_MaxPlayers"])
		local Ports = Request.PostParams["Server_Port"]
		local PortsIPv6 = Request.PostParams["Server_PortsIPv6"]
		local DefaultViewDistance = tonumber(Request.PostParams["Server_ViewDistance"])
		local HardcoreEnabled = (Request.PostParams["Server_Hardcore"] == "1")

		SettingsIni:SetValue("Server", "Description", ServerDescription)
		if (MaxPlayers ~= nil) then
			SettingsIni:SetValueI("Server", "MaxPlayers", MaxPlayers)
		end
		SettingsIni:SetValue("Server", "Port", Ports)
		SettingsIni:SetValue("Server", "PortsIPv6", PortsIPv6)
		if (DefaultViewDistance ~= nil) then
			SettingsIni:SetValueI("Server", "DefaultViewDistance", DefaultViewDistance)
		end
		SettingsIni:SetValueB("Server", "HardcoreEnabled", HardcoreEnabled)

		local AuthenticateEnabled = (Request.PostParams["Authentication_Authenticate"] == "1")
		local AuthenticateAllowBungee = (Request.PostParams["Authentication_AllowBungee"] == "1")
		local AuthenticateServer = Request.PostParams["Authentication_Server"]
		local AuthenticateAddress = Request.PostParams["Authentication_Address"]

		SettingsIni:SetValueB("Authentication", "Authenticate", AuthenticateEnabled)
		SettingsIni:SetValueB("Authentication", "AllowBungeeCord", AuthenticateAllowBungee)
		SettingsIni:SetValue("Authentication", "Server", AuthenticateServer)
		SettingsIni:SetValue("Authentication", "Address", AuthenticateAddress)

		if not(SettingsIni:WriteFile("settings.ini")) then
			InfoMsg =  [[<b style="color: red;">ERROR: Could not write to settings.ini!</b>]]
		else
			InfoMsg = [[<b style="color: green;">INFO: Successfully saved changes to settings.ini</b>]]
		end
	end
	
	
	Content = Content .. [[
	<form method="POST">
	<h4>General Settings</h4>]]
	
	if (InfoMsg ~= nil) then
		Content = Content .. "<p>" .. InfoMsg .. "</p>"
	end
	Content = Content .. [[
	<table>
	<th colspan="2">Server</th>
	<tr><td style="width: 50%;">Description:</td>
	<td><input type="text" name="Server_Description" value="]] .. SettingsIni:GetValue("Server", "Description") .. [["></td></tr>
	<tr><td>Max Players:</td>
	<td><input type="text" name="Server_MaxPlayers" value="]] .. SettingsIni:GetValue("Server", "MaxPlayers") .. [["></td></tr>
	<tr><td>IPv4 Ports:</td>
	<td><input type="text" name="Server_Port" value="]] .. SettingsIni:GetValue("Server", "Port") .. [["></td></tr>
	<tr><td>IPv6 Ports:</td>
	<td><input type="text" name="Server_PortsIPv6" value="]] .. SettingsIni:GetValue("Server", "PortsIPv6") .. [["></td></tr>
	<tr><td>Default ViewDistance:</td>
	<td><input type="text" name="Server_ViewDistance" value="]] .. SettingsIni:GetValueI("Server", "DefaultViewDistance") .. [["></td></tr>
	<tr><td>Hardcore:</td>
	<td>]] .. HTML_Select_On_Off("Server_Hardcore", SettingsIni:GetValueI("Server", "HardcoreEnabled")) .. [[</tr>
	</table><br />
	
	<table>
	<th colspan="2">Authentication</th>
	<tr><td style="width: 50%;">Authenticate:</td>
	<td>]] .. HTML_Select_On_Off("Authentication_Authenticate", SettingsIni:GetValueI("Authentication", "Authenticate") ) .. [[</td></tr>
	<tr><td>Allow BungeeCord:</td>
	<td>]] .. HTML_Select_On_Off("Authentication_AllowBungee", SettingsIni:GetValueI("Authentication", "AllowBungeeCord")) .. [[</td></tr>
	<tr><td>Authentication Server:</td>
	<td><input type="text" name="Authentication_Server" value="]] .. SettingsIni:GetValue("Authentication", "Server") .. [["></td></tr>
	<tr><td>Authentication Address:</td>
	<td><input type="text" name="Authentication_Address" value="]] .. SettingsIni:GetValue("Authentication", "Address") .. [["></td></tr>
	</table><br />
	
	<input type="submit" value="Save Settings" name="general_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	
	return Content
end


local function ShowWorldsSettings(Request)
	local Content = ""
	local InfoMsg = nil
	local bSaveIni = false
	
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read settings.ini!</b>]]
	end
	
	if (Request.PostParams["RemoveWorld"] ~= nil) then
		Content = Content .. Request.PostParams["RemoveWorld"]
		local WorldIdx = string.sub(Request.PostParams["RemoveWorld"], string.len("Remove "))
		local KeyIdx = SettingsIni:FindKey("Worlds")
		local WorldName = SettingsIni:GetValue(KeyIdx, WorldIdx)
		if (SettingsIni:DeleteValueByID(KeyIdx, WorldIdx) == true) then
			InfoMsg = "<b style=\"color: green;\">INFO: Successfully removed world " .. WorldName .. "!</b><br />"
			bSaveIni = true
		end
	end
	
	if (Request.PostParams["AddWorld"] ~= nil) then
		if (Request.PostParams["WorldName"] ~= nil and Request.PostParams["WorldName"] ~= "") then
			SettingsIni:AddValue("Worlds", "World", Request.PostParams["WorldName"])
			InfoMsg = "<b style=\"color: green;\">INFO: Successfully added world " .. Request.PostParams["WorldName"] .. "!</b><br />"
			bSaveIni = true
		end
	end
	
	if (Request.PostParams["worlds_submit"] ~= nil ) then
		if Request.PostParams["Worlds_DefaultWorld"] ~= nil then
			SettingsIni:SetValue("Worlds", "DefaultWorld", Request.PostParams["Worlds_DefaultWorld"], false )
		end
		if (Request.PostParams["Worlds_World"] ~= nil) then
			SettingsIni:AddValue("Worlds", "World", Request.PostParams["Worlds_World"])
		end
		bSaveIni = true
	end
	
	if (bSaveIni) then
		if (InfoMsg == nil) then InfoMsg = "" end
		if not(SettingsIni:WriteFile("settings.ini")) then
			InfoMsg = InfoMsg .. "<b style=\"color: red;\">ERROR: Could not write to settings.ini!</b>"
		else
			InfoMsg = InfoMsg .. "<b style=\"color: green;\">INFO: Successfully saved changes to settings.ini</b>"
		end
	end
	
	Content = Content .. "<h4>Worlds Settings</h4>"
	if( InfoMsg ~= nil ) then
		Content = Content .. "<p>" .. InfoMsg .. "</p>"
	end
	
	Content = Content .. [[
	<form method="POST">
	<table>
	<th colspan="2">Worlds</th>
	<tr><td style="width: 50%;">Default World:</td>
	<td><input type="Submit" name="Worlds_DefaultWorld" value="]] .. SettingsIni:GetValue("Worlds", "DefaultWorld") .. [["></td></tr>]]
	
	local KeyIdx = SettingsIni:FindKey("Worlds")
	local NumValues = SettingsIni:GetNumValues(KeyIdx)
	for i = 0, NumValues-1 do
		local ValueName = SettingsIni:GetValueName(KeyIdx, i)
		if( ValueName == "World" ) then
			local WorldName = SettingsIni:GetValue(KeyIdx, i)
			Content = Content .. [[
			<tr><td>]] .. ValueName .. [[:</td><td><div style="width: 100px; display: inline-block;">]] .. WorldName .. [[</div><input type="submit" value="Remove ]] .. i .. [[" name="RemoveWorld"></td></tr>]]
		end
	end
	
	Content = Content .. [[
	<tr><td>Add World:</td>
	<td><input type='text' name='WorldName'><input type='submit' name='AddWorld' value='Add World'></td></tr>
	</table><br />
	
	<input type="submit" value="Save Settings" name="worlds_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end





local function SelectWorldButton(WorldName)
	return "<form method='POST'><input type='hidden' name='WorldName' value='"..WorldName.."'><input type='submit' name='SelectWorld' value='Select'></form>"
end

local function HTML_Select_Dimension(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Overworld", "Overworld", NoCaseCompare("Overworld", DefaultValue) == 0)
		.. HTML_Option("Nether", "Nether", NoCaseCompare("Nether", DefaultValue) == 0)
		.. HTML_Option("End", "The End", NoCaseCompare("End", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_Number(Name, MinNumber, MaxNumber, DefaultValue)
	local ToReturn = [[<select name="]] .. Name .. [[">]]
	for i = MinNumber, MaxNumber do
		ToReturn = ToReturn .. HTML_Option(i, i, DefaultValue == i)
	end

	ToReturn = ToReturn .. [[</select>]]
	return ToReturn
end

local function HTML_Select_Scheme(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Default", "Default", NoCaseCompare("Default", DefaultValue) == 0)
		.. HTML_Option("Anvil", "Anvil", NoCaseCompare("Anvil", DefaultValue) == 0)
		.. HTML_Option("Forgetful", "Forgetful", NoCaseCompare("Forgetful", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_GameMode(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("0", "Survival", DefaultValue == 0)
		.. HTML_Option("1", "Creative",  DefaultValue == 1)
		.. HTML_Option("2", "Adventure",  DefaultValue == 2)
		.. HTML_Option("3", "Spectator",  DefaultValue == 3)
		.. [[</select>]]
end

local function HTML_Select_Shrapnel_Level(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("0", "None", DefaultValue == 0)
		.. HTML_Option("1", "Only Gravity Affected", DefaultValue == 1)
		.. HTML_Option("2", "All", DefaultValue == 2)
		.. [[</select>]]
end

local function HTML_Select_Fluid_Simulator(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Noop", "Disabled", NoCaseCompare("Noop", DefaultValue) == 0 or NoCaseCompare("null", DefaultValue) == 0 or NoCaseCompare("nil", DefaultValue) == 0)
		.. HTML_Option("Vaporize", "Vaporize", NoCaseCompare("Vaporize", DefaultValue) == 0)
		.. HTML_Option("Floody", "Floody", NoCaseCompare("Floody", DefaultValue) == 0)
		.. HTML_Option("Vanilla", "Vanilla", NoCaseCompare("Vanilla", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_Redstone_Simulator(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Noop", "Disabled", NoCaseCompare("Noop", DefaultValue) == 0)
		.. HTML_Option("Incremental", "Incremental", NoCaseCompare("Incremental", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_Generator(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Noise3D", "Noise3D", NoCaseCompare("Noise3D", DefaultValue) == 0)
		.. HTML_Option("Composable", "Composable", NoCaseCompare("Composable", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_BiomeGen(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("MultiStepMap", "MultiStepMap", NoCaseCompare("MultiStepMap", DefaultValue) == 0)
		.. HTML_Option("Constant", "Constant", NoCaseCompare("Constant", DefaultValue) == 0)
		.. HTML_Option("CheckerBoard", "CheckerBoard", NoCaseCompare("CheckerBoard", DefaultValue) == 0)
		.. HTML_Option("Voronoi", "Voronoi", NoCaseCompare("Voronoi", DefaultValue) == 0)
		.. HTML_Option("DistortedVoronoi", "DistortedVoronoi", NoCaseCompare("DistortedVoronoi", DefaultValue) == 0)
		.. HTML_Option("TwoLevel", "TwoLevel", NoCaseCompare("TwoLevel", DefaultValue) == 0)
		.. HTML_Option("Grown", "Grown", NoCaseCompare("Grown", DefaultValue) == 0)
		.. HTML_Option("GrownProt", "GrownProt", NoCaseCompare("GrownProt", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_HeightGen(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Biomal", "Biomal", NoCaseCompare("Biomal", DefaultValue) == 0)
		.. HTML_Option("Flat", "Flat", NoCaseCompare("Flat", DefaultValue) == 0)
		.. HTML_Option("Classic", "Classic", NoCaseCompare("Classic", DefaultValue) == 0)
		.. HTML_Option("DistortedHeightmap", "DistortedHeightmap", NoCaseCompare("DistortedHeightmap", DefaultValue) == 0)
		.. HTML_Option("End", "End", NoCaseCompare("End", DefaultValue) == 0)
		.. HTML_Option("MinMax", "MinMax", NoCaseCompare("MinMax", DefaultValue) == 0)
		.. HTML_Option("Mountains", "Mountains", NoCaseCompare("Mountains", DefaultValue) == 0)
		.. HTML_Option("BiomalNoise3D", "BiomalNoise3D", NoCaseCompare("BiomalNoise3D", DefaultValue) == 0)
		.. HTML_Option("Noise3D", "Noise3D", NoCaseCompare("Noise3D", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_ShapeGen(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("BiomalNoise3D", "BiomalNoise3D", NoCaseCompare("BiomalNoise3D", DefaultValue) == 0)
		.. HTML_Option("HeightMap", "HeightMap", NoCaseCompare("HeightMap", DefaultValue) == 0)
		.. HTML_Option("DistortedHeightmap", "DistortedHeightmap", NoCaseCompare("DistortedHeightmap", DefaultValue) == 0)
		.. HTML_Option("End", "End", NoCaseCompare("End", DefaultValue) == 0)
		.. HTML_Option("Noise3D", "Noise3D", NoCaseCompare("Noise3D", DefaultValue) == 0)
		.. HTML_Option("TwoHeights", "TwoHeights", NoCaseCompare("TwoHeights", DefaultValue) == 0)
		.. [[</select>]]
end

local function HTML_Select_CompositionGen(Name, DefaultValue)
	return [[<select name="]] .. Name .. [[">]]
		.. HTML_Option("Biomal", "Biomal", NoCaseCompare("Biomal", DefaultValue) == 0)
		.. HTML_Option("BiomalNoise3D", "BiomalNoise3D", NoCaseCompare("BiomalNoise3D", DefaultValue) == 0)
		.. HTML_Option("Classic", "Classic", NoCaseCompare("Classic", DefaultValue) == 0)
		.. HTML_Option("DebugBiomes", "DebugBiomes", NoCaseCompare("DebugBiomes", DefaultValue) == 0)
		.. HTML_Option("DistortedHeightmap", "DistortedHeightmap", NoCaseCompare("DistortedHeightmap", DefaultValue) == 0)
		.. HTML_Option("End", "End", NoCaseCompare("End", DefaultValue) == 0)
		.. HTML_Option("Nether", "Nether", NoCaseCompare("Nether", DefaultValue) == 0)
		.. HTML_Option("Noise3D", "Noise3D", NoCaseCompare("Noise3D", DefaultValue) == 0)
		.. HTML_Option("SameBlock", "SameBlock", NoCaseCompare("SameBlock", DefaultValue) == 0)
		.. [[</select>]]
end





g_SelectedWorld = {}
g_WorldSettingsLayout = {}
slEasy     = 1
slAdvanced = 2




function ShowWorldSettings(Request)
	local Content = ""
	local SettingLayout = g_WorldSettingsLayout[Request.Username] or slEasy
	
	if (Request.PostParams['ChangeWebLayout'] ~= nil) then
		if (Request.PostParams['ChangeWebLayout'] == 'Easy') then
			SettingLayout = slEasy
		elseif (Request.PostParams['ChangeWebLayout'] == 'Advanced') then
			SettingLayout = slAdvanced
		end
	end
	
	if (SettingLayout == slEasy) then
		Content = Content .. '<form method="Post">'
		Content = Content .. 'Change Web Layout to: <input type="submit" name="ChangeWebLayout" value="Advanced" />'
		Content = Content .. '</form><br />'
		Content = Content .. GetEasyWorldSettings(Request)
	elseif (SettingLayout == slAdvanced) then
		Content = Content .. '<form method="Post">'
		Content = Content .. 'Change Web Layout to: <input type="submit" name="ChangeWebLayout" value="Easy" />'
		Content = Content .. '</form><br />'
		Content = Content .. GetAdvancedWorldSettings(Request)
	else
		Content = Content .. '<b style="red">The web type is unknown. Switching to easy layout.<br />'
		Content = Content .. GetEasyWorldSettings(Request)
		SettingLayout = slEasy
	end
	
	g_WorldSettingsLayout[Request.Username] = SettingLayout
	return Content
end




function GetEasyWorldSettings(Request)
	local Content = ""
	local InfoMsg = nil
	local SettingsIni = cIniFile()
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read settings.ini!</b>]]
	end
	if (Request.PostParams["SelectWorld"] ~= nil and Request.PostParams["WorldName"] ~= nil) then		-- World is selected!
		SelectedWorld = cRoot:Get():GetWorld(Request.PostParams["WorldName"])
	elseif SelectedWorld == nil then
		local WorldName = SettingsIni:GetValue("Worlds", "DefaultWorld")
		SelectedWorld = cRoot:Get():GetWorld(WorldName)
	end

	local WorldIni = cIniFile()
	WorldIni:ReadFile(SelectedWorld:GetIniFileName())

	if (Request.PostParams["world_submit"] ~= nil) then
		WorldIni:SetValue("General", "Dimension", Request.PostParams["General_Dimension"])
		WorldIni:SetValueB("General", "IsDaylightCycleEnabled", Request.PostParams["General_DaylightCycle"] == "1")
		WorldIni:SetValueI("General", "Gamemode", tonumber(Request.PostParams["General_GameMode"]))

		WorldIni:SetValueB("Broadcasting", "BroadcastDeathMessages", Request.PostParams["Broadcasting_DeathMessages"] == "1")
		WorldIni:SetValueB("Broadcasting", "BroadcastAchievementMessages", Request.PostParams["Broadcasting_AchievementMessages"] == "1")

		WorldIni:SetValueI("SpawnPosition", "X", tonumber(Request.PostParams["Spawn_X"]))
		WorldIni:SetValueI("SpawnPosition", "Y", tonumber(Request.PostParams["Spawn_Y"]))
		WorldIni:SetValueI("SpawnPosition", "Z", tonumber(Request.PostParams["Spawn_Z"]))
		WorldIni:SetValueI("SpawnPosition", "MaxViewDistance", tonumber(Request.PostParams["Spawn_MaxViewDistance"]))
		WorldIni:SetValueI("SpawnPosition", "PregenerateDistance", tonumber(Request.PostParams["Spawn_PregenerateDistance"]))
		WorldIni:SetValueI("SpawnProtect", "ProtectRadius", tonumber(Request.PostParams["Spawn_ProtectionRadius"]))

		WorldIni:SetValue("Storage", "Schema", Request.PostParams["Storage_Schema"])
		WorldIni:SetValueI("Storage", "CompressionFactor", tonumber(Request.PostParams["Storage_CompressionFactor"]))

		WorldIni:SetValueB("Physics", "DeepSnow", Request.PostParams["Physics_DeepSnow"] == "1")
		WorldIni:SetValueB("Physics", "ShouldLavaSpawnFire", Request.PostParams["Physics_ShouldLavaSpawnFire"] == "1")
		WorldIni:SetValueI("Physics", "TNTShrapnelLevel", tonumber(Request.PostParams["Physics_TNTShrapnelLevel"]))
		WorldIni:SetValueB("Physics", "SandInstantFall", Request.PostParams["Physics_SandInstantFall"] == "1")
		WorldIni:SetValue("Physics", "WaterSimulator", Request.PostParams["Physics_WaterSimulator"])
		WorldIni:SetValue("Physics", "LavaSimulator", Request.PostParams["Physics_LavaSimulator"])
		WorldIni:SetValue("Physics", "RedstoneSimulator", Request.PostParams["Physics_RedstoneSimulator"])

		WorldIni:SetValueB("Mechanics", "CommandBlocksEnabled", Request.PostParams["Mechanics_CommandBlocksEnabled"] == "1")
		WorldIni:SetValueB("Mechanics", "PVPEnabled", Request.PostParams["Mechanics_PVPEnabled"] == "1")
		WorldIni:SetValueB("Mechanics", "UseChatPrefixes", Request.PostParams["Mechanics_UseChatPrefixes"] == "1")

		WorldIni:SetValueB("Monsters", "VillagersShouldHarvestCrops", Request.PostParams["Monsters_VillagersShouldHarvestCrops"] == "1")
		WorldIni:SetValueB("Monsters", "AnimalsOn", Request.PostParams["Monsters_AnimalsOn"] == "1")
		WorldIni:SetValue("Monsters", "Types", Request.PostParams["Monsters_Types"])

		WorldIni:SetValue("LinkedWorlds", "NetherWorldName", Request.PostParams["LinkedWorlds_Nether"])
		WorldIni:SetValue("LinkedWorlds", "EndWorldName", Request.PostParams["LinkedWorlds_End"])

		WorldIni:SetValueI("Seed", "Seed", tonumber(Request.PostParams["Seed"]))

		WorldIni:SetValue("Generator", "Generator", Request.PostParams["Generator"])
		WorldIni:SetValue("Generator", "BiomeGen", Request.PostParams["Generator_BiomeGen"])
		WorldIni:SetValue("Generator", "HeightGen", Request.PostParams["Generator_HeightGen"])
		WorldIni:SetValue("Generator", "ShapeGen", Request.PostParams["Generator_ShapeGen"])
		WorldIni:SetValue("Generator", "CompositionGen", Request.PostParams["Generator_CompositionGen"])
		WorldIni:SetValue("Generator", "Finishers", Request.PostParams["Generator_Finishers"])
		
		WorldIni:WriteFile(SelectedWorld:GetIniFileName())
	end

	Content = Content .. "<h4>World for operations: " .. SelectedWorld:GetName() .. "</h4>"
	Content = Content .. "<table>"
	local WorldNum = 0
	local AddWorldToTable = function(World)
		WorldNum = WorldNum + 1
		Content = Content .. "<tr>"
		Content = Content .. "<td style='width: 10px;'>" .. WorldNum .. ".</td>"
		Content = Content .. "<td>" .. World:GetName() .. "</td>"
		Content = Content .. "<td>" .. SelectWorldButton(World:GetName()) .. "</td>"
		Content = Content .. "</tr>"
	end
	cRoot:Get():ForEachWorld(AddWorldToTable)
	Content = Content .. "</table>"

	Content = Content .. [[<table>
	<form method="POST">
	<br />
	<th colspan="2">General</th>
	<tr><td style="width: 50%;">Dimension:</td>
	<td>]] .. HTML_Select_Dimension("General_Dimension", WorldIni:GetValue("General", "Dimension")) .. [[</td></tr>
	<tr><td>Daylight Cycle Enabled:</td>
	<td>]] .. HTML_Select_On_Off("General_DaylightCycle", WorldIni:GetValueI("General", "IsDaylightCycleEnabled")) .. [[</td></tr>
	<tr><td>Default GameMode:</td>
	<td>]] .. HTML_Select_GameMode("General_GameMode", WorldIni:GetValueI("General", "Gamemode")) .. [[</td></tr>

	<th colspan="2">Broadcasting</th>
	<tr><td>Death Messages:</td>
	<td>]] .. HTML_Select_On_Off("Broadcasting_DeathMessages", WorldIni:GetValueI("Broadcasting", "BroadcastDeathMessages")) .. [[</td></tr>
	<tr><td>Achievement Messages:</td>
	<td>]] .. HTML_Select_On_Off("Broadcasting_AchievementMessages", WorldIni:GetValueI("Broadcasting", "BroadcastAchievementMessages")) .. [[</td></tr>

	<th colspan="2">Spawn Position</th>
	<tr><td>X:</td>
	<td><input type="text" name="Spawn_X" value="]] .. WorldIni:GetValue("SpawnPosition", "X") .. [["></td></tr>
	<tr><td>Y:</td>
	<td><input type="text" name="Spawn_Y" value="]] .. WorldIni:GetValue("SpawnPosition", "Y") .. [["></td></tr>
	<tr><td>Z:</td>
	<td><input type="text" name="Spawn_Z" value="]] .. WorldIni:GetValue("SpawnPosition", "Z") .. [["></td></tr>
	<tr><td>Max View Distance:</td>
	<td>]] .. HTML_Select_Number("Spawn_MaxViewDistance", cClientHandle.MIN_VIEW_DISTANCE, cClientHandle.MAX_VIEW_DISTANCE, WorldIni:GetValueI("SpawnPosition", "MaxViewDistance")) .. [[</td></tr>
	<tr><td>Pregenerate Distance:</td>
	<td><input type="text" name="Spawn_PregenerateDistance" value="]] .. WorldIni:GetValue("SpawnPosition", "PregenerateDistance") .. [["></td></tr>
	<tr><td>Protection Radius:</td>
	<td><input type="text" name="Spawn_ProtectionRadius" value="]] .. WorldIni:GetValue("SpawnProtect", "ProtectRadius") .. [["></td></tr>

	<th colspan="2">Storage</th>
	<tr><td>Schema:</td>
	<td>]] .. HTML_Select_Scheme("Storage_Schema", WorldIni:GetValue("Storage", "Schema")) .. [[</td></tr>
	<tr><td>Compression Factor:</td>
	<td>]] .. HTML_Select_Number("Storage_CompressionFactor", 0, 6, WorldIni:GetValueI("Storage", "CompressionFactor")) .. [[</td></tr>

	<th colspan="2">Physics</th>
	<tr><td>Deep snow:</td>
	<td>]] .. HTML_Select_On_Off("Physics_DeepSnow", WorldIni:GetValueI("Physics", "DeepSnow")) .. [[</td></tr>
	<tr><td>Should lava spawn fire:</td>
	<td>]] .. HTML_Select_On_Off("Physics_ShouldLavaSpawnFire", WorldIni:GetValueI("Physics", "ShouldLavaSpawnFire")) .. [[</td></tr>
	<tr><td>TNT Shrapnel Level:</td>
	<td>]] .. HTML_Select_Shrapnel_Level("Physics_TNTShrapnelLevel", WorldIni:GetValueI("Physics", "TNTShrapnelLevel")) .. [[</td></tr>
	<tr><td>Sand Instant Fall:</td>
	<td>]] .. HTML_Select_On_Off("Physics_SandInstantFall", WorldIni:GetValueI("Physics", "SandInstantFall")) .. [[</td></tr>
	<tr><td>Water Simulator:</td>
	<td>]] .. HTML_Select_Fluid_Simulator("Physics_WaterSimulator", WorldIni:GetValue("Physics", "WaterSimulator"))  .. [[</td></tr>
	<tr><td>Lava Simulator:</td>
	<td>]] .. HTML_Select_Fluid_Simulator("Physics_LavaSimulator", WorldIni:GetValue("Physics", "LavaSimulator")) .. [[</td></tr>
	<tr><td>Redstone Simulator:</td>
	<td>]] .. HTML_Select_Redstone_Simulator("Physics_RedstoneSimulator", WorldIni:GetValue("Physics", "RedstoneSimulator")) .. [[</td></tr>

	<th colspan="2">Mechanics</th>
	<tr><td>Command blocks:</td>
	<td>]] .. HTML_Select_On_Off("Mechanics_CommandBlocksEnabled", WorldIni:GetValueI("Mechanics", "CommandBlocksEnabled")) .. [[</td></tr>
	<tr><td>PVP:</td>
	<td>]] .. HTML_Select_On_Off("Mechanics_PVPEnabled", WorldIni:GetValueI("Mechanics", "PVPEnabled")) .. [[</td></tr>
	<tr><td>Use Chat Prefixes:</td>
	<td>]] .. HTML_Select_On_Off("Mechanics_UseChatPrefixes", WorldIni:GetValueI("Mechanics", "UseChatPrefixes")) .. [[</td></tr>

	<th colspan="2">Monsters</th>
	<tr><td>Should villagers harvest crops:</td>
	<td>]] .. HTML_Select_On_Off("Monsters_VillagersShouldHarvestCrops", WorldIni:GetValueI("Monsters", "VillagersShouldHarvestCrops")) .. [[</td></tr>
	<tr><td>Animals on:</td>
	<td>]] .. HTML_Select_On_Off("Monsters_AnimalsOn", WorldIni:GetValueI("Monsters", "AnimalsOn")) .. [[</td></tr>
	<tr><td>Types (Only this types will spawn):</td>
	<td><input type="text" name="Monsters_Types" value="]] .. WorldIni:GetValue("Monsters", "Types") .. [["></td></tr>

	<th colspan="2">Linked worlds</th>
	<tr><td>Nether:</td>
	<td><input type="text" name="LinkedWorlds_Nether" value="]] .. WorldIni:GetValue("LinkedWorlds", "NetherWorldName") .. [["></td></tr>
	<tr><td>The End:</td>
	<td><input type="text" name="LinkedWorlds_End" value="]] .. WorldIni:GetValue("LinkedWorlds", "EndWorldName") .. [["></td></tr>

	<th colspan="2">Seed</th>
	<tr><td>Seed:</td>
	<td><input type="text" name="Seed" value="]] .. WorldIni:GetValue("Seed", "Seed") .. [["></td></tr>

	<th colspan="2">Generator</th>
	<tr><td>Generator:</td>
	<td>]] .. HTML_Select_Generator("Generator", WorldIni:GetValue("Generator", "Generator")) .. [[</td></tr>
	<tr><td>Biome Generator:</td>
	<td>]] .. HTML_Select_BiomeGen("Generator_BiomeGen", WorldIni:GetValue("Generator", "BiomeGen")) .. [[</td></tr>
	<tr><td>Height Generator:</td>
	<td>]] .. HTML_Select_HeightGen("Generator_HeightGen", WorldIni:GetValue("Generator", "HeightGen")) .. [[</td></tr>
	<tr><td>Shape Generator:</td>
	<td>]] .. HTML_Select_ShapeGen("Generator_ShapeGen", WorldIni:GetValue("Generator", "ShapeGen")) .. [[</td></tr>
	<tr><td style="width: 50%;">Composition Generator:</td>
	<td>]] .. HTML_Select_CompositionGen("Generator_CompositionGen", WorldIni:GetValue("Generator", "CompositionGen") ) .. [[</td></tr>
	<tr><td>Finishers:</td>
	<td><input type="text" name="Generator_Finishers" value="]] .. WorldIni:GetValue("Generator", "Finishers") .. [["></td></tr>
	]]
	Content = Content .. [[</table>]]
	
	Content = Content .. [[ <br />
	<input type="submit" value="Save Settings" name="world_submit"> </form>WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end





function GetAdvancedWorldSettings(Request)
	local Content = ""
	local InfoMsg = nil
	local SettingsIni = cIniFile()
	
	if not(SettingsIni:ReadFile("settings.ini")) then
		InfoMsg = [[<b style="color: red;">ERROR: Could not read settings.ini!</b>]]
	end
	
	local WORLD;
	local SelectedWorld = g_SelectedWorld[Request.Username];
	
	if (not g_SelectedWorld[Request.Username]) then
		g_SelectedWorld[Request.Username] = cRoot:Get():GetDefaultWorld()
		SelectedWorld = g_SelectedWorld[Request.Username]
		WORLD = SelectedWorld:GetName()
	else
		WORLD = g_SelectedWorld[Request.Username]:GetName()
	end
		
	if (Request.PostParams["WorldName"] ~= nil) then		-- World is selected!
		WORLD = Request.PostParams["WorldName"]
		g_SelectedWorld[Request.Username] = cRoot:Get():GetWorld(WORLD)
		SelectedWorld = g_SelectedWorld[Request.Username]
	end
	
	if (Request.PostParams['WorldIniContent'] ~= nil) then
		local File = io.open(SelectedWorld:GetIniFileName(), "w")
		File:write(Request.PostParams['WorldIniContent'])
		File:close()
	end
	
	Content = Content .. "<h4>World for operations: " .. WORLD .. "</h4>"
	Content = Content .. "<table>"
	local WorldNum = 0
	cRoot:Get():ForEachWorld(
		function(World)
			WorldNum = WorldNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. WorldNum .. ".</td>"
			Content = Content .. "<td>" .. World:GetName() .. "</td>"
			Content = Content .. "<td>" .. SelectWorldButton(World:GetName()) .. "</td>"
			Content = Content .. "</tr>"
		end
	)
	Content = Content .. "</table>"

	local WorldIniContent = cFile:ReadWholeFile(SelectedWorld:GetIniFileName())
	Content = Content .. [[<br />
	
	<form method="post">
	<textarea style="width: 100%; height: 500px;" name="WorldIniContent">]] .. WorldIniContent .. [[</textarea>
	<input type="submit" value="Save Settings" name="world_submit"> WARNING: Any changes made here might require a server restart in order to be applied!
	</form>]]
	return Content
end



function HandleRequest_ServerSettings(Request)
	local Content = ""

	Content = Content .. [[
	<p><b>Server Settings</b></p>
	<table>
	<tr>
	<td><a href="?tab=General">General</a></td>
	<td><a href="?tab=Worlds">Worlds</a></td>
	<td><a href="?tab=World">World</a></td>
	</tr>
	</table>
	<br />]]
	
	if (Request.Params["tab"] == "Worlds") then
		Content = Content .. ShowWorldsSettings(Request)
	elseif (Request.Params["tab"] == "World") then
		Content = Content .. ShowWorldSettings(Request)
	else
		Content = Content .. ShowGeneralSettings(Request) -- Default to general settings
	end
	
	return Content
end
