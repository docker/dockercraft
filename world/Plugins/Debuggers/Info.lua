
-- Info.lua

-- Implements the g_PluginInfo standard plugin description





g_PluginInfo =
{
	Name = "Debuggers",
	Version = "14",
	Date = "2014-12-11",
	Description = [[Contains code for testing and debugging the server. Should not be enabled on a production server!]],
	
	Commands =
	{
		["/arr"] =
		{
			Permission = "debuggers",
			Handler = HandleArrowCmd,
			HelpString = "Creates an arrow going away from the player"
		},
		["/compo"] =
		{
			Permission = "debuggers",
			Handler = HandleCompo,
			HelpString = "Tests the cCompositeChat bindings"
		},
		["/cstay"] =
		{
			Permission = "debuggers",
			Handler = HandleChunkStay,
			HelpString = "Tests the ChunkStay Lua integration for the specified chunk coords"
		},
		["/dash"] =
		{
			Permission = "debuggers",
			Handler = HandleDashCmd,
			HelpString = "Switches between fast and normal sprinting speed"
		},
		["/ench"] =
		{
			Permission = "debuggers",
			Handler = HandleEnchCmd,
			HelpString = "Provides an instant dummy enchantment window"
		},
		["/fast"] =
		{
			Permission = "debuggers",
			Handler = HandleFastCmd,
			HelpString = "Switches between fast and normal movement speed"
		},
		["/fb"] =
		{
			Permission = "debuggers",
			Handler = HandleFireballCmd,
			HelpString = "Creates a ghast fireball as if shot by the player"
		},
		["/ff"] =
		{
			Permission = "debuggers",
			Handler = HandleFurnaceFuel,
			HelpString = "Shows how long the currently held item would burn in a furnace"
		},
		["/fill"] =
		{
			Permission = "debuggers",
			Handler = HandleFill,
			HelpString = "Fills all block entities in current chunk with junk"
		},
		["/fl"] =
		{
			Permission = "debuggers",
			Handler = HandleFoodLevelCmd,
			HelpString = "Sets the food level to the given value"
		},
		["/fr"] =
		{
			Permission = "debuggers",
			Handler = HandleFurnaceRecipe,
			HelpString = "Shows the furnace recipe for the currently held item"
		},
		["/fs"] =
		{
			Permission = "debuggers",
			Handler = HandleFoodStatsCmd,
			HelpString = "Turns regular foodstats message on or off"
		},
		["/gc"] =
		{
			Permission = "debuggers",
			Handler = HandleGCCmd,
			HelpString = "Activates the Lua garbage collector"
		},
		["/hunger"] =
		{
			Permission = "debuggers",
			Handler = HandleHungerCmd,
			HelpString = "Lists the current hunger-related variables"
		},
		["/ke"] =
		{
			Permission = "debuggers",
			Handler = HandleKillEntitiesCmd,
			HelpString = "Kills all the loaded entities"
		},
		["/le"] =
		{
			Permission = "debuggers",
			Handler = HandleListEntitiesCmd,
			HelpString = "Shows a list of all the loaded entities"
		},
		["/nick"] =
		{
			Permission = "debuggers",
			Handler = HandleNickCmd,
			HelpString = "Gives you a custom name",
		},
		["/pickups"] =
		{
			Permission = "debuggers",
			Handler = HandlePickups,
			HelpString = "Spawns random pickups around you"
		},
		["/plugmsg"] =
		{
			Permission = "debuggers",
			Handler = HandlePlugMsg,
			HelpString = "Sends a test plugin message to the client",
		},
		["/poison"] =
		{
			Permission = "debuggers",
			Handler = HandlePoisonCmd,
			HelpString = "Sets food-poisoning for 15 seconds"
		},
		["/poof"] =
		{
			Permission = "debuggers",
			Handler = HandlePoof,
			HelpString = "Nudges pickups close to you away from you"
		},
		["/rmitem"] =
		{
			Permission = "debuggers",
			Handler = HandleRMItem,
			HelpString = "Remove the specified item from the inventory."
		},
		["/sb"] =
		{
			Permission = "debuggers",
			Handler = HandleSetBiome,
			HelpString = "Sets the biome around you to the specified one"
		},
		["/sched"] =
		{
			Permission = "debuggers",
			Handler = HandleSched,
			HelpString = "Schedules a simple countdown using cWorld:ScheduleTask()"
		},
		["/spidey"] =
		{
			Permission = "debuggers",
			Handler = HandleSpideyCmd,
			HelpString = "Shoots a line of web blocks until it hits non-air"
		},
		["/starve"] =
		{
			Permission = "debuggers",
			Handler = HandleStarveCmd,
			HelpString = "Sets the food level to zero"
		},
		["/testwnd"] =
		{
			Permission = "debuggers",
			Handler = HandleTestWndCmd,
			HelpString = "Opens up a window using plugin API"
		},
		["/wesel"] =
		{
			Permission = "debuggers",
			Handler = HandleWESel,
			HelpString = "Expands the current WE selection by 1 block in X/Z"
		},
		["/wool"] =
		{
			Permission = "debuggers",
			Handler = HandleWoolCmd,
			HelpString = "Sets all your armor to blue wool"
		},
		["/xpa"] =
		{
			Permission = "debuggers",
			Handler = HandleAddExperience,
			HelpString = "Adds 200 experience to the player"
		},
		["/xpr"] =
		{
			Permission = "debuggers",
			Handler = HandleRemoveXp,
			HelpString = "Remove all xp"
		},
	},  -- Commands
	
	ConsoleCommands =
	{
		["bbox"] =
		{
			Handler = HandleConsoleBBox,
			HelpString = "Performs cBoundingBox API tests",
		},
		
		["hash"] =
		{
			Handler = HandleConsoleHash,
			HelpString = "Tests the crypto hashing functions",
		},
		
		["inh"] =
		{
			Handler = HandleConsoleInh,
			HelpString = "Tests the bindings of the cEntity inheritance",
		},
		
		["loadchunk"] =
		{
			Handler = HandleConsoleLoadChunk,
			HelpString = "Loads the specified chunk into memory",
		},
		
		["preparechunk"] =
		{
			Handler = HandleConsolePrepareChunk,
			HelpString = "Prepares the specified chunk completely (load / gen / light)",
		},
		
		["sched"] =
		{
			Handler = HandleConsoleSchedule,
			HelpString = "Tests the world scheduling",
		},
		
		["testtracer"] =
		{
			Handler = HandleConsoleTestTracer,
			HelpString = "Tests the cLineBlockTracer",
		}
	},  -- ConsoleCommands
}  -- g_PluginInfo




