-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Docker",
	Version = 1,
	DisplayVersion = "0.1.0",
	Date = "2016-09-16", -- yyyy-mm-dd
	SourceLocation = "https://github.com/docker/dockercraft",
	Description = [[This plugin, in combination with the Dockercraft proxy, turns minecraft in to a Docker client]],
	Commands =
	{
	
		["/docker"] =
		{
			Permission = "dockercraft.docker",
			Handler = DockerCommand,
			HelpString = "Execute a Docker Command",
			Category = "Scripting",
		},
	}, -- Commands
	ConsoleCommands = {},
	AdditionalInfo = {}
}

