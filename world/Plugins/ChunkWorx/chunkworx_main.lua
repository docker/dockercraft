-- Global variables
PLUGIN = {}	-- Reference to own plugin object
GENERATION_STATE = 0
OPERATION_CODE = 0	-- 0 = generation
CX = 0
CZ = 0
CURRENT = 0
TOTAL = 0

-- AREA Variables
AreaStartX = -10
AreaStartZ = -10
AreaEndX = 10
AreaEndZ = 10

-- RADIAL Variables
RadialX = 0
RadialZ = 0
Radius = 10

-- WORLD
WORK_WORLD = cRoot:Get():GetDefaultWorld():GetName()
WW_instance = cRoot:Get():GetDefaultWorld()
WORLDS = {}





function Initialize(Plugin)
	PLUGIN = Plugin
	
	PLUGIN:SetName("ChunkWorx")
	PLUGIN:SetVersion(6)
	
	cPluginManager.AddHook(cPluginManager.HOOK_TICK, OnTick)
	
	Plugin:AddWebTab("(Re)Generation", HandleRequest_Generation)
	
	GENERATION_STATE = 0
	WW_instance = cRoot:Get():GetWorld(WORK_WORLD)
	if (WW_instance == nil) then
		LOG("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": NO WORLD found :(")
	end
	
	-- Read the stored values:
	local SettingsIni = cIniFile();
	SettingsIni:ReadFile("ChunkWorx.ini");  -- ignore any read errors
	AreaStartX = SettingsIni:GetValueSetI("Area data",   "StartX",  AreaStartX)
	AreaStartZ = SettingsIni:GetValueSetI("Area data",   "StartZ",  AreaStartZ)
	AreaEndX   = SettingsIni:GetValueSetI("Area data",   "EndX",    AreaEndX)
	AreaEndZ   = SettingsIni:GetValueSetI("Area data",   "EndZ",    AreaEndZ)
	RadialX    = SettingsIni:GetValueSetI("Radial data", "RadialX", RadialX)
	RadialZ    = SettingsIni:GetValueSetI("Radial data", "RadialZ", RadialZ)
	Radius     = SettingsIni:GetValueSetI("Radial data", "Radius",  Radius)
	SettingsIni:WriteFile("ChunkWorx.ini");
	
	LOG("Initialized " .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion())
	return true
end





function OnTick( DeltaTime )
	if (GENERATION_STATE == 1 or GENERATION_STATE == 3) then
		LOGINFO("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": works STARTED!")
		LOGINFO("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": At world: " .. WORK_WORLD)
		WW_instance = cRoot:Get():GetWorld(WORK_WORLD)
		if (GENERATION_STATE == 1) then GENERATION_STATE = 2 end
		if (GENERATION_STATE == 3) then GENERATION_STATE = 4 end
		
		-- Changing in case coordinates are flipped
		local shifter = AreaEndX
		if (AreaStartX > AreaEndX) then
			AreaEndX = AreaStartX
			AreaStartX = shifter
		end
		shifter = AreaEndZ
		if (AreaStartZ > AreaEndZ) then
			AreaEndZ = AreaStartZ
			AreaStartZ = shifter
		end
		
		CX = AreaStartX
		CZ = AreaStartZ
		CURRENT = 0
		
		if (WW_instance == nil) then
			LOGERROR("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": works ABORTED")
			LOGERROR("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": NO WORLD found :(")
			GENERATION_STATE = 0
		end
	end
	
	
	
	if (GENERATION_STATE == 2 or GENERATION_STATE == 4) then
		if (WW_instance:GetGeneratorQueueLength() < 200
		and WW_instance:GetLightingQueueLength() < 200
		and (WW_instance:GetStorageSaveQueueLength() + WW_instance:GetStorageLoadQueueLength()) < 80) then
			local chunk_sum = (1+ AreaEndX - AreaStartX) * (1+ AreaEndZ - AreaStartZ)
			TOTAL = chunk_sum
			LOG("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": PROCESSING 100 chunks, (" .. CURRENT .. "/" .. chunk_sum .. ")")
			for C = 1, 100	do
				if (GENERATION_STATE == 2) then WW_instance:GenerateChunk(CX, CZ) end
				if (GENERATION_STATE == 4) then WW_instance:RegenerateChunk(CX, CZ) end
				
				CX = CX + 1
				CURRENT = CURRENT + 1
				if (CX > AreaEndX) then
					CX = AreaStartX
					CZ = CZ + 1
					if (CZ > AreaEndZ) then
						if (GENERATION_STATE == 2) then LOGINFO("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. " - generation ENDED!") end
						if (GENERATION_STATE == 4) then LOGINFO("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. " - REgeneration ENDED!") end
						
						GENERATION_STATE = 0
						break
					end
				end
			end
			WW_instance:QueueSaveAllChunks()
			WW_instance:QueueUnloadUnusedChunks()
		end
	end
end