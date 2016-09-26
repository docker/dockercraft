
-- Info.lua

-- Implements the g_PluginInfo standard plugin description





g_PluginInfo = 
{
	Name = "ProtectionAreas",
	Date = "2013-12-29",
	Description =
	[[
		This plugin lets VIP users define areas of the world where only specified users are allowed to build and
		dig.

		An area is defined by the VIP by using a Wand item (by default, a stick with a meta 1) by left-clicking
		and right-clicking in two opposite corners of the area, then issuing a /protection add command. Multiple
		users can be allowed in a single area. There is no hardcoded limit on the number of areas or the number
		of players allowed in a single area. Areas can overlap; in such a case, if a user is allowed in any one
		of the overlapping areas, they are allowed to build / dig.

		The protected areas are stored in an SQLite database in a file "ProtectionAreas.sqlite" that is created
		next to the Cuberite executable. The plugin has its configuration options stored in a
		"ProtectionAreas.ini" file.
	]],
	
	AdditionalInfo =
	{
		{
			Title = "Configuration",
			Contents =
			[[
				The configuration is stored in the ProtectionAreas.ini file next to the Cuberite executable in a
				regular manner.

				The wand item can be specified in the configuration. By default, a stick with meta 1 is used, but
				any valid item can be used. Stored in the [ProtectionAreas].WandItem value.

				If there is no area, players can be either allowed to interact freely or not at all, based on the
				setting in the [ProtectionAreas].AllowInteractNoArea value. Accepted values are 0 and 1.
			]],
		},
	},  -- AdditionalInfo
	
	Commands =
	{
		["/protection"] =
		{
			-- Due to having subcommands, this command does not use either Permission nor HelpString
			Permission = "",
			HelpString = "",
			Handler = nil,
			Subcommands =
			{
				add =
				{
					HelpString = "adds a new protected area using wand",
					Permission = "protection.add",
					Handler = HandleAddArea,
					ParameterCombinations =
					{
						{
							Params = "UserName1 [UserName2 ...]",
						},
					},
				},
				
				addc =
				{
					HelpString = "adds a new protected area with explicitly specified coordinates",
					Permission = "protection.add",
					Handler = HandleAddAreaCoords,
					ParameterCombinations =
					{
						{
							Params = "x1 z1 x2 z2 UserName1 [UserName2 ...]",
						},
					},
				},
				
				del =
				{
					Permission = "protection.del",
					HelpString = "deletes the specified area.",
					Handler = HandleDelArea,
					ParameterCombinations =
					{
						{
							Params = "AreaID",
						},
					},
				},
				
				list =
				{
					Permission = "protection.list",
					HelpString = "lists all areas in the specified place",
					Handler = HandleListAreas,
					ParameterCombinations =
					{
						{
							Params = "",
							Help = "lists all areas that contain the block last clicked with a Wand",
						},
						{
							Params = "x z",
							Help = "lists all areas that contain the specified block coords",
						},
					},  -- ParameterCombinations
				},  -- list
				
				user =
				{
					-- Common prefix for manipulationg users; has subcommands, so no Permissions, HelpString nor Handler
					Permission = "",
					HelpString = "",
					Handler = nil,
					Subcommands =
					{
						add =
						{
							HelpString = "adds the specified users to the allowed users in the specified area",
							Permission = "protection.user.add",
							Handler = HandleAddAreaUser,
							ParameterCombinations =
							{
								{
									Params = "AreaID UserName1 [UserName2 ...]",
								},
							},
						},
						
						list =
						{
							HelpString = "lists all the allowed users for the specified area",
							Permission = "protection.user.list",
							Handler = HandleListUsers,
							ParameterCombinations =
							{
								{
									Params = "AreaID",
								},
							},
						},
						
						remove =
						{
							HelpString = "removes the specified users from the allowed users in the specified area",
							Permission = "protection.user.remove",
							Handler = HandleRemoveUser,
							ParameterCombinations =
							{
								{
									Params = "AreaID UserName1 [UserName2 ...]",
								},
							}
						},
						
						strip =
						{
							HelpString = "removes the user from all areas in this world",
							Permission = "protection.user.strip",
							Handler = HandleRemoveUserAll,
							ParameterCombinations =
							{
								{
									Params = "UserName",
								},
							},
						},  -- strip
					},  -- Subcommands
				},  -- user
				
				wand =
				{
					Permission = "protection.wand",
					HelpString = "gives the Wand item",
					Handler = HandleGiveWand,
				},  -- wand
			},  -- Subcommands
		},  -- /protection
	},  -- Commands
};  -- g_PluginInfo




