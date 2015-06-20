function HandleListCommand(Split, Player)
	local PlayerTable = {}

	local ForEachPlayer = function(a_Player)
		table.insert(PlayerTable, a_Player:GetName())
	end
	cRoot:Get():ForEachPlayer(ForEachPlayer)
	table.sort(PlayerTable)

	Player:SendMessageInfo("Players (" .. #PlayerTable .. "): " .. table.concat(PlayerTable, ", "))
	return true
end
