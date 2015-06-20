
-- chunkworx_web.lua

-- WebAdmin-related functions





local function Buttons_Player( Name )
	return "<form method='POST'><input type='hidden' name='PlayerName' value='"..Name.."'><input type='submit' name='PlayerExact' value='Exact'><input type='submit' name='Player3x3' value='3x3'></form>"
end





local function Button_World( Name )
	return "<form method='POST'><input type='hidden' name='WorldName' value='"..Name.."'><input type='submit' name='SelectWorld' value='Select'></form>"
end





local function SaveSettings()
	local SettingsIni = cIniFile()
	SettingsIni:SetValueI("Area data",   "StartX",  AreaStartX)
	SettingsIni:SetValueI("Area data",   "StartZ",  AreaStartZ)
	SettingsIni:SetValueI("Area data",   "EndX",    AreaEndX)
	SettingsIni:SetValueI("Area data",   "EndZ",    AreaEndZ)
	SettingsIni:SetValueI("Radial data", "RadialX", RadialX)
	SettingsIni:SetValueI("Radial data", "RadialZ", RadialZ)
	SettingsIni:SetValueI("Radial data", "Radius",  Radius)
	SettingsIni:WriteFile("ChunkWorx.ini")
end





function HandleRequest_Generation( Request )
	local Content = ""
	if (Request.PostParams["AGHRRRR"] ~= nil) then
		GENERATION_STATE = 0
		WW_instance:QueueSaveAllChunks()
		WW_instance:QueueUnloadUnusedChunks()
		LOGERROR("" .. PLUGIN:GetName() .. " v" .. PLUGIN:GetVersion() .. ": works ABORTED by admin")
	end
	--Content = Content .. "<head><meta http-equiv=\"refresh\" content=\"2;\"></head>"
					-- PROCESSING
	--------------------------------------------------------------------------------------------------
	local function ProcessingContent()
		local _small_content = ""
		_small_content = _small_content .. "<head><meta http-equiv=\"refresh\" content=\"2;\"></head>"
		_small_content = _small_content .. "<h4>World for operations:</h4>"..WORK_WORLD
		if (OPERATION_CODE == 0) then
			_small_content = _small_content .. "<h4>Operation:</h4>Generation"
		elseif (OPERATION_CODE == 1) then
			_small_content = _small_content .. "<h4>Operation:</h4>Regeneration"
		end
		_small_content = _small_content .. "<h4>Area:   </h4>["..AreaStartX..":"..AreaStartZ.."]   ["..AreaEndX..":"..AreaEndZ.."]"
		_small_content = _small_content .. "<h4>Progress:</h4>"..CURRENT.."/"..TOTAL
		_small_content = _small_content .. "<br>"
		_small_content = _small_content .. "<form method='POST'>"
		_small_content = _small_content .. "<input type='submit' name='AGHRRRR' value='Stop'>"
		_small_content = _small_content .. "</form>"
		return _small_content
	end
	if (GENERATION_STATE == 2 or GENERATION_STATE == 4) then
		Content = ProcessingContent()
		return Content
	end
					-- SELECTING
	--------------------------------------------------------------------------------------------------
		if ( Request.PostParams["FormSetWorld"] ) then
			WORK_WORLD = Request.PostParams["FormWorldName"]
			WW_instance = cRoot:Get():GetWorld(WORK_WORLD)
		end
		
		if( Request.PostParams["SelectWorld"] ~= nil
		and Request.PostParams["WorldName"] ~= nil ) then		-- World is selected!
			WORK_WORLD = Request.PostParams["WorldName"]
			WW_instance = cRoot:Get():GetWorld(WORK_WORLD)
		end
		
		if(Request.PostParams["OperationGenerate"] ~= nil) then
			OPERATION_CODE = 0
		end
		if(Request.PostParams["OperationReGenerate"] ~= nil) then
			OPERATION_CODE = 1
		end
		
		if (GENERATION_STATE == 0) then
			if( Request.PostParams["FormAreaStartX"] ~= nil
			and Request.PostParams["FormAreaStartZ"] ~= nil
			and Request.PostParams["FormAreaEndX"] ~= nil
			and Request.PostParams["FormAreaEndZ"] ~= nil ) then	--(Re)Generation valid!
				-- COMMON (Re)gen
				if( Request.PostParams["StartArea"]) then
					AreaStartX = tonumber(Request.PostParams["FormAreaStartX"])
					AreaStartZ = tonumber(Request.PostParams["FormAreaStartZ"])
					AreaEndX = tonumber(Request.PostParams["FormAreaEndX"])
					AreaEndZ = tonumber(Request.PostParams["FormAreaEndZ"])
					SaveSettings();
					if (OPERATION_CODE == 0) then
						GENERATION_STATE = 1
					elseif (OPERATION_CODE == 1) then
						GENERATION_STATE = 3
					end
					Content = ProcessingContent()
					return Content
				end
			end
			if( Request.PostParams["FormRadialX"] ~= nil
			and Request.PostParams["FormRadialZ"] ~= nil
			and Request.PostParams["FormRadius"] ~= nil ) then	--(Re)Generation valid!
				-- COMMON (Re)gen
				if( Request.PostParams["StartRadial"]) then
					RadialX = tonumber(Request.PostParams["FormRadialX"]) or 0
					RadialZ = tonumber(Request.PostParams["FormRadialZ"]) or 0
					Radius =  tonumber(Request.PostParams["FormRadius"])  or 10
					AreaStartX = RadialX - Radius
					AreaStartZ = RadialZ - Radius
					AreaEndX = RadialX + Radius
					AreaEndZ = RadialZ + Radius
					SaveSettings()
					if (OPERATION_CODE == 0) then
						GENERATION_STATE = 1
					elseif (OPERATION_CODE == 1) then
						GENERATION_STATE = 3
					end
					Content = ProcessingContent()
					return Content
				end
			end
			-- POINT REGEN!
			if( Request.PostParams["FormPointX"] ~= nil
			and Request.PostParams["FormPointZ"] ~= nil ) then	--ReGeneration valid!
				-- EXACT
				if ( Request.PostParams["PointExact"] ~= nil) then
					AreaStartX = tonumber(Request.PostParams["FormPointX"])
					AreaStartZ = tonumber(Request.PostParams["FormPointZ"])
					AreaEndX = AreaStartX
					AreaEndZ = AreaStartZ
					GENERATION_STATE = 3
					Content = ProcessingContent()
					return Content
				end
				-- 3x3
				if ( Request.PostParams["Point3x3"] ~= nil) then
					AreaStartX = tonumber(Request.PostParams["FormPointX"]) - 1
					AreaStartZ = tonumber(Request.PostParams["FormPointZ"]) - 1
					AreaEndX = AreaStartX + 2
					AreaEndZ = AreaStartZ + 2
					GENERATION_STATE = 3
					Content = ProcessingContent()
					return Content
				end
			end
			
			local GetAreaByPlayer = function(Player)
				-- Player is valid only within this function, it cannot be stord and used later!
				AreaStartX = Player:GetChunkX()
				AreaStartZ = Player:GetChunkZ()
			end
			-- PLAYERS REGEN!
			if( Request.PostParams["PlayerExact"] ~= nil
			and Request.PostParams["PlayerName"] ~= nil ) then		-- Making BOOM! I meant, regenereate...
				cRoot:Get():GetWorld(WORK_WORLD):DoWithPlayer(Request.PostParams["PlayerName"],GetAreaByPlayer)
				AreaEndX = AreaStartX
				AreaEndZ = AreaStartZ
				GENERATION_STATE = 3
				Content = ProcessingContent()
				return Content
			end
			if( Request.PostParams["Player3x3"] ~= nil
			and Request.PostParams["PlayerName"] ~= nil ) then		-- Making BOOM! I meant, regenereate...
				cRoot:Get():GetWorld(WORK_WORLD):DoWithPlayer(Request.PostParams["PlayerName"],GetAreaByPlayer)
				AreaStartX = AreaStartX - 1
				AreaStartZ = AreaStartZ - 1
				AreaEndX = AreaStartX + 2
				AreaEndZ = AreaStartZ + 2
				GENERATION_STATE = 3
				Content = ProcessingContent()
				return Content
			end
		end
		
		--Content = Content .. "<h4>World for operations: " .. WORK_WORLD .. "</h4>"
		--Content = Content .. "<form method='POST'>"
		--Content = Content .. "<input type='text' name='FormWorldName' value='Input world name here'><input type='submit' name='FormSetWorld' value='Set world'>"
		--Content = Content .. "</form>"
		
		-- SELECTING WORK_WORLD
		Content = Content .. "<h4>World for operations: " .. WORK_WORLD .. "</h4>"
		Content = Content .. "<table>"
		local WorldNum = 0
		local AddWorldToTable = function(World)
			WorldNum = WorldNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. WorldNum .. ".</td>"
			Content = Content .. "<td>" .. World:GetName() .. "</td>"
			Content = Content .. "<td>" .. Button_World(World:GetName()) .. "</td>"
			Content = Content .. "</tr>"
		end
		cRoot:Get():ForEachWorld(AddWorldToTable)
		if( WorldNum == 0 ) then
			Content = Content .. "<tr><td>No worlds! O_O</td></tr>"
		end
		Content = Content .. "</table>"
		Content = Content .. "<br>"
		
		-- SELECTING OPERATION
		if (OPERATION_CODE == 0) then
			Content = Content .. "<h4>Operation: Generation</h4>"
		elseif (OPERATION_CODE == 1) then
			Content = Content .. "<h4>Operation: Regeneration</h4>"
		end
		Content = Content .. "<form method='POST'>"
		Content = Content .. "<input type='submit' name='OperationGenerate' value='Generation'>"
		Content = Content .. "<input type='submit' name='OperationReGenerate' value='Regeneration'>"
		Content = Content .. "</form>"
		
		-- SELECTING AREA
		Content = Content .. "<h4>Area:   </h4>Start X, Start Z;    End X, End Z"
		Content = Content .. "<form method='POST'>"
		Content = Content .. "<input type='text' name='FormAreaStartX' value='" .. AreaStartX .. "'><input type='text' name='FormAreaStartZ' value='" .. AreaStartZ .. "'>"
		Content = Content .. "<input type='text' name='FormAreaEndX' value='" .. AreaEndX .. "'><input type='text' name='FormAreaEndZ' value='" .. AreaEndZ .. "'>"
		Content = Content .. "<input type='submit' name='StartArea' value='Start'>"
		Content = Content .. "</form>"
		
		-- SELECTING RADIAL
		Content = Content .. "<h4>Radial:   </h4>Center X, Center Z, Radius"
		Content = Content .. "<form method='POST'>"
		Content = Content .. "<input type='text' name='FormRadialX' value='" .. RadialX .. "'><input type='text' name='FormRadialZ' value='" .. RadialZ .. "'><input type='text' name='FormRadius' value='" .. Radius .. "'>"
		Content = Content .. "<input type='submit' name='StartRadial' value='Start'>"
		Content = Content .. "</form>"
		Content = Content .. "<br>"
		Content = Content .. "<br>"
		Content = Content .. "<br>"
		
		-- SELECTING POINT
		Content = Content .. "<h4>Point regeneration:</h4> X, Z"
		Content = Content .. "<form method='POST'>"
		Content = Content .. "<input type='text' name='FormPointX' value='0'><input type='text' name='FormPointZ' value='0'>"
		Content = Content .. "<input type='submit' name='PointExact' value='Exact'>"
		Content = Content .. "<input type='submit' name='Point3x3' value='3x3'>"
		Content = Content .. "</form>"
		
		-- SELECTING PLAYERS
		Content = Content .. "<h4>Player-based regeneration:</h4>"
		Content = Content .. "<table>"
		local PlayerNum = 0
		local AddPlayerToTable = function( Player )
			PlayerNum = PlayerNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. PlayerNum .. ".</td>"
			Content = Content .. "<td>" .. Player:GetName() .. "</td>"
			Content = Content .. "<td>" .. Buttons_Player(Player:GetName()) .. "</td>"
			Content = Content .. "</tr>"
		end
		if (cRoot:Get():GetWorld(WORK_WORLD) == nil) then
			Content = Content .. "<tr><td>Incorrect world selection</td></tr>"
		else
			cRoot:Get():GetWorld(WORK_WORLD):ForEachPlayer( AddPlayerToTable )
			if( PlayerNum == 0 ) then
				Content = Content .. "<tr><td>No connected players</td></tr>"
			end
		end
		Content = Content .. "</table>"
		Content = Content .. "<br>"
	return Content
end