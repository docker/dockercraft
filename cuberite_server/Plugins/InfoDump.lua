#!/usr/bin/lua

-- InfoDump.lua

--[[
Loads plugins' Info.lua and dumps its g_PluginInfo into various text formats
This is used for generating plugin documentation for the forum and for GitHub's INFO.md files

This script can be used in two ways:
Executing "lua InfoDump.lua" will go through all subfolders and dump each Info.lua file it can find
	Note that this mode of operation requires LuaRocks with LFS installed; instructions are printed
	when the prerequisites are not met.
Executing "lua InfoDump.lua PluginName" will load the Info.lua file from PluginName's folder and dump
only that one plugin's documentation. This mode of operation doesn't require LuaRocks
--]]





-- If this file is called using the loadfile function the arg variable isn't filled. We have to do it manualy then.
local arg = arg or {...}





-- Check Lua version. We use 5.1-specific construct when loading the plugin info, 5.2 is not compatible!
if (_VERSION ~= "Lua 5.1") then
	print("Unsupported Lua version. This script requires Lua version 5.1, this Lua is version " .. (_VERSION or "<nil>"))
	return
end





--- Replaces generic formatting with forum-specific formatting
-- Also removes the single line-ends
local function ForumizeString(a_Str)
	assert(type(a_Str) == "string")
	
	-- Remove the indentation, unless in the code tag:
	-- Only one code or /code tag per line is supported!
	local IsInCode = false
	local function RemoveIndentIfNotInCode(s)
		if (IsInCode) then
			-- we're in code section, check if this line terminates it
			IsInCode = (s:find("{%%/code}") ~= nil)
			return s .. "\n"
		else
			-- we're not in code section, check if this line starts it
			IsInCode = (s:find("{%%code}") ~= nil)
			return s:gsub("^%s*", "") .. "\n"
		end
	end
	a_Str = a_Str:gsub("(.-)\n", RemoveIndentIfNotInCode)
	
	-- Replace multiple line ends with {%p} and single line ends with a space,
	-- so that manual word-wrap in the Info.lua file doesn't wrap in the forum.
	a_Str = a_Str:gsub("\n\n", "{%%p}")
	a_Str = a_Str:gsub("\n", " ")
	
	-- Replace the generic formatting:
	a_Str = a_Str:gsub("{%%p}", "\n\n")
	a_Str = a_Str:gsub("{%%b}", "[b]"):gsub("{%%/b}", "[/b]")
	a_Str = a_Str:gsub("{%%i}", "[i]"):gsub("{%%/i}", "[/i]")
	a_Str = a_Str:gsub("{%%list}", "\n[list]"):gsub("{%%/list}", "[/list]")
	a_Str = a_Str:gsub("{%%li}", "\n[*]"):gsub("{%%/li}", "\n")
	
	-- Process links: {%a LinkDestination}LinkText{%/a}
	a_Str = a_Str:gsub("{%%a%s([^}]*)}([^{]*){%%/a}", "[url=%1]%2[/url]")
	
	-- TODO: Other formatting
	
	return a_Str
end





--- Replaces generic formatting with forum-specific formatting
-- Also removes the single line-ends
local function GithubizeString(a_Str)
	assert(type(a_Str) == "string")
	
	-- Remove the indentation, unless in the code tag:
	-- Only one code or /code tag per line is supported!
	local IsInCode = false
	local function RemoveIndentIfNotInCode(s)
		if (IsInCode) then
			-- we're in code section, check if this line terminates it
			IsInCode = (s:find("{%%/code}") ~= nil)
			return s .. "\n"
		else
			-- we're not in code section, check if this line starts it
			IsInCode = (s:find("{%%code}") ~= nil)
			return s:gsub("^%s*", "") .. "\n"
		end
	end
	a_Str = a_Str:gsub("(.-)\n", RemoveIndentIfNotInCode)
	
	-- Replace multiple line ends with {%p} and single line ends with a space,
	-- so that manual word-wrap in the Info.lua file doesn't wrap in the forum.
	a_Str = a_Str:gsub("\n\n", "{%%p}")
	a_Str = a_Str:gsub("\n", " ")
	
	-- Replace the generic formatting:
	a_Str = a_Str:gsub("{%%p}", "\n\n")
	a_Str = a_Str:gsub("{%%b}", "**"):gsub("{%%/b}", "**")
	a_Str = a_Str:gsub("{%%i}", "*"):gsub("{%%/i}", "*")
	a_Str = a_Str:gsub("{%%list}", "\n"):gsub("{%%/list}", "\n")
	a_Str = a_Str:gsub("{%%li}", "\n - "):gsub("{%%/li}", "")

	-- Process links: {%a LinkDestination}LinkText{%/a}
	a_Str = a_Str:gsub("{%%a%s([^}]*)}([^{]*){%%/a}", "[%2](%1)")
	
	-- TODO: Other formatting
	
	return a_Str
