TpsCache = {}
GlobalTps = {}


--- Handles console tps command, wrapper to HandleTpsCommand function
--  Necessary due to MCServer now supplying additional parameters
--  
function HandleConsoleTps(Split, FullCmd)
	return HandleTpsCommand(Split)
end


function HandleTpsCommand(Split, Player)
	if (Player ~= nil) then
		Player:SendMessageInfo("Global TPS: " .. GetAverageNum(GlobalTps))
		for WorldName, WorldTps in pairs(TpsCache) do
			Player:SendMessageInfo("World '" .. WorldName .. "': " .. GetAverageNum(WorldTps) .. " TPS");
		end
	else
		LOG("Global TPS: " .. GetAverageNum(GlobalTps))
		for WorldName, WorldTps in pairs(TpsCache) do
			LOG("World '" .. WorldName .. "': " .. GetAverageNum(WorldTps) .. " TPS");
		end
	end
	return true
end


function GetAverageNum(Table)
	local Sum = 0
	for i,Num in ipairs(Table) do
		Sum = Sum + Num
	end
	return (Sum / #Table)
end

function OnWorldTick(World, TimeDelta)
	local WorldTps = TpsCache[World:GetName()]
	if (WorldTps == nil) then
		WorldTps = {}
		TpsCache[World:GetName()] = WorldTps
	end

	if (#WorldTps >= 10) then
		table.remove(WorldTps, 1)
	end

	table.insert(WorldTps, 1000 / TimeDelta)
end

function OnTick(TimeDelta)
	if (#GlobalTps >= 10) then
		table.remove(GlobalTps, 1)
	end

	table.insert(GlobalTps, 1000 / TimeDelta)
end
