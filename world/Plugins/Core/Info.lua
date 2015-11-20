
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Core",
	Version = "14",
	Date = "2014-06-11",
	SourceLocation = "https://github.com/mc-server/Core",
	Description = [[Implements some of the basic commands needed to run a simple server.]],
	
	Commands =
	{
		["/ban"] = 
		{
			Permission = "core.ban",
			Handler = HandleBanCommand,
			HelpString = "Bans a player.",
		},

		["/clear"] = 
		{
			Permission = "core.clear",
			Handler = HandleClearCommand,
			HelpString = "Clears the inventory of a player.",
		},

		["/do"] = 
		{
			Permission = "core.do",
			Handler = HandleDoCommand,
			HelpString = "Runs a command as a player.",
		},

		["/difficulty"] = 
		{
			Permission = "core.difficulty",
			Handler = HandleDifficultyCommand,
			HelpString = "Changes the difficulty level of the world you're located in.",
		},

		["/enchant"] = 
		{
			Permission = "core.enchant",
			Handler = HandleEnchantCommand,
			HelpString = "Adds an enchantment to a specified player's held item.",
			ParameterCombinations =
			{
				{
					Params = "player enchantmentID",
					Help = "Adds the specified enchantment to the specified player's currently held item.",
				},
				{
					Params = "player enchantmentID level",
					Help = "Adds the specified enchantment of the given level to the specified player's currently held item.",
				},
			},
		},

		["/give"] = 
		{
			Permission = "core.give",
			Handler = HandleGiveCommand,
			HelpString = "Gives an item to a player.",
			ParameterCombinations = 
			{
				{
					Params = "player item",
					Help = "Gives the player one of the specified item.",
				},
				{
					Params = "player item amount",
					Help = "Gives the player the given amount of the specified item.",
				},
				{
					Params = "player item amount data",
					Help = "Gives the player the given amount of the specified item with the given data value.",
				},
				{
					Params = "player item amount data dataTag",
					Help = "Gives the player the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},

		["/gamemode"] = 
		{
			Alias = "/gm",
			Permission = "core.changegm",
			Handler = HandleChangeGMCommand,
			HelpString = "Changes a player's gamemode.",
			ParameterCombinations = 
			{
				{
					Params = "gamemode",
					Help = "Changes your own gamemode.",
				},
				{
					Params = "gamemode player",
					Help = "Changes the gamemode of the specified player, rather then your own.",
				},
			},
		},

		["/help"] = 
		{
			Permission = "core.help",
			Handler = HandleHelpCommand,
			HelpString = "Shows available commands.",
		},

		["/ienchant"] = 
		{
			Permission = "core.enchant.self",
			Handler = HandleIEnchantCommand,
			HelpString = "Adds an enchantment to an item.",
			ParameterCombinations =
			{
				{
					Params = "enchantmentID",
					Help = "Adds the specified enchantment to the currently held item.",
				},
				{
					Params = "enchantmentID level",
					Help = "Adds the specified enchantment of the given level to the currently held item.",
				},
			},
		},

		["/item"] = 
		{
			Alias = "/i",
			Permission = "core.item",
			Handler = HandleItemCommand,
			HelpString = "Gives your player an item.",
			ParameterCombinations = 
			{
				{
					Params = "item",
					Help = "Gives the caller one of the specified item.",
				},
				{
					Params = "item amount",
					Help = "Gives the caller the given amount of the specified item.",
				},
				{
					Params = "item amount data",
					Help = "Gives the caller the given amount of the specified item with the given data value.",
				},
				{
					Params = "item amount data dataTag",
					Help = "Gives the caller the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},

		["/kick"] = 
		{
			Permission = "core.kick",
			Handler = HandleKickCommand,
			HelpString = "Kicks a player.",
		},

		["/kill"] = 
		{
			Permission = "core.kill",
			Handler = HandleKillCommand,
			HelpString = "Kills a player.",
		},

		["/list"] = 
		{
			Permission = "core.list",
			Handler = HandleListCommand,
			HelpString = "Shows a list of connected players.",
		},

		["/listranks"] =
		{
			Permission = "core.listranks",
			Handler = HandleListRanksCommand,
			HelpString = "Shows a list of the available ranks.",
			Alias = "/ranks",
		},

		["/me"] = 
		{
			Permission = "core.me",
			Handler = HandleMeCommand,
			HelpString = "Broadcasts what you are doing.",
		},

		["/motd"] = 
		{
			Permission = "core.motd",
			Handler = HandleMOTDCommand,
			HelpString = "Shows the message of the day.",
		},

		["/plugins"] = 
		{
			Permission = "core.plugins",
			Handler = HandlePluginsCommand,
			HelpString = "Shows a list of the plugins.",
			ParameterCombinations =
			{
				{
					Params = "[<status>] [<status>] ...",
					Help = "Filters the plugin list to show only the plugins with the specified status (default: loaded).",
				},
			},
		},

		["/portal"] =
		{
			Permission = "core.portal",
			Handler = HandlePortalCommand,
			HelpString = "Moves your player to a different world.",
		},
		
        ["/r"] =
        {
            Permission =  "core.tell",
            HelpString =  "Replies to the latest private message you recieved.",
            Handler =  HandleRCommand,
        },
        
		["/rank"] =
		{
			Permission = "core.rank",
			Handler = HandleRankCommand,
			HelpString = "Shows or sets a player's rank.",
		},

		["/regen"] =
		{
			Permission = "core.regen",
			Handler = HandleRegenCommand,
			HelpString = "Regenerates a chunk.",
		},

		["/reload"] = 
		{
			Permission = "core.reload",
			Handler = HandleReloadCommand,
			HelpString = "Reloads all plugins.",
		},

		["/save-all"] = 
		{
			Permission = "core.save-all",
			Handler = HandleSaveAllCommand,
			HelpString = "Saves all worlds.",
		},

		["/setspawn"] = 
		{
			Permission = "core.setspawn",
			Handler = HandleSetSpawnCommand,
			HelpString = "Changes the world's spawn point.",
		},

		["/spawn"] = 
		{
			Permission = "core.spawn",
			Handler = HandleSpawnCommand,
			HelpString = "Returns a player to the spawn point.",
		},

		["/stop"] = 
		{
			Permission = "core.stop",
			Handler = HandleStopCommand,
			HelpString = "Stops the server.",
		},

		["/sudo"] = 
		{
			Permission = "core.sudo",
			Handler = HandleSudoCommand,
			HelpString = "Runs a command as a player, ignoring permissions.",
		},

		["/tell"] = 
		{
			Permission = "core.tell",
			Alias = "/msg",
			Handler = HandleTellCommand,
			HelpString = "Sends a private message to a player.",
		},

		["/time"] = 
		{
			HelpString = "Sets or displays the time.",
			Subcommands = 
			{
				day = 
				{
					HelpString = "Sets the time to day.",
					Permission = "core.time.set",
					Handler = HandleSpecialTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "world",
							Help = "Sets the time in the specified world, rather than the current world.",
						},
					},
				},
				night = 
				{
					HelpString = "Sets the time to night.",
					Permission = "core.time.set",
					Handler = HandleSpecialTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "world",
							Help = "Sets the time in the specified world, rather than the current world.",
						},
					},
				},
				set = 
				{
					HelpString = "Sets the time to a given value.",
					Permission = "core.time.set",
					Handler = HandleSetTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "value",
							Help = "Sets the time to the given value.",
						},
						{
							Params = "day",
							Help = "Sets the time to day.",
						},
						{
							Params = "night",
							Help = "Sets the time to night.",
						},
						{
							Params = "value world",
							Help = "Sets the time to the given value in the specified world, rather than the current world.",
						},
						{
							Params = "day world",
							Help = "Sets the time to day in the specified world, rather than the current world.",
						},
						{
							Params = "night world",
							Help = "Sets the time to night in the specified world, rather than the current world.",
						},
					},
				},
				add = 
				{
					HelpString = "Adds a given value to the current time.",
					Permission = "core.time.set",
					Handler = HandleAddTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "value",
							Help = "Adds the value given to the current time.",
						},
						{
							Params = "value world",
							Help = "Adds the value to the time in the given world, rather than the current world.",
						},
					},
				},
				query = 
				{
					Subcommands = 
					{
						daytime = 
						{
							HelpString = "Displays the current time.",
							Permission = "core.time.query.daytime",
							Handler = HandleQueryDaytimeCommand,
							ParameterCombinations = 
							{
								{
									Params = "world",
									Help = "Displays the time in the specified world, rather than the current world.",
								},
							},
						},
						gametime =
						{
							HelpString = "Displays the amount of time elapsed since start.",
							Permission = "core.time.query.gametime",
							Handler = HandleQueryGametimeCommand,
							ParameterCombinations = 
							{
								{
									Params = "world",
									Help = "Displays the time in the specified world, rather than the current world",
								},
							},
						},
					},
				},
			},
		},

		["/toggledownfall"] = 
		{
			Permission = "core.toggledownfall",
			Handler = HandleDownfallCommand,
			HelpString = "Toggles the weather between clear skies and rain.",
			ParameterCombinations =
			{
				{
					Params = "world",
					Help = "Toggles the weather in the specified world, rather than the current world.",
				},
			},
		},

		["/tp"] = 
		{
			Permission = "core.teleport",
			Handler = HandleTPCommand,
			HelpString = "Teleports your player to another player.",
		},

		["/unban"] = 
		{
			Permission = "core.unban",
			Handler = HandleUnbanCommand,
			HelpString = "Unbans a player.",
		},

		["/unsafegive"] = 
		{
			Permission = "core.give.unsafe",
			Handler = HandleUnsafeGiveCommand,
			HelpString = "Gives an item to a player, even if the item is blacklisted.",
			ParameterCombinations = 
			{
				{
					Params = "player item",
					Help = "Gives the player one of the specified item.",
				},
				{
					Params = "player item amount",
					Help = "Gives the player the given amount of the specified item.",
				},
				{
					Params = "player item amount data",
					Help = "Gives the player the given amount of the specified item with the given data value.",
				},
				{
					Params = "player item amount data dataTag",
					Help = "Gives the player the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},

		["/unsafeitem"] = 
		{
			Permission = "core.item.unsafe",
			Handler = HandleUnsafeItemCommand,
			HelpString = "Gives your player an item, even if the item is blacklisted.",
			ParameterCombinations = 
			{
				{
					Params = "item",
					Help = "Gives the caller one of the specified item.",
				},
				{
					Params = "item amount",
					Help = "Gives the caller the given amount of the specified item.",
				},
				{
					Params = "item amount data",
					Help = "Gives the caller the given amount of the specified item with the given data value.",
				},
				{
					Params = "item amount data dataTag",
					Help = "Gives the caller the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},
		
		["/viewdistance"] = 
		{
			Permission = "core.viewdistance",
			Handler = HandleViewDistanceCommand,
			HelpString = "Changes your view distance.",
		},

		["/weather"] = 
		{
			Permission = "core.weather",
			Handler = HandleWeatherCommand,
			HelpString = "Changes the world's weather.",
			ParameterCombinations =
			{
				{
					Params = "weather",
					Help = "Set the weather to to the given condition, can be: clear, rain, or thunder.",
				},
				{
					Params = "weather DurationInSeconds",
					Help = "Set the weather to the given condition, for the specified duration.",
				},
				{
					Params = "weather world",
					Help = "Set the weather to the given condition in the given world, rather than the default world.",
				},
				{
					Params = "weather DurationInSeconds world",
					Help = "Set the weather to the given condition, have it last for the specified duration, in the given world.",
				},
			},
		},

		["/whitelist"] =
		{
			HelpString= "Manages the whitelist.",
			Subcommands =
			{
				add =
				{
					HelpString = "Adds a player to the whitelist.",
					Permission = "core.whitelist",
					Handler = HandleWhitelistAddCommand,
					ParameterCombinations =
					{
						{
							Params = "player",
							Help = "Adds the specified player to the whitelist.",
						},
					},
				},
				list =
				{
					HelpString = "Shows a list of all players on the whitelist.",
					Permission = "core.whitelist",
					Handler = HandleWhitelistListCommand,
				},
				off =
				{
					HelpString = "Turns whitelist processing off.",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOffCommand,
				},
				on =
				{
					HelpString= "Turns whitelist processing on.",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOnCommand,
				},
				remove =
				{
					HelpString = "Removes a player from the whitelist.",
					Permission = "core.whitelist",
					Handler = HandleWhitelistRemoveCommand,
					ParameterCombinations =
					{
						{
							Params = "player",
							Help = "Removes the specified player from the whitelist.",
						},
					},
				},
			},  -- Subcommands
		},  -- /whitelist

		["/worlds"] = 
		{
			Permission = "core.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Shows a list of all the worlds.",
		},
	},  -- Commands


	
	ConsoleCommands =
	{
		["ban"] =
		{
			Handler =  HandleConsoleBan,
			HelpString = "Bans a player by name.",
		},

		["banip"] =
		{
			Handler =  HandleConsoleBanIP,
			HelpString = "Bans a player by IP.",
			Alias = "ipban",
		},

		["banlist"] =
		{
			Handler = HandleConsoleBanList,
			HelpString = "Shows a list of all players banned by name.",
		},

		["banlist ips"] =
		{
			-- This is a dummy entry only to generate the documentation
			-- the real processing is done by the "banlist" command
			Handler =  HandleConsoleBanList,
			HelpString = "Shows a list of all players banned by IP.",
		},

		["clear"] =
		{
			Handler =  HandleConsoleClear ,
			HelpString = "Clears the inventory of a player.",
		},

		["enchant"] = 
		{
			Handler = HandleConsoleEnchant,
			HelpString = "Adds an enchantment to a specified player's held item.",
			ParameterCombinations =
			{
				{
					Params = "player enchantmentID",
					Help = "Adds the specified enchantment to the specified player's currently held item.",
				},
				{
					Params = "player enchantmentID level",
					Help = "Adds the specified enchantment of the given level to the specified player's currently held item.",
				},
			},
		},

		["gamemode"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Changes a player's gamemode.",
			ParameterCombinations = 
			{
				{
					Params = "gamemode player",
					Help = "Changes the gamemode of the given player.",
				},
			},
		},

		["gm"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Changes a player's gamemode.",
			ParameterCombinations = 
			{
				{
					Params = "gamemode player",
					Help = "Changes the gamemode of the given player.",
				},
			},
		},

		["give"] =
		{
			Handler =  HandleConsoleGive,
			HelpString = "Gives an item to a player.",
			ParameterCombinations = 
			{
				{
					Params = "player item",
					Help = "Gives the player one of the specified item.",
				},
				{
					Params = "player item amount",
					Help = "Gives the player the given amount of the specified item.",
				},
				{
					Params = "player item amount data",
					Help = "Gives the player the given amount of the specified item with the given data value.",
				},
				{
					Params = "player item amount data dataTag",
					Help = "Gives the player the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},

		["kick"] =
		{
			Handler =  HandleConsoleKick,
			HelpString = "Kicks a player by name.",
		},

		["kill"] =
		{
			Handler =  HandleConsoleKill,
			HelpString = "Kills a player.",
		},

		["list"] =
		{
			Handler =  HandleConsoleList,
			HelpString = "Shows a list of all connected players in a machine-readable format.",
		},

		["listgroups"] =
		{
			Handler =  HandleConsoleListGroups,
			HelpString = "Shows a list of all the available groups.",
		},

		["listranks"] =
		{
			Handler =  HandleConsoleListRanks,
			HelpString = "Shows a list of all the available ranks.",
		},

		["numchunks"] =
		{
			Handler =  HandleConsoleNumChunks,
			HelpString = "Shows number of chunks currently loaded.",
		},

		["players"] =
		{
			Handler =  HandleConsolePlayers,
			HelpString = "Shows a list of all connected players.",
		},

		["plugins"] =
		{
			Handler = HandleConsolePlugins,
			HelpString = "Shows a list of the plugins.",
		},

		["rank"] =
		{
			Handler =  HandleConsoleRank,
			HelpString = "Shows or sets a player's rank.",
		},
		
		["regen"] =
		{
			Handler = HandleConsoleRegen,
			Alias = "regeneratechunk",
			HelpString = "Regenerates a chunk.",
			ParameterCombinations =
			{
				{
					Params = "chunkX chunkZ",
					Help = "Regenerates the specified chunk in the default world.",
				},
				{
					Params = "chunkX chunkZ world",
					Help = "Regenerates the specified chunk in the specified world.",
				}
			},
		},  -- regen

		["save-all"] =
		{
			Handler =  HandleConsoleSaveAll,
			HelpString = "Saves all worlds.",
		},

		["say"] =
		{
			Handler =  HandleConsoleSay,
			HelpString = "Sends a chat message to all players.",
		},

		["time"] = 
		{
			HelpString = "Sets or displays the time.",
			Subcommands = 
			{
				day =
				{
					Handler = HandleConsoleSpecialTime,
					HelpString = "Sets the time to day.",
					ParameterCombinations =
					{
						{
							Params = "WorldName",
							Help = "Set the time in the specified world, rather than the default world.",
						},
					},
				},
				night =
				{
					Handler = HandleConsoleSpecialTime,
					HelpString = "Sets the time to night.",
					ParameterCombinations =
					{
						{
							Params = "WorldName",
							Help = "Set the time in the specified world, rather than the default world.",
						},
					},
				},
				set =
				{
					Handler = HandleConsoleSetTime,
					HelpString = "Sets the time to a given value.",
					ParameterCombinations =
					{
						{
							Params = "time",
							Help = "Sets the time to the given value."
						},
						{
							Params = "day",
							Help = "Sets the time to day.",
						},
						{
							Params = "night",
							Help = "Sets the time to night.",
						},
						{
							Params = "time WorldName",
							Help = "Sets the time to the given value in the specified world, rather than the default world.",
						},
						{
							Params = "day WorldName",
							Help = "Sets the time to day in the specified world, rather than the default world.",
						},
						{
							Params = "night WorldName",
							Help = "Sets the time to night in the specified world, rather than the default world.",
						},
					},
				},
				add =
				{
					Handler = HandleConsoleAddTime,
					HelpString = "Adds a given value to the current time.",
					ParameterCombinations =
					{
						{
							Params = "amount",
							Help = "Adds the given value to the current time."
						},
						{
							Params = "add WorldName",
							Help = "Adds the value to the time in the specified world, rather than the default world.",
						},
					},
				},
				query =
				{
					Subcommands =
					{
						daytime =
						{
							Handler = HandleConsoleQueryDaytime,
							HelpString = "Displays the current time.",
							ParameterCombinations =
							{
								{
									Params = "WorldName",
									Help = "Displays the time in the specified world, rather than the default world.",
								},
							},
						},
						gametime =
						{
							Handler = HandleConsoleQueryGametime,
							HelpString = "Displays the amount of time elapsed since start.",
							ParameterCombinations =
							{
								{
									Params = "WorldName",
									Help = "Display the time in the given world, rather than the default world",
								},
							},
						},
					},
				},
			},
		},

		["toggledownfall"] =
		{
			Handler = HandleConsoleDownfall,
			HelpString = "Toggles the weather between clear skies and rain.",
			ParameterCombinations =
			{
				{
					Params = "WorldName",
					Help = "Changes the weather in the specified world, rather than the default world.",
				},
			},
		},

		["tp"] =
		{
			Handler =  HandleConsoleTeleport,
			HelpString = "Teleports a player.",
		},

		["unban"] =
		{
			Handler =  HandleConsoleUnban,
			HelpString = "Unbans a player by name.",
		},

		["unbanip"] =
		{
			Handler =  HandleConsoleUnbanIP,
			HelpString = "Unbans a player by IP.",
		},

		["unloadchunks"] =
		{
			Handler = HandleConsoleUnload,
			HelpString = "Unloads all unused chunks.",
		},
		
		["unrank"] =
		{
			Handler = HandleConsoleUnrank,
			HelpString = "Resets a player's rank to default.",
		},
		
		["unsafegive"] =
		{
			Handler =  HandleConsoleUnsafeGive,
			HelpString = "Gives an item to a player, even if the item is blacklisted.",
			ParameterCombinations = 
			{
				{
					Params = "player item",
					Help = "Gives the player one of the specified item.",
				},
				{
					Params = "player item amount",
					Help = "Gives the player the given amount of the specified item.",
				},
				{
					Params = "player item amount data",
					Help = "Gives the player the given amount of the specified item with the given data value.",
				},
				{
					Params = "player item amount data dataTag",
					Help = "Gives the player the given amount of the specified item with the given data value and DataTag.",
				},
			},
		},
		
		["weather"] =
		{
			Handler =  HandleConsoleWeather,
			HelpString = "Changes the world's weather.",
			ParameterCombinations =
			{
				{
					Params = "weather",
					Help = "Sets the weather to to the given condition, can be: clear, rain, or thunder.",
				},
				{
					Params = "weather DurationInSeconds",
					Help = "Sets the weather to the given condition, for the specified duration.",
				},
				{
					Params = "weather world",
					Help = "Sets the weather to the given condition in the given world, rather than the default world.",
				},
				{
					Params = "weather DurationInSeconds world",
					Help = "Sets the weather to the given condition, have it last for the specified duration, in the given world.",
				},
			},
		},

		["whitelist"] =
		{
			HelpString= "Manages the whitelist.",
			Subcommands =
			{
				add =
				{
					HelpString = "Adds a player to the whitelist.",
					Handler = HandleConsoleWhitelistAdd,
					ParameterCombinations =
					{
						{
							Params = "player",
							Help = "Adds the specified player to the whitelist.",
						},
					},
				},
				list =
				{
					HelpString = "Shows a list of all players on the whitelist.",
					Handler = HandleConsoleWhitelistList,
				},
				off =
				{
					HelpString = "Turns off whitelist processing.",
					Handler = HandleConsoleWhitelistOff,
				},
				on =
				{
					HelpString = "Turns on whitelist processing.",
					Handler = HandleConsoleWhitelistOn,
				},
				remove =
				{
					HelpString = "Removes a player from the whitelist.",
					Handler = HandleConsoleWhitelistRemove,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Removes the specified player from the whitelist.",
						},
					},
				},
			},  -- Subcommands
		},  -- whitelist
	},  -- ConsoleCommands
	Permissions = 
	{
		["core.changegm"] =
		{
			Description = "Allows players to change gamemodes.",
			RecommendedGroups = "admins",
		},

		["core.enchant"] =
		{
			Description = "Allows players to add an enchantment to a player's held item.",
			RecommendedGroups = "admins",
		},

		["core.enchant.self"] =
		{
			Description = "Allows players to add an enchantment to their own held item.",
			RecommendedGroups = "admins",
		},

		["core.give"] =
		{
			Description = "Allows players to give items to other players.",
			RecommendedGroups = "admins",
		},

		["core.give.unsafe"] =
		{
			Description = "Allows players to give items to other players, even if the item is blacklisted.",
			RecommendedGroups = "none",
		},

		["core.item"] =
		{
			Description = "Allows players to give items to themselves.",
			RecommendedGroups = "admins",
		},

		["core.item.unsafe"] =
		{
			Description = "Allows players to give items to themselves, even if the item is blacklisted.",
			RecommendedGroups = "none",
		},

		["core.time.set"] = 
		{
			Description = "Allows players to set the time of day.",
			RecommendedGroups = "admins",
		},

		["core.time.query.daytime"] =
		{
			Description = "Allows players to display the time of day.",
			RecommendedGroups = "everyone",
		},

		["core.time.query.gametime"] =
		{
			Description = "Allows players to display how long the world has existed.",
		},
		
		["core.toggledownfall"] =
		{
			Description = "Allows players to toggle the weather between clear skies and rain.",
			RecommendedGroups = "admins",
		},
		
		["core.weather"] =
		{
			Description = "Allows players to change the weather.",
			RecommendedGroups = "admins",
		},
		

		["core.whitelist"] =
		{
			Description = "Allows players to manage the whitelist.",
			RecommendedGroups = "admins",
		},
	},  -- Permissions
}  -- g_PluginInfo