end





--- Builds an array of categories, each containing all the commands belonging to the category,
-- and the category description, if available.
-- Returns the array table, each item has the following format:
-- { Name = "CategoryName", Description = "CategoryDescription", Commands = {{CommandString = "/cmd verb", Info = {...}}, ...}}
local function BuildCategories(a_PluginInfo)
	-- The returned result
	-- This will contain both an array and a dict of the categories, to allow fast search
	local res = {}
	
	-- For each command add a reference to it into all of its categories:
	local function AddCommands(a_CmdPrefix, a_Commands)
		for cmd, info in pairs(a_Commands or {}) do
			local NewCmd =
			{
				CommandString = a_CmdPrefix .. cmd,
				Info = info,
			}
			
			if ((info.HelpString ~= nil) and (info.HelpString ~= "")) then
				-- Add to each specified category:
				local Category = info.Category
				if (type(Category) == "string") then
					Category = {Category}
				end
				for idx, cat in ipairs(Category or {""}) do
					local CatEntry = res[cat]
					if (CatEntry == nil) then
						-- First time we came across this category, create it:
						local NewCat = {Name = cat, Description = "", Commands = {NewCmd}}
						table.insert(res, NewCat)
						res[cat] = NewCat
					else
						-- We already have this category, just add the command to its list of commands:
						table.insert(CatEntry.Commands, NewCmd)
					end
				end  -- for idx, cat - Category[]
			end  -- if (HelpString valid)
			
			-- Recurse all subcommands:
			if (info.Subcommands ~= nil) then
				AddCommands(a_CmdPrefix .. cmd .. " ", info.Subcommands)
			end
		end  -- for cmd, info - a_Commands[]
	end  -- AddCommands()
	
	AddCommands("", a_PluginInfo.Commands)
	
	-- Assign descriptions to categories:
	for name, desc in pairs(a_PluginInfo.Categories or {}) do
		local CatEntry = res[name]
		if (CatEntry ~= nil) then
			-- The result has this category, add the description:
			CatEntry.Description = desc.Description
		end
	end
	
	-- Alpha-sort each category's command list:
	for idx, cat in ipairs(res) do
		table.sort(cat.Commands,
			function (cmd1, cmd2)
				return (string.lower(cmd1.CommandString) < string.lower(cmd2.CommandString))
			end
		)
	end
	
	return res
end





--- Returns a string specifying the command.
-- If a_Command is a simple string, returns a_Command colorized to blue
-- If a_Command is a table, expects members Name (full command name) and Params (command parameters),
-- colorizes command name blue and params green
local function GetCommandRefForum(a_Command)
	if (type(a_Command) == "string") then
		return "[color=blue]" .. a_Command .. "[/color]"
	end
	return "[color=blue]" .. a_Command.Name .. "[/color] [color=green]" .. (a_Command.Params or "") .. "[/color]"
end





--- Returns a string specifying the command.
-- If a_CommandParams is nil, returns a_CommandName apostrophed
-- If a_CommandParams is a string, apostrophes a_CommandName with a_CommandParams
local function GetCommandRefGithub(a_CommandName, a_CommandParams)
	assert(type(a_CommandName) == "string")
	if (a_CommandParams == nil) then
		return "`" .. a_CommandName .. "`"
	end
	
	assert(type(a_CommandParams) == "table")
	if ((a_CommandParams.Params == nil) or (a_CommandParams.Params == "")) then
		return "`" .. a_CommandName .. "`"
	end

	assert(type(a_CommandParams.Params) == "string")
	return "`" .. a_CommandName .. " " .. a_CommandParams.Params .. "`"
end





