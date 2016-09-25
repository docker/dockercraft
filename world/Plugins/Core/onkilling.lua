
-- onkilling.lua

-- Implements the OnKilling hook handler that effectively implements the hardcore mode of the server





--- Handler for the HOOK_KILLING hook
-- If the server is in hardcore mode, bans the killed player
function OnKilling(a_Victim, a_Killer)
	if (a_Victim:IsPlayer()) then
		if (cRoot:Get():GetServer():IsHardcore()) then
			AddPlayerToBanlist(a_Victim:GetName(), "Killed in hardcore mode", "Server-Core")
		end
	end

	return false
end




