
-- web_plugins.lua

-- Implements the Plugins web tab used to manage plugins on the server

--[[
General info: The web handler loads the settings.ini file in its start, and reads the list of enabled
plugins out of it. Then it processes any changes requested by the user through the buttons; it carries out
those changes on the list of enabled plugins itself. Then it saves that list back to the settings.ini. The
changes aren't applied until the user expliticly clicks on "reload", since some changes require more than
single reloads of the page (such as enabling a plugin and moving it into place using the up / down buttons).
--]]





-- Stores whether the plugin list has changed and thus the server needs to reload plugins
-- Has to be defined outside so that it keeps its value across multiple calls to the handler.
local g_NeedsReload = false





--- Returns an array of plugin names that are enabled, in their load order
local function LoadEnabledPlugins(SettingsIni)
	local res = {};
	local IniKeyPlugins = SettingsIni:FindKey("Plugins")
	if (IniKeyPlugins == cIniFile.noID) then
		-- No [Plugins] key in the INI file
		return {}
	end
	
	-- Scan each value, remember each that is named "plugin"
	for idx = 0, SettingsIni:GetNumValues(IniKeyPlugins) - 1 do
		if (string.lower(SettingsIni:GetValueName(IniKeyPlugins, idx)) == "plugin") then
			table.insert(res, SettingsIni:GetValue(IniKeyPlugins, idx))
		end
	end
	return res
end





--- Saves the list of enabled plugins into the ini file
-- Keeps all the other values in the ini file intact
local function SaveEnabledPlugins(SettingsIni, EnabledPlugins)
	-- First remove all values named "plugin":
	local IniKeyPlugins = SettingsIni:FindKey("Plugins")
	if (IniKeyPlugins ~= cIniFile.noID) then
		for idx = SettingsIni:GetNumValues(IniKeyPlugins) - 1, 0, -1 do
			if (string.lower(SettingsIni:GetValueName(IniKeyPlugins, idx)) == "plugin") then
				SettingsIni:DeleteValueByID(IniKeyPlugins, idx)
			end
		end
	end
	
	-- Now add back the entire list of enabled plugins, in our order:
	for idx, name in ipairs(EnabledPlugins) do
		SettingsIni:AddValue("Plugins", "Plugin", name)
	end
	
	-- Save to file:
	SettingsIni:WriteFile("settings.ini")
	
	-- Mark the settings as changed:
	g_NeedsReload = true
end





--- Returns the lists of Enabled and Disabled plugins
-- Each list's item is a table describing the plugin - has Name, Folder, Status and LoadError
-- a_EnabledPluginFolders is an array of strings read from settings.ini listing the enabled plugins in their load order
local function GetPluginLists(a_EnabledPluginFolders)
	-- Convert a_EnabledPluginFolders into a map {Folder -> true}:
	local EnabledPluginFolderMap = {}
	for _, folder in ipairs(a_EnabledPluginFolders) do
		EnabledPluginFolderMap[folder] = true
	end
	
	-- Retrieve a map of all known plugins:
	local PM = cPluginManager:Get()
	PM:RefreshPluginList()
	local Plugins = {}  -- map {PluginFolder -> plugin}
	PM:ForEachPlugin(
		function (a_CBPlugin)
			local plugin =
			{
				Name = a_CBPlugin:GetName(),
				Folder = a_CBPlugin:GetFolderName(),
				Status = a_CBPlugin:GetStatus(),
				LoadError = a_CBPlugin:GetLoadError()
			}
			Plugins[plugin.Folder] = plugin
		end
	)
	
	-- Process the information about enabled plugins:
	local EnabledPlugins = {}
	for _, plgFolder in ipairs(a_EnabledPluginFolders) do
		table.insert(EnabledPlugins, Plugins[plgFolder])
	end
	
	-- Pick up all the disabled plugins:
	local DisabledPlugins = {}
	for folder, plugin in pairs(Plugins) do
		if not(EnabledPluginFolderMap[folder]) then
			table.insert(DisabledPlugins, plugin)
		end
	end
	
	-- Sort the disabled plugin array:
	table.sort(DisabledPlugins,
		function (a_Plugin1, a_Plugin2)
			return (string.lower(a_Plugin1.Folder) < string.lower(a_Plugin2.Folder))
		end
	)
	-- Do NOT sort EnabledPlugins - we want them listed in their load order instead!
	
	return EnabledPlugins, DisabledPlugins