--- Writes the specified command detailed help array to the output file, in the forum dump format
local function WriteCommandParameterCombinationsForum(a_CmdString, a_ParameterCombinations, f)
	assert(type(a_CmdString) == "string")
	assert(type(a_ParameterCombinations) == "table")
	assert(f ~= nil)
	
	if (#a_ParameterCombinations == 0) then
		-- No explicit parameter combinations to write
		return
	end
	
	f:write("The following parameter combinations are recognized:\n")
	for idx, combination in ipairs(a_ParameterCombinations) do
		f:write("[color=blue]", a_CmdString, "[/color] [color=green]", combination.Params or "", "[/color]")
		if (combination.Help ~= nil) then
			f:write(" - ", ForumizeString(combination.Help))
		end
		if (combination.Permission ~= nil) then
			f:write(" (Requires permission '[color=red]", combination.Permission, "[/color]')")
		end
		f:write("\n")
	end
end





--- Writes the specified command detailed help array to the output file, in the forum dump format
local function WriteCommandParameterCombinationsGithub(a_CmdString, a_ParameterCombinations, f)
	assert(type(a_CmdString) == "string")
	assert(type(a_ParameterCombinations) == "table")
	assert(f ~= nil)
	
	if (#a_ParameterCombinations == 0) then
		-- No explicit parameter combinations to write
		return
	end
	
	f:write("The following parameter combinations are recognized:\n\n")
	for idx, combination in ipairs(a_ParameterCombinations) do
		f:write(GetCommandRefGithub(a_CmdString, combination))
		if (combination.Help ~= nil) then
			f:write(" - ", GithubizeString(combination.Help))
		end
		if (combination.Permission ~= nil) then
			f:write("   (Requires permission '**", combination.Permission, "**')")
		end
		f:write("\n")
	end
end





--- Writes all commands in the specified category to the output file, in the forum dump format
local function WriteCommandsCategoryForum(a_Category, f)
	-- Write category name:
	local CategoryName = a_Category.Name
	if (CategoryName == "") then
		CategoryName = "General"
	end
	f:write("\n[size=Large]", ForumizeString(a_Category.DisplayName or CategoryName), "[/size]\n")
	
	-- Write description:
	if (a_Category.Description ~= "") then
		f:write(ForumizeString(a_Category.Description), "\n")
	end
	
	-- Write commands:
	f:write("\n[list]")
	for idx2, cmd in ipairs(a_Category.Commands) do
		f:write("\n[b]", cmd.CommandString, "[/b] - ", ForumizeString(cmd.Info.HelpString or "UNDOCUMENTED"), "\n")
		if (cmd.Info.Permission ~= nil) then
			f:write("Permission required: [color=red]", cmd.Info.Permission, "[/color]\n")
		end
		if (cmd.Info.DetailedDescription ~= nil) then
			f:write(ForumizeString(cmd.Info.DetailedDescription))
		end
		if (cmd.Info.ParameterCombinations ~= nil) then
			WriteCommandParameterCombinationsForum(cmd.CommandString, cmd.Info.ParameterCombinations, f)
		end
	end
	f:write("[/list]\n\n")
end





--- Writes all commands in the specified category to the output file, in the Github dump format
local function WriteCommandsCategoryGithub(a_Category, f)
	-- Write category name:
	local CategoryName = a_Category.Name
	if (CategoryName == "") then
		CategoryName = "General"
	end
	f:write("\n### ", GithubizeString(a_Category.DisplayName or CategoryName), "\n")
	
	-- Write description:
	if (a_Category.Description ~= "") then
		f:write(GithubizeString(a_Category.Description), "\n\n")
	end
	
	f:write("| Command | Permission | Description |\n")
	f:write("| ------- | ---------- | ----------- |\n")
	
	-- Write commands:
	for idx2, cmd in ipairs(a_Category.Commands) do
		f:write("|", cmd.CommandString, " | ", cmd.Info.Permission or "", " | ", GithubizeString(cmd.Info.HelpString or "UNDOCUMENTED"), "|\n")
	end
	f:write("\n\n")
end





local function DumpCommandsForum(a_PluginInfo, f)
	-- Copy all Categories from a dictionary into an array:
	local Categories = BuildCategories(a_PluginInfo)
	
	-- Sort the categories by name:
	table.sort(Categories,
		function(cat1, cat2)
			return (string.lower(cat1.Name) < string.lower(cat2.Name))
		end
	)
	
	if (#Categories == 0) then
		return
	end
	
	f:write("\n[size=X-Large]Commands[/size]\n")

	-- Dump per-category commands:
	for idx, cat in ipairs(Categories) do
		WriteCommandsCategoryForum(cat, f)
	end
end





local function DumpCommandsGithub(a_PluginInfo, f)
	-- Copy all Categories from a dictionary into an array:
	local Categories = BuildCategories(a_PluginInfo)
	
	-- Sort the categories by name:
	table.sort(Categories,
		function(cat1, cat2)
			return (string.lower(cat1.Name) < string.lower(cat2.Name))
		end
	)
	
	if (#Categories == 0) then
		return
	end
	
	f:write("\n# Commands\n")

	-- Dump per-category commands:
	for idx, cat in ipairs(Categories) do
		WriteCommandsCategoryGithub(cat, f)
	end
end





local function DumpAdditionalInfoForum(a_PluginInfo, f)
	local AInfo = a_PluginInfo.AdditionalInfo
	if (type(AInfo) ~= "table") then
		-- There is no AdditionalInfo in a_PluginInfo
		return
	end
	
	for idx, info in ipairs(a_PluginInfo.AdditionalInfo) do
		if ((info.Title ~= nil) and (info.Contents ~= nil)) then
			f:write("\n[size=X-Large]", ForumizeString(info.Title), "[/size]\n")
			f:write(ForumizeString(info.Contents), "\n")
		end
	end
end





local function DumpAdditionalInfoGithub(a_PluginInfo, f)
	local AInfo = a_PluginInfo.AdditionalInfo
	if (type(AInfo) ~= "table") then
		-- There is no AdditionalInfo in a_PluginInfo
		return
	end
	
	for idx, info in ipairs(a_PluginInfo.AdditionalInfo) do
		if ((info.Title ~= nil) and (info.Contents ~= nil)) then
			f:write("\n# ", GithubizeString(info.Title), "\n")
			f:write(GithubizeString(info.Contents), "\n")
		end
	end
end





--- Collects all permissions mentioned in the info, returns them as a sorted array
-- Each array item is {Name = "PermissionName", Info = { PermissionInfo }}
local function BuildPermissions(a_PluginInfo)
	-- Collect all used permissions from Commands, reference the commands that use the permission:
	local Permissions = a_PluginInfo.Permissions or {}
	local function CollectPermissions(a_CmdPrefix, a_Commands)
		for cmd, info in pairs(a_Commands or {}) do
			CommandString = a_CmdPrefix .. cmd
			if ((info.Permission ~= nil) and (info.Permission ~= "")) then
				-- Add the permission to the list of permissions:
				local Permission = Permissions[info.Permission] or {}
				Permissions[info.Permission] = Permission
				-- Add the command to the list of commands using this permission:
				Permission.CommandsAffected = Permission.CommandsAffected or {}
				-- First, make sure that we don't already have this command in the list,
				-- it may have already been present in a_PluginInfo
				local NewCommand = true
				for _, existCmd in ipairs(Permission.CommandsAffected) do
					if CommandString == existCmd then
						NewCommand = false
						break
					end
				end
				if NewCommand then
					table.insert(Permission.CommandsAffected, CommandString)
				end
			end
			
			-- Process the command param combinations for permissions:
			local ParamCombinations = info.ParameterCombinations or {}
			for idx, comb in ipairs(ParamCombinations) do
				if ((comb.Permission ~= nil) and (comb.Permission ~= "")) then
					-- Add the permission to the list of permissions:
					local Permission = Permissions[comb.Permission] or {}
					Permissions[info.Permission] = Permission
					-- Add the command to the list of commands using this permission:
					Permission.CommandsAffected = Permission.CommandsAffected or {}
					table.insert(Permission.CommandsAffected, {Name = CommandString, Params = comb.Params})
				end
			end
			
			-- Process subcommands:
			if (info.Subcommands ~= nil) then
				CollectPermissions(CommandString .. " ", info.Subcommands)
			end
		end
	end
	CollectPermissions("", a_PluginInfo.Commands)
	
	-- Copy the list of permissions to an array:
	local PermArray = {}
	for name, perm in pairs(Permissions) do
		table.insert(PermArray, {Name = name, Info = perm})
	end
	
	-- Sort the permissions array:
	table.sort(PermArray,
		function(p1, p2)
			return (p1.Name < p2.Name)
		end
	)
	return PermArray
end





local function DumpPermissionsForum(a_PluginInfo, f)
	-- Get the processed sorted array of permissions:
	local Permissions = BuildPermissions(a_PluginInfo)
	if ((Permissions == nil) or (#Permissions <= 0)) then
		return
	end

	-- Dump the permissions:
	f:write("\n[size=X-Large]Permissions[/size]\n[list]\n")
	for idx, perm in ipairs(Permissions) do
		f:write("  - [color=red]", perm.Name, "[/color] - ")
		f:write(ForumizeString(perm.Info.Description or ""))
		local CommandsAffected = perm.Info.CommandsAffected or {}
		if (#CommandsAffected > 0) then
			f:write("\n[list] Commands affected:\n- ")
			local Affects = {}
			for idx2, cmd in ipairs(CommandsAffected) do
				table.insert(Affects, GetCommandRefForum(cmd))
			end
			f:write(table.concat(Affects, "\n - "))
			f:write("\n[/list]")
		end
		if (perm.Info.RecommendedGroups ~= nil) then
			f:write("\n[list] Recommended groups: ", perm.Info.RecommendedGroups, "[/list]")
		end
		f:write("\n")
	end
	f:write("[/list]")
end





local function DumpPermissionsGithub(a_PluginInfo, f)
	-- Get the processed sorted array of permissions:
	local Permissions = BuildPermissions(a_PluginInfo)
	if ((Permissions == nil) or (#Permissions <= 0)) then
		return
	end

	-- Dump the permissions:
	f:write("\n# Permissions\n")
	f:write("| Permissions | Description | Commands | Recommended groups |\n")
	f:write("| ----------- | ----------- | -------- | ------------------ |\n")
	for idx, perm in ipairs(Permissions) do
		f:write("| ", perm.Name, " | ")
		f:write(GithubizeString(perm.Info.Description or ""), " | ")
		local CommandsAffected = perm.Info.CommandsAffected or {}
		if (#CommandsAffected > 0) then
			local Affects = {}
			for idx2, cmd in ipairs(CommandsAffected) do
				if (type(cmd) == "string") then
					table.insert(Affects, GetCommandRefGithub(cmd))
				else
					table.insert(Affects, GetCommandRefGithub(cmd.Name, cmd))
				end
			end
			f:write(table.concat(Affects, ", "))
		end
		f:write(" | ")
		if (perm.Info.RecommendedGroups ~= nil) then
			f:write(perm.Info.RecommendedGroups)
		end
		f:write(" |\n")
	end
end





--- Dumps the forum-format info for the plugin
-- Returns true on success, nil and error message on failure
local function DumpPluginInfoForum(a_PluginFolder, a_PluginInfo)
	-- Open the output file:
	local f, msg = io.open(a_PluginFolder .. "/forum_info.txt", "w")
	if (f == nil) then
		return nil, msg
	end

	-- Write the description:
	f:write(ForumizeString(a_PluginInfo.Description), "\n")
	DumpAdditionalInfoForum(a_PluginInfo, f)
	DumpCommandsForum(a_PluginInfo, f)
	DumpPermissionsForum(a_PluginInfo, f)
	if (a_PluginInfo.SourceLocation ~= nil) then
		f:write("\n[b]Source[/b]: ", a_PluginInfo.SourceLocation, "\n")
	end
	if (a_PluginInfo.DownloadLocation ~= nil) then
		f:write("[b]Download[/b]: ", a_PluginInfo.DownloadLocation)
	end
	f:close()
	return true
end





--- Dumps the README.md file into the plugin's folder with the GitHub Markdown format
-- Returns true on success, nil and error message on failure
local function DumpPluginInfoGithub(a_PluginFolder, a_PluginInfo)
	-- Check the params:
	assert(type(a_PluginFolder) == "string")
	assert(type(a_PluginInfo) == "table")
	
	-- Open the output file:
	local f, msg = io.open(a_PluginFolder .. "/README.md", "w")
	if (f == nil) then
		print("\tCannot dump github info for plugin " .. a_PluginFolder .. ": " .. msg)
		return nil, msg
	end

	-- Write the description:
	f:write(GithubizeString(a_PluginInfo.Description), "\n")
	DumpAdditionalInfoGithub(a_PluginInfo, f)
	DumpCommandsGithub(a_PluginInfo, f)
	DumpPermissionsGithub(a_PluginInfo, f)

	f:close()
	return true
end





--- Tries to load the g_PluginInfo from the plugin's Info.lua file
-- Returns the g_PluginInfo table on success, or nil and error message on failure
local function LoadPluginInfo(a_FolderName)
	-- Load and compile the Info file:
	local cfg, err = loadfile(a_FolderName .. "/Info.lua")
	if (cfg == nil) then
		return nil, "Cannot open 'Info.lua': " .. err
	end
	
	-- Execute the loaded file in a sandbox:
	-- This is Lua-5.1-specific and won't work in Lua 5.2!
	local Sandbox = {}
	setfenv(cfg, Sandbox)
	local isSuccess, errMsg = pcall(cfg)
	if not(isSuccess) then
		return nil, "Cannot load Info.lua: " .. (errMsg or "<unknown error>")
	end
	
	if (Sandbox.g_PluginInfo == nil) then
		return nil, "Info.lua doesn't contain the g_PluginInfo declaration"
	end
	return Sandbox.g_PluginInfo
end





--- Processes the info for one plugin
-- Returns true on success, nil and error message on failure
local function ProcessPluginFolder(a_FolderName)
	-- Load the plugin info:
	local PluginInfo, Msg = LoadPluginInfo(a_FolderName)
	if (PluginInfo == nil) then
		return nil, "Cannot load info for plugin " .. a_FolderName .. ": " .. (Msg or "<unknown error>")
	end
	
	-- Dump the forum format:
	local isSuccess
	isSuccess, Msg = DumpPluginInfoForum(a_FolderName, PluginInfo)
	if not(isSuccess) then
		return nil, "Cannot dump forum info for plugin " .. a_FolderName .. ": " .. (Msg or "<unknown error>")
	end
	
	-- Dump the GitHub format:
	isSuccess, Msg = DumpPluginInfoGithub(a_FolderName, PluginInfo)
	if not(isSuccess) then
		return nil, "Cannot dump GitHub info for plugin " .. a_FolderName .. ": " .. (Msg or "<unknown error>")
	end

	-- All OK, return success
	return true
end





--- Tries to load LFS through LuaRocks, returns the LFS instance, or nil on error
local function LoadLFS()
	-- Try to load lfs, do not abort if not found ...
	local lfs, err = pcall(
		function()
			return require("lfs")
		end
	)

	-- ... rather, print a nice message with instructions:
	if not(lfs) then
		print([[
	Cannot load LuaFileSystem
	Install it through luarocks by executing the following command:
		luarocks install luafilesystem (Windows)
		sudo luarocks install luafilesystem (*nix)

	If you don't have luarocks installed, you need to install them using your OS's package manager, usually:
		sudo apt-get install luarocks (Ubuntu / Debian)
	On windows, a binary distribution can be downloaded from the LuaRocks homepage, http://luarocks.org/en/Download
	]])
		
		print("Original error text: ", err)
		return nil
	end

	-- We now know that LFS is present, get it normally:
	return require("lfs")
end





local Arg1 = arg[1]
if ((Arg1 ~= nil) and (Arg1 ~= "")) then
	-- Called with a plugin folder name, export only that one
	local isSuccess, msg = ProcessPluginFolder(Arg1)
	if not(isSuccess) then
		print(msg or "<unknown error>")
	end
else
	-- Called without any arguments, process all subfolders:
	local lfs = LoadLFS()
	if (lfs == nil) then
		-- LFS not loaded, error has already been printed, just bail out
		return
	end
	print("Processing plugin subfolders:")
	for fnam in lfs.dir(".") do
		if ((fnam ~= ".") and (fnam ~= "..")) then
			local Attributes = lfs.attributes(fnam)
			if (Attributes ~= nil) then
				if (Attributes.mode == "directory") then
					print(fnam)
					local isSuccess, msg = ProcessPluginFolder(fnam)
					if not(isSuccess) then
						print("  " .. (msg or "<unknown error>"))
					end
				end
			end
		end
	end
end
print("Done.")


