-- Implements weather related commands and console commands


-- Translate from weather descriptors to the weather value
-- Non-Vanilla weather descriptors were kept from previous console implementation
local WeatherNames =
{
	["clear"]        = wSunny,
	["sunny"]        = wSunny,
	["sun"]          = wSunny,
	["rain"]         = wRain,
	["rainy"]        = wRain,
	["storm"]        = wStorm,
	["thunder"]      = wStorm,
	["thunderstorm"] = wStorm,
	["lightning"]    = wStorm,
}


-- Strings displayed when changing to the specified weather conditions
local WeatherChanges =
{
	[wSunny] = "Changing to clear weather in world: ",
	[wRain]  = "Changing to rainy weather in world: ",
	[wStorm] = "Changing to rain and thunder in world: ",
}

local ToggleDownfall = "Toggled downfall in world: "

local WeatherUsage        = "Usage: /weather <clear|rain|thunder> [duration in seconds] [world]"
local WeatherConsoleUsage = "Usage: weather <clear|rain|thunder> [duration in seconds] [world]"


--- Handle the weather console command, wrapper for HandleWeatherCommand
--  Necessary due to Cuberite now supplying additional parameters
--  
function HandleConsoleWeather( Split, FullCmd )
	return HandleWeatherCommand( Split )
end


--- Handles In-game and Console `weather` commands
-- 
--  @param Player is nil when called by console command
--  
function HandleWeatherCommand( Split, Player )

	-- Parse the command into its components
	local Weather = WeatherNames[Split[2]]
	local TPS = 20
	local TicksToChange = ( tonumber( Split[3] ) or 0 ) * TPS
	local WorldName = Split[4]

	if TicksToChange == 0 then
		WorldName = Split[3]
	end
	
	local World = GetWorld( WorldName, Player )  -- Function is in functions.lua

	-- If an invalid weather string is given, exit
	if not Weather then
		if Player then
			SendMessage( Player, WeatherUsage )
		else
			LOG( WeatherConsoleUsage )
		end
		return true
	end

	-- If an invalid world is given, exit
	if not World then
		return true
	end

	World:SetWeather( Weather )

	if TicksToChange ~= 0 then
		World:SetTicksUntilWeatherChange( TicksToChange )
	end

	local Message = WeatherChanges[Weather] .. World:GetName()

	if Player then
		SendMessageSuccess( Player, Message )
	end
	local Byline = Player and Player:GetName() or "console"
	LOG( Message .. " by: " .. Byline )

	return true
end


--- Handle the downfall console command, wrapper for HandleGiveCommand
--  Necessary due to Cuberite now supplying additional parameters
--  
function HandleConsoleDownfall( Split, FullCmd )
	return HandleDownfallCommand( Split )
end


--- Handles in-game and console `toggledownfall` command
--  Command Usage: `toggledownfall [world]'
-- 
--  @param Player is nil when called by console command
--
function HandleDownfallCommand( Split, Player )

	local World = GetWorld( Split[2], Player )  -- In functions.lua

	-- If an invalid world is given, exit
	if not World then
		return true
	end

	-- Toggle between sun and rain
	World:SetWeather( World:IsWeatherWet() and wSunny or wRain )

	local Message = ToggleDownfall .. World:GetName()
	if Player then
		SendMessageSuccess( Player, Message )
	end

	local Byline = Player and Player:GetName() or "console"
	LOG( Message .. " by: " .. Byline )

	return true
end
