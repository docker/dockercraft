function OnKilling(Victim, Killer)
	if Victim:IsPlayer() then
		SetBackCoordinates(Victim)
		CheckHardcore(Victim)
	end
	
	return false
end