end





--- Builds an HTML table containing the list of plugins
-- First the enabled plugins are listed in their load order. If any is manually unloaded or errored, it is marked as such.
-- Then an alpha-sorted list of the disabled plugins
local function ListCurrentPlugins(a_EnabledPluginFolders)
	local EnabledPlugins, DisabledPlugins = GetPluginLists(a_EnabledPluginFolders)
	
	-- Output the EnabledPlugins table:
	local res = {}
	local ins = table.insert
	if (#EnabledPlugins > 0) then
		ins(res, [[
			<h4>Enabled plugins</h4>
			<p>These plugins are enabled in the server settings:</p>
			<table>
			]]
		);
		local Num = #EnabledPlugins
		for idx, plugin in pairs(EnabledPlugins) do
			-- Move and Disable buttons:
			ins(res, "<tr><td>")
			if (idx == 1) then
				ins(res, [[<button type="button" disabled>Move Up</button> </td>]])
			else
				ins(res, '<form method="POST"><input type="hidden" name="PluginFolder" value="')
				ins(res, plugin.Folder)
				ins(res, '"><input type="submit" name="MoveUp" value="Move Up"></form></td>')
			end
			ins(res, [[<td>]])
			if (idx == Num) then
				ins(res, '<button type="button" disabled>Move Down</button></td>')
			else
				ins(res, '<form method="POST"><input type="hidden" name="PluginFolder" value="')
				ins(res, plugin.Folder)
				ins(res, '"><input type="submit" name="MoveDown" value="Move Down"></form></td>')
			end
			ins(res, '<td><form method="POST"><input type="hidden" name="PluginFolder" value="')
			ins(res, plugin.Folder)
			ins(res, '"><input type="submit" name="DisablePlugin" value="Disable"></form></td>')

			-- Plugin name and, if different, folder:
			ins(res, "<td nowrap>")
			ins(res, plugin.Folder)
			if (plugin.Folder ~= plugin.Name) then
				ins(res, " (API name ")
				ins(res, plugin.Name)
				ins(res, ")")
			end
			
			-- Plugin status, if not psLoaded:
			ins(res, "</td><td width='100%'>")
			if (plugin.Status == cPluginManager.psUnloaded) then
				ins(res, "<i>(currently unloaded)</i>")
			elseif (plugin.Status == cPluginManager.psNotFound) then
				ins(res, "<i>(files missing on disk)</i>")
			elseif (plugin.Status == cPluginManager.psError) then
				ins(res, "<b style='color: red'>")
				if ((plugin.LoadError == nil) or (plugin.LoadError == "")) then
					ins(res, "Unknown load error")
				else
					ins(res, plugin.LoadError)
				end
				ins(res, "</b>")
			end
			ins(res, "</td></tr>")
		end
		ins(res, "</table><br />")
	end
	
	-- Output DisabledPlugins table:
	if (#DisabledPlugins > 0) then
		ins(res, [[<hr /><h4>Disabled plugins</h4>
			<p>These plugins are installed, but are disabled in the configuration.</p>
			<table>]]
		)
		for idx, plugin in ipairs(DisabledPlugins) do
			ins(res, '<tr><td><form method="POST"><input type="hidden" name="PluginFolder" value="')
			ins(res, plugin.Folder)
			ins(res, '"><input type="submit" name="EnablePlugin" value="Enable"></form></td><td width=\"100%\">')
			ins(res, plugin.Name)
			ins(res, "</td></tr>")
		end
		ins(res, "</table><br />")
	end
	
	return table.concat(res, "")
end





--- Disables the specified plugin
-- Saves the new set of enabled plugins into a_SettingsIni
-- Returns true if the plugin was disabled
local function DisablePlugin(a_SettingsIni, a_PluginFolder, a_EnabledPlugins)
	for idx, name in ipairs(a_EnabledPlugins) do
		if (name == a_PluginFolder) then
			table.remove(a_EnabledPlugins, idx)
			SaveEnabledPlugins(a_SettingsIni, a_EnabledPlugins)
			return true
		end
	end
	return false
end





--- Enables the specified plugin
-- Saves the new set of enabled plugins into SettingsIni
-- Returns true if the plugin was enabled (false if it was already enabled before)
local function EnablePlugin(SettingsIni, PluginName, EnabledPlugins)
	for idx, name in ipairs(EnabledPlugins) do
		if (name == PluginName) then
			-- Plugin already enabled, ignore this call
			return false
		end
	end
	-- Add the plugin to the end of the list, save:
	table.insert(EnabledPlugins, PluginName)
	SaveEnabledPlugins(SettingsIni, EnabledPlugins)
	return true
end





--- Moves the specified plugin up or down by the specified delta
-- Saves the new order into SettingsIni
-- Returns true if the plugin was moved, false if not (bad delta / not found)
local function MovePlugin(SettingsIni, PluginName, IndexDelta, EnabledPlugins)
	for idx, name in ipairs(EnabledPlugins) do
		if (name == PluginName) then
			local DstIdx = idx + IndexDelta
			if ((DstIdx < 1) or (DstIdx > #EnabledPlugins)) then
				LOGWARNING("Core WebAdmin: Requesting moving the plugin " .. PluginName .. " to invalid index " .. DstIdx .. " (max idx " .. #EnabledPlugins .. "); ignoring.")
				return false
			end
			EnabledPlugins[idx], EnabledPlugins[DstIdx] = EnabledPlugins[DstIdx], EnabledPlugins[idx]  -- swap the two - we're expecting ony +1 / -1 moves
			SaveEnabledPlugins(SettingsIni, EnabledPlugins)
			return true
		end
	end
	
	-- Plugin not found:
	return false
end





--- Processes the actions specified by the request parameters
-- Modifies EnabledPlugins directly to reflect the action
-- Returns the notification text to be displayed at the top of the page
local function ProcessRequestActions(SettingsIni, Request, EnabledPlugins)
	local PluginFolder = Request.PostParams["PluginFolder"]
	if (PluginFolder == nil) then
		-- PluginFolder was not provided, so there's no action to perform
		return
	end
	
	if (Request.PostParams["DisablePlugin"] ~= nil) then
		if (DisablePlugin(SettingsIni, PluginFolder, EnabledPlugins)) then
			return '<p style="color: green;"><b>You disabled plugin: "' .. PluginFolder .. '"</b></p>'
		end
	elseif (Request.PostParams["EnablePlugin"] ~= nil) then
		if (EnablePlugin(SettingsIni, PluginFolder, EnabledPlugins)) then
			return '<p style="color: green;"><b>You enabled plugin: "' .. PluginFolder .. '"</b></p>'
		end
	elseif (Request.PostParams["MoveUp"] ~= nil) then
		MovePlugin(SettingsIni, PluginFolder, -1, EnabledPlugins)
	elseif (Request.PostParams["MoveDown"] ~= nil) then
		MovePlugin(SettingsIni, PluginFolder,  1, EnabledPlugins)
	end
end





function HandleRequest_ManagePlugins(Request)
	local Content = ""
		
	if (Request.PostParams["reload"] ~= nil) then
		Content = Content .. "<head><meta http-equiv=\"refresh\" content=\"5;\"></head>"
		Content = Content .. "<p>Reloading plugins... This can take a while depending on the plugins you're using.</p>"
		cRoot:Get():GetPluginManager():ReloadPlugins()
		return Content
	end

	local SettingsIni = cIniFile()
	SettingsIni:ReadFile("settings.ini")

	local EnabledPlugins = LoadEnabledPlugins(SettingsIni)
	
	local NotificationText = ProcessRequestActions(SettingsIni, Request, EnabledPlugins)
	Content = Content .. (NotificationText or "")
	
	if (g_NeedsReload) then
		Content = Content .. [[
			<form method='POST'>
			<p class="warn"><b>
			You need to reload the plugins in order for the changes to take effect.
			&nbsp;<input type='submit' name='reload' value='Reload now!'>
			</b></p></form>
		]]
	end
	
	Content = Content .. ListCurrentPlugins(EnabledPlugins)
	
	Content = Content .. [[<hr />
	<h4>Reload</h4>
	<form method='POST'>
	<p>Click the reload button to reload all plugins.
	<input type='submit' name='reload' value='Reload!'></p>
	</form>]]
	return Content
end




