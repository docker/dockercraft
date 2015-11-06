function OnKilling(Victim, Killer)
	if Victim:IsPlayer() then
		CheckHardcore(Victim)
	end
	
	return false
end
