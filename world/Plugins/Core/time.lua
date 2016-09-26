-- Implements time related commands and console commands


local PlayerTimeAddCommandUsage = "Usage: /time add <value> [world]"
local PlayerTimeSetCommandUsage = "Usage: /time set <day|night|value> [world]"
local ConsoleSetTimeCommandUsage = "Usage: time set <day|night|value> [world]"
local ConsoleAddTimeCommandUsage = "Usage: time add <value> [world]"

-- Times of day and night as defined in vanilla minecraft
local SpecialTimesTable = {
	["day"] = 1000,
	["night"] = 1000 + 12000,
}

-- Used to animate the transition between previous and new times
local function SetTime( World, TimeToSet )

	local CurrentTime = World:GetTimeOfDay()
	local MaxTime = 24000

	-- Handle the cases where TimeToSet < 0 or > 24000
	TimeToSet = TimeToSet % MaxTime

	local AnimationForward = true
	local AnimationSpeed = 480

	if CurrentTime > TimeToSet then
		AnimationForward = false
		AnimationSpeed = -AnimationSpeed
	end

	local function DoAnimation()
		local TimeOfDay = World:GetTimeOfDay()
		if AnimationForward then
			if TimeOfDay < TimeToSet and (MaxTime - TimeToSet) > AnimationSpeed then -- Without the second check the animation can get stuck in a infinite loop
				World:SetTimeOfDay(TimeOfDay + AnimationSpeed)
				World:ScheduleTask(1, DoAnimation)
			else
				World:SetTimeOfDay(TimeToSet) -- Make sure we actually get the time that was asked for.
			end
		else
			if TimeOfDay > TimeToSet then
				World:SetTimeOfDay(TimeOfDay + AnimationSpeed)
				World:ScheduleTask(1, DoAnimation)
			else
				World:SetTimeOfDay(TimeToSet) -- Make sure we actually get the time that was asked for.
			end
		end
	end

	World:ScheduleTask(1, DoAnimation)
	World:BroadcastChatSuccess("Time was set to " .. TimeToSet)
	LOG("Time in world \"" .. World:GetName() .. "\" was set to " .. TimeToSet) -- Let the console know about time changes

	return true
end


-- Code common to console and in-game `time add` command
local function CommonAddTime( World, Time )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	local TimeToAdd = tonumber( Time )

	if not TimeToAdd then
		return false
	end

	local TimeToSet = World:GetTimeOfDay() + TimeToAdd
	SetTime( World, TimeToSet )
	
	return true
end


-- Handler for "/time add <amount> [world]" subcommand 
function HandleAddTimeCommand( Split, Player )

	if not CommonAddTime( GetWorld( Split[4], Player ), Split[3] ) then
		SendMessage( Player, PlayerTimeAddCommandUsage )
	end

	return true
end


-- Handler for console command: time add <value> [WorldName]
function HandleConsoleAddTime(a_Split)

	if not CommonAddTime( GetWorld( a_Split[4] ), a_Split[3] ) then
		LOG(ConsoleAddTimeCommandUsage)
	end

	return true
end


-- Code common to console and in-game `time set` command
local function CommonSetTime( World, Time )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	-- Handle the vanilla cases of /time set <day|night>, for compatibility
	local TimeToSet = SpecialTimesTable[Time] or tonumber(Time)
	
	if not TimeToSet then
		return false
	else
		SetTime( World, TimeToSet )
	end

	return true
end


-- Handler for "/time set <value> [world]" subcommand 
function HandleSetTimeCommand( Split, Player )

	if not CommonSetTime( GetWorld( Split[4], Player ), Split[3] ) then
		SendMessage( Player, PlayerTimeSetCommandUsage )
	end

	return true

end


-- Handler for console command: time set <day|night|value> [world]
function HandleConsoleSetTime(a_Split)

	if not CommonSetTime( GetWorld( a_Split[4] ), a_Split[3] ) then
		LOG(ConsoleSetTimeCommandUsage)
	end
	
	return true
end


-- Code common to console and in-game time <day|night> commands
local function CommonSpecialTime( World, TimeName )

	-- Stop if an invalid world was given
	if not World then
		return true
	end
	
	SetTime( World, SpecialTimesTable[TimeName] )

	return true
end


-- Handler for /time <day|night> [world]
function HandleSpecialTimeCommand( Split, Player )

	return CommonSpecialTime( GetWorld( Split[3], Player ), Split[2] )

end


-- Handler for console command: time <day|night> [world]
function HandleConsoleSpecialTime(a_Split)

	return CommonSpecialTime( GetWorld( a_Split[3] ), a_Split[2] )

end


-- Handler for /time query daytime [world]
function HandleQueryDaytimeCommand( Split, Player )

	local World = GetWorld( Split[4], Player )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	SendMessage( Player, "The current time in World \"" .. World:GetName() .. "\" is " .. World:GetTimeOfDay() )

	return true
end


-- Handler for console command: time query daytime [world]
function HandleConsoleQueryDaytime(a_Split)

	local World = GetWorld( a_Split[4] )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	LOG( "The current time in World \"" .. World:GetName() .. "\" is " .. World:GetTimeOfDay() )

	return true
end


-- Handler for /time query gametime [world]
function HandleQueryGametimeCommand( Split, Player )

	local World = GetWorld( Split[4], Player )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	SendMessage( Player, "The World \"" .. World:GetName() .. "\" has existed for " .. World:GetWorldAge() )

	return true
end


-- Handler for console command: time query gametime [world]
function HandleConsoleQueryGametime(a_Split)

	local World = GetWorld( a_Split[4] )

	-- Stop if an invalid world was given
	if not World then
		return true
	end

	LOG( "The World \"" .. World:GetName() .. "\" has existed for " .. World:GetWorldAge() )

	return true
end
