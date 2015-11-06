
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo =
{
	Name = "NetworkTest",
	Version = "1",
	Date = "2015-01-28",
	Description = [[Implements test code (and examples) for the cNetwork API]],
	
	Commands =
	{
	},
	
	ConsoleCommands =
	{
		net =
		{
			Subcommands =
			{
				client =
				{
					HelpString = "Connects, as a client, to a specified webpage (google.com by default) and downloads its front page using HTTP",
					Handler = HandleConsoleNetClient,
					ParameterCombinations =
					{
						{
							Params = "",
							Help = "Connects, as a client, to google.com and downloads its front page using HTTP",
						},
						{
							Params = "host [port]",
							Help = "Connects, as a client, to the specified host and downloads its front page using HTTP",
						},
					},  -- ParameterCombinations
				},  -- client
				
				close =
				{
					HelpString = "Close a listening socket",
					Handler = HandleConsoleNetClose,
					ParameterCombinations =
					{
						{
							Params = "[Port]",
							Help = "Closes a socket listening on the specified port [1024]",
						},
					},  -- ParameterCombinations
				},  -- close
				
				ips =
				{
					HelpString = "Prints all locally available IP addresses",
					Handler = HandleConsoleNetIps,
				},  -- ips
				
				listen =
				{
					HelpString = "Creates a new listening socket on the specified port with the specified service attached to it",
					Handler = HandleConsoleNetListen,
					ParameterCombinations =
					{
						{
							Params = "[Port] [Service]",
							Help = "Starts listening on the specified port [1024] providing the specified service [echo]",
						},
					},  -- ParameterCombinations
				},  -- listen
				
				lookup =
				{
					HelpString = "Looks up the IP addresses corresponding to the given hostname  (google.com by default)",
					Handler = HandleConsoleNetLookup,
					ParameterCombinations =
					{
						{
							Params = "",
							Help = "Looks up the IP addresses of google.com.",
						},
						{
							Params = "Hostname",
							Help = "Looks up the IP addresses of the specified hostname.",
						},
						{
							Params = "IP",
							Help = "Looks up the canonical name of the specified IP.",
						},
					},
				},  -- lookup
				
				sclient =
				{
					HelpString = "Connects, as an SSL client, to a specified webpage (github.com by default) and downloads its front page using HTTPS",
					Handler = HandleConsoleNetSClient,
					ParameterCombinations =
					{
						{
							Params = "",
							Help = "Connects, as an SSL client, to github.com and downloads its front page using HTTPS",
						},
						{
							Params = "host [port]",
							Help = "Connects, as an SSL client, to the specified host and downloads its front page using HTTPS",
						},
					},  -- ParameterCombinations
				},  -- sclient

				udp =
				{
					Subcommands =
					{
						close =
						{
							Handler = HandleConsoleNetUdpClose,
							ParameterCombinations =
							{
								{
									Params = "[Port]",
									Help = "Closes the UDP endpoint on the specified port [1024].",
								}
							},
						},  -- close
						
						listen =
						{
							Handler = HandleConsoleNetUdpListen,
							ParameterCombinations =
							{
								{
									Params = "[Port]",
									Help = "Listens on the specified UDP port [1024], dumping the incoming datagrams into log",
								},
							},
						},  -- listen
						
						send =
						{
							Handler = HandleConsoleNetUdpSend,
							ParameterCombinations =
							{
								{
									Params = "[Host] [Port] [Message]",
									Help = "Sends the message [\"hello\"] through UDP to the specified host [localhost] and port [1024]",
								},
							},
						}  -- send
					},  -- Subcommands ("net udp")
				},  -- udp
				
				wasc =
				{
					HelpString = "Requests the webadmin homepage using https",
					Handler = HandleConsoleNetWasc,
				},  -- wasc
				
			},  -- Subcommands
		},  -- net
	},
}




