function Initialize(a_Plugin)
	a_Plugin:SetName("DumpInfo")
	a_Plugin:SetVersion(1)
	
	-- Check if the infodump file exists.
	if (not cFile:IsFile("Plugins/InfoDump.lua")) then
		LOGWARN("[DumpInfo] InfoDump.lua was not found.")
		return false
	end
	
	-- Add the webtab.
	a_Plugin:AddWebTab("DumpPlugin", HandleDumpPluginRequest)
	return true
end





function HandleDumpPluginRequest(a_Request)
	local Content = ""
	
	-- Check if it already was requested to dump a plugin.
	if (a_Request.PostParams["DumpInfo"] ~= nil) then
		local F = loadfile("Plugins/InfoDump.lua")
		F("Plugins/" .. a_Request.PostParams["DumpInfo"])
	end
	
	Content = Content .. [[
<table>
	<tr>
		<th colspan="2">DumpInfo</th>
	</tr>]]

	-- Loop through each plugin that is found.
	cPluginManager:Get():ForEachPlugin(
		function(a_Plugin)
			-- Check if there is a file called 'Info.lua'
			if (cFile:IsFile("Plugins/" .. a_Plugin:GetName() .. "/Info.lua")) then
				Content = Content .. "\n<tr>\n"
				Content = Content .. "\t<td>" .. a_Plugin:GetName() .. "</td>\n"
				Content = Content .. "\t<td><form method='POST'> <input type='hidden' value='" .. a_Plugin:GetName() .. "' name='DumpInfo'> <input type='submit' value='DumpInfo'></form></td>\n"
				Content = Content .. "</tr>\n"
			end
		end
	)
	
	Content = Content .. [[
</table>]]

	return Content
end
