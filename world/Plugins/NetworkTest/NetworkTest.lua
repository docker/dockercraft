
-- NetworkTest.lua

-- Implements a few tests for the cNetwork API





--- Map of all servers currently open
-- g_Servers[PortNum] = cServerHandle
local g_Servers = {}

--- Map of all UDP endpoints currently open
-- g_UDPEndpoints[PortNum] = cUDPEndpoint
local g_UDPEndpoints = {}

--- List of fortune messages for the fortune server
-- A random message is chosen for each incoming connection
-- The contents are loaded from the splashes.txt file on plugin startup
local g_Fortunes =
{
	"Empty splashes.txt",
}

-- HTTPS certificate to be used for the SSL server:
local g_HTTPSCert = [[
-----BEGIN CERTIFICATE-----
MIIDfzCCAmegAwIBAgIJAOBHN+qOWodcMA0GCSqGSIb3DQEBBQUAMFYxCzAJBgNV
BAYTAmN6MQswCQYDVQQIDAJjejEMMAoGA1UEBwwDbG9jMQswCQYDVQQKDAJfWDEL
MAkGA1UECwwCT1UxEjAQBgNVBAMMCWxvY2FsaG9zdDAeFw0xNTAxMjQwODQ2MzFa
Fw0yNTAxMjEwODQ2MzFaMFYxCzAJBgNVBAYTAmN6MQswCQYDVQQIDAJjejEMMAoG
A1UEBwwDbG9jMQswCQYDVQQKDAJfWDELMAkGA1UECwwCT1UxEjAQBgNVBAMMCWxv
Y2FsaG9zdDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJkFYSElu/jw
nxqjimmj246DejKJK8uy/l9QQibb/Z4kO/3s0gVPOYo0mKv32xUFP7wYIE3XWT61
zyfvK+1jpnlQTCtM8T5xw/7CULKgLmuIzlQx5Dhy7d+tW46kOjFKwQajS9YzwqWu
KBOPnFamQWz6vIzuM05+7aIMXbzamInvW/1x3klIrpGQgALwSB1N+oUzTInTBRKK
21pecUE9t3qrU40Cs5bN0fQBnBjLwbgmnTh6LEplfQZHG5wLvj0IeERVU9vH7luM
e9/IxuEZluCiu5ViF3jqLPpjYOrkX7JDSKme64CCmNIf0KkrwtFjF104Qylike60
YD3+kw8Q+DECAwEAAaNQME4wHQYDVR0OBBYEFHHIDTc7mrLDXftjQ5ejU9Udfdyo
MB8GA1UdIwQYMBaAFHHIDTc7mrLDXftjQ5ejU9UdfdyoMAwGA1UdEwQFMAMBAf8w
DQYJKoZIhvcNAQEFBQADggEBAHxCJxZPmH9tvx8GKiDV3rgGY++sMItzrW5Uhf0/
bl3DPbVz51CYF8nXiWvSJJzxhH61hKpZiqvRlpyMuovV415dYQ+Xc2d2IrTX6e+d
Z4Pmwfb4yaX+kYqIygjXMoyNxOJyhTnCbJzycV3v5tvncBWN9Wqez6ZonWDdFdAm
J+Moty+atc4afT02sUg1xz+CDr1uMbt62tHwKYCdxXCwT//bOs6W21+mQJ5bEAyA
YrHQPgX76uo8ed8rPf6y8Qj//lzq/+33EIWqf9pnbklQgIPXJU07h+5L+Y63RF4A
ComLkzas+qnQLcEN28Dg8QElXop6hfiD0xq3K0ac2bDnjoU=
-----END CERTIFICATE-----
]]

local g_HTTPSPrivKey = [[
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZBWEhJbv48J8a
o4ppo9uOg3oyiSvLsv5fUEIm2/2eJDv97NIFTzmKNJir99sVBT+8GCBN11k+tc8n
7yvtY6Z5UEwrTPE+ccP+wlCyoC5riM5UMeQ4cu3frVuOpDoxSsEGo0vWM8KlrigT
j5xWpkFs+ryM7jNOfu2iDF282piJ71v9cd5JSK6RkIAC8EgdTfqFM0yJ0wUSitta
XnFBPbd6q1ONArOWzdH0AZwYy8G4Jp04eixKZX0GRxucC749CHhEVVPbx+5bjHvf
yMbhGZbgoruVYhd46iz6Y2Dq5F+yQ0ipnuuAgpjSH9CpK8LRYxddOEMpYpHutGA9
/pMPEPgxAgMBAAECggEAWxQ4m+I54BJYoSJ2YCqHpGvdb/b1emkvvsumlDqc2mP2
0U0ENOTS+tATj0gXvotBRFOX5r0nAYx1oO9a1hFaJRsGOz+w19ofLqO6JJfzCU6E
gNixXmgJ7fjhZiWZ/XzhJ3JK0VQ9px/h+sKf63NJvfQABmJBZ5dlGe8CXEZARNin
03TnE3RUIEK+jEgwShN2OrGjwK9fjcnXMHwEnKZtCBiYEfD2N+pQmS20gIm13L1t
+ZmObIC24NqllXxl4I821qzBdhmcT7+rGmKR0OT5YKbt6wFA5FPKD9dqlzXzlKck
r2VAh+JlCtFKxcScmWtQOnVDtf5+mcKFbP4ck724AQKBgQDLk+RDhvE5ykin5R+B
dehUQZgHb2pPL7N1DAZShfzwSmyZSOPQDFr7c0CMijn6G0Pw9VX6Vrln0crfTQYz
Hli+zxlmcMAD/WC6VImM1LCUzouNRy37rSCnuPtngZyHdsyzfheGnjORH7HlPjtY
JCTLaekg0ckQvt//HpRV3DCdaQKBgQDAbLmIOTyGfne74HLswWnY/kCOfFt6eO+E
lZ724MWmVPWkxq+9rltC2CDx2i8jjdkm90dsgR5OG2EaLnUWldUpkE0zH0ATrZSV
ezJWD9SsxTm8ksbThD+pJKAVPxDAboejF7kPvpaO2wY+bf0AbO3M24rJ2tccpMv8
AcfXBICDiQKBgQCSxp81/I3hf7HgszaC7ZLDZMOK4M6CJz847aGFUCtsyAwCfGYb
8zyJvK/WZDam14+lpA0IQAzPCJg/ZVZJ9uA/OivzCum2NrHNxfOiQRrLPxuokaBa
q5k2tA02tGE53fJ6mze1DEzbnkFxqeu5gd2xdzvpOLfBxgzT8KU8PlQiuQKBgGn5
NvCj/QZhDhYFVaW4G1ArLmiKamL3yYluUV7LiW7CaYp29gBzzsTwfKxVqhJdo5NH
KinCrmr7vy2JGmj22a+LTkjyU/rCZQsyDxXAoDMKZ3LILwH8WocPqa4pzlL8TGzw
urXGE+rXCwhE0Mp0Mz7YRgZHJKMcy06duG5dh11pAoGBALHbsBIDihgHPyp2eKMP
K1f42MdKrTBiIXV80hv2OnvWVRCYvnhrqpeRMzCR1pmVbh+QhnwIMAdWq9PAVTTn
ypusoEsG8Y5fx8xhgjs0D2yMcrmi0L0kCgHIFNoym+4pI+sv6GgxpemfrmaPNcMx
DXi9JpaquFRJLGJ7jMCDgotL
-----END PRIVATE KEY-----
]]

--- Map of all services that can be run as servers
-- g_Services[ServiceName] = function() -> accept-callbacks
local g_Services =
{
	-- Echo service: each connection echoes back what has been sent to it
	echo = function (a_Port)
		return
		{
			-- A new connection has come, give it new link-callbacks:
			OnIncomingConnection = function (a_RemoteIP, a_RemotePort)
				return
				{
					OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
						LOG("EchoServer(" .. a_Port .. ": Connection to " .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. " failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
					end,
					
					OnReceivedData = function (a_Link, a_Data)
						-- Echo the received data back to the link:
						a_Link:Send(a_Data)
					end,
					
					OnRemoteClosed = function (a_Link)
					end
				}  -- Link callbacks
			end,  -- OnIncomingConnection()
			
			-- Send a welcome message to newly accepted connections:
			OnAccepted = function (a_Link)
				a_Link:Send("Hello, " .. a_Link:GetRemoteIP() .. ", welcome to the echo server @ Cuberite-Lua\r\n")
			end,  -- OnAccepted()
			
			-- There was an error listening on the port:
			OnError = function (a_ErrorCode, a_ErrorMsg)
				LOGINFO("EchoServer(" .. a_Port .. ": Cannot listen: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
			end,  -- OnError()
		}  -- Listen callbacks
	end,  -- echo
	
	-- Fortune service: each incoming connection gets a welcome message plus a random fortune text; all communication is ignored afterwards
	fortune = function (a_Port)
		return
		{
			-- A new connection has come, give it new link-callbacks:
			OnIncomingConnection = function (a_RemoteIP, a_RemotePort)
				return
				{
					OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
						LOG("FortuneServer(" .. a_Port .. "): Connection to " .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. " failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
					end,
					
					OnReceivedData = function (a_Link, a_Data)
						-- Ignore any received data
					end,
					
					OnRemoteClosed = function (a_Link)
					end
				}  -- Link callbacks
			end,  -- OnIncomingConnection()
			
			-- Send a welcome message and the fortune to newly accepted connections:
			OnAccepted = function (a_Link)
				a_Link:Send("Hello, " .. a_Link:GetRemoteIP() .. ", welcome to the fortune server @ Cuberite-Lua\r\n\r\nYour fortune:\r\n")
				a_Link:Send(g_Fortunes[math.random(#g_Fortunes)] .. "\r\n")
			end,  -- OnAccepted()
			
			-- There was an error listening on the port:
			OnError = function (a_ErrorCode, a_ErrorMsg)
				LOGINFO("FortuneServer(" .. a_Port .. "): Cannot listen: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
			end,  -- OnError()
		}  -- Listen callbacks
	end,  -- fortune
	
	-- HTTPS time - serves current time for each https request received
	httpstime = function (a_Port)
		return
		{
			-- A new connection has come, give it new link-callbacks:
			OnIncomingConnection = function (a_RemoteIP, a_RemotePort)
				local IncomingData = ""  -- accumulator for the incoming data, until processed by the http
				return
				{
					OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
						LOG("https-time server(" .. a_Port .. "): Connection to " .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. " failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
					end,
					
					OnReceivedData = function (a_Link, a_Data)
						IncomingData = IncomingData .. a_Data
						if (IncomingData:find("\r\n\r\n")) then
							-- We have received the entire request headers, just send the response and shutdown the link:
							local Content = os.date()
							a_Link:Send("HTTP/1.0 200 OK\r\nContent-type: text/plain\r\nContent-length: " .. #Content .. "\r\n\r\n" .. Content)
							a_Link:Shutdown()
						end
					end,
					
					OnRemoteClosed = function (a_Link)
						LOG("httpstime: link closed by remote")
					end
				}  -- Link callbacks
			end,  -- OnIncomingConnection()
			
			-- Start TLS on the new link:
			OnAccepted = function (a_Link)
				local res, msg = a_Link:StartTLSServer(g_HTTPSCert, g_HTTPSPrivKey, "")
				if not(res) then
					LOG("https-time server(" .. a_Port .. "): Cannot start TLS server: " .. msg)
					a_Link:Close()
				end
			end,  -- OnAccepted()
			
			-- There was an error listening on the port:
			OnError = function (a_ErrorCode, a_ErrorMsg)
				LOGINFO("https-time server(" .. a_Port .. "): Cannot listen: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
			end,  -- OnError()
		}  -- Listen callbacks
	end,  -- httpstime
	
	-- TODO: Other services (daytime, ...)
}





function Initialize(a_Plugin)
	-- Load the splashes.txt file into g_Fortunes, overwriting current content:
	local idx = 1
	for line in io.lines(a_Plugin:GetLocalFolder() .. "/splashes.txt") do
		g_Fortunes[idx] = line
		idx = idx + 1
	end
	
	-- Use the InfoReg shared library to process the Info.lua file:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()
	RegisterPluginInfoConsoleCommands()

	-- Seed the random generator:
	math.randomseed(os.time())
	
	return true
end





function HandleConsoleNetClient(a_Split)
	-- Get the address to connect to:
	local Host = a_Split[3] or "google.com"
	local Port = a_Split[4] or 80
	
	-- Create the callbacks "personalised" for the address:
	local Callbacks =
	{
		OnConnected = function (a_Link)
			LOG("Connected to " .. Host .. ":" .. Port .. ".")
			LOG("Connection stats: Remote address: " .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. ", Local address: " .. a_Link:GetLocalIP() .. ":" .. a_Link:GetLocalPort())
			LOG("Sending HTTP request for front page.")
			a_Link:Send("GET / HTTP/1.0\r\nHost: " .. Host .. "\r\n\r\n")
		end,
		
		OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
			LOG("Connection to " .. Host .. ":" .. Port .. " failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
		
		OnReceivedData = function (a_Link, a_Data)
			LOG("Received data from " .. Host .. ":" .. Port .. ":\r\n" .. a_Data)
		end,
		
		OnRemoteClosed = function (a_Link)
			LOG("Connection to " .. Host .. ":" .. Port .. " was closed by the remote peer.")
		end
	}
	
	-- Queue a connect request:
	local res = cNetwork:Connect(Host, Port, Callbacks)
	if not(res) then
		LOGWARNING("cNetwork:Connect call failed immediately")
		return true
	end
	
	return true, "Client connection request queued."
end





function HandleConsoleNetClose(a_Split)
	-- Get the port to close:
	local Port = tonumber(a_Split[3] or 1024)
	if not(Port) then
		return true, "Bad port number: \"" .. a_Split[3] .. "\"."
	end

	-- Close the server, if there is one:
	if not(g_Servers[Port]) then
		return true, "There is no server currently listening on port " .. Port .. "."
	end
	g_Servers[Port]:Close()
	g_Servers[Port] = nil
	return true, "Port " .. Port .. " closed."
end





function HandleConsoleNetIps(a_Split)
	local Addresses = cNetwork:EnumLocalIPAddresses()
	LOG("IP addresses enumerated, " .. #Addresses .. " found")
	for idx, addr in ipairs(Addresses) do
		LOG("  IP #" .. idx .. ": " .. addr)
	end
	return true
end





function HandleConsoleNetLookup(a_Split)
	-- Get the name to look up:
	local Addr = a_Split[3] or "google.com"
	
	-- Create the callbacks "personalised" for the host:
	local Callbacks =
	{
		OnNameResolved = function (a_Hostname, a_IP)
			LOG(a_Hostname .. " resolves to " .. a_IP)
		end,
		
		OnError = function (a_Query, a_ErrorCode, a_ErrorMsg)
			LOG("Failed to retrieve information for " .. a_Query .. ": " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
			assert(a_Query == Addr)
		end,
		
		OnFinished = function (a_Query)
			LOG("Resolving " .. a_Query .. " has finished.")
			assert(a_Query == Addr)
		end,
	}
	
	-- Queue both name and IP DNS queries;
	-- we don't distinguish between an IP and a hostname in this command so we don't know which one to use:
	local res = cNetwork:HostnameToIP(Addr, Callbacks)
	if not(res) then
		LOGWARNING("cNetwork:HostnameToIP call failed immediately")
		return true
	end
	res = cNetwork:IPToHostname(Addr, Callbacks)
	if not(res) then
		LOGWARNING("cNetwork:IPToHostname call failed immediately")
		return true
	end
	
	return true, "DNS query has been queued."
end





function HandleConsoleNetListen(a_Split)
	-- Get the params:
	local Port = tonumber(a_Split[3] or 1024)
	if not(Port) then
		return true, "Invalid port: \"" .. a_Split[3] .. "\"."
	end
	local Service = string.lower(a_Split[4] or "echo")
	
	-- Create the callbacks specific for the service:
	if (g_Services[Service] == nil) then
		return true, "No such service: " .. Service
	end
	local Callbacks = g_Services[Service](Port)
	
	-- Start the server:
	local srv = cNetwork:Listen(Port, Callbacks)
	if not(srv:IsListening()) then
		-- The error message has already been printed in the Callbacks.OnError()
		return true
	end
	g_Servers[Port] = srv
	return true, Service .. " server started on port " .. Port
end





function HandleConsoleNetSClient(a_Split)
	-- Get the address to connect to:
	local Host = a_Split[3] or "github.com"
	local Port = a_Split[4] or 443

	-- Create the callbacks "personalised" for the address:
	local Callbacks =
	{
		OnConnected = function (a_Link)
			LOG("Connected to " .. Host .. ":" .. Port .. ".")
			LOG("Connection stats: Remote address: " .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. ", Local address: " .. a_Link:GetLocalIP() .. ":" .. a_Link:GetLocalPort())
			LOG("Sending HTTP request for front page.")
			a_Link:StartTLSClient()
			a_Link:Send("GET / HTTP/1.0\r\nHost: " .. Host .. "\r\n\r\n")
		end,

		OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
			LOG("Connection to " .. Host .. ":" .. Port .. " failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,

		OnReceivedData = function (a_Link, a_Data)
			LOG("Received data from " .. Host .. ":" .. Port .. ":\r\n" .. a_Data)
		end,

		OnRemoteClosed = function (a_Link)
			LOG("Connection to " .. Host .. ":" .. Port .. " was closed by the remote peer.")
		end
	}

	-- Queue a connect request:
	local res = cNetwork:Connect(Host, Port, Callbacks)
	if not(res) then
		LOGWARNING("cNetwork:Connect call failed immediately")
		return true
	end

	return true, "SSL Client connection request queued."
end





function HandleConsoleNetUdpClose(a_Split)
	-- Get the port to close:
	local Port = tonumber(a_Split[4] or 1024)
	if not(Port) then
		return true, "Bad port number: \"" .. a_Split[4] .. "\"."
	end

	-- Close the server, if there is one:
	if not(g_UDPEndpoints[Port]) then
		return true, "There is no UDP endpoint currently listening on port " .. Port .. "."
	end
	g_UDPEndpoints[Port]:Close()
	g_UDPEndpoints[Port] = nil
	return true, "UDP Port " .. Port .. " closed."
end





function HandleConsoleNetUdpListen(a_Split)
	-- Get the params:
	local Port = tonumber(a_Split[4] or 1024)
	if not(Port) then
		return true, "Invalid port: \"" .. a_Split[4] .. "\"."
	end
	
	local Callbacks =
	{
		OnReceivedData = function (a_Endpoint, a_Data, a_RemotePeer, a_RemotePort)
			LOG("Incoming UDP datagram from " .. a_RemotePeer .. " port " .. a_RemotePort .. ":\r\n" .. a_Data)
		end,
		
		OnError = function (a_Endpoint, a_ErrorCode, a_ErrorMsg)
			LOG("Error in UDP endpoint: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
	}
	
	g_UDPEndpoints[Port] = cNetwork:CreateUDPEndpoint(Port, Callbacks)
	return true, "UDP listener on port " .. Port .. " started."
end





function HandleConsoleNetUdpSend(a_Split)
	-- Get the params:
	local Host = a_Split[4] or "localhost"
	local Port = tonumber(a_Split[5] or 1024)
	if not(Port) then
		return true, "Invalid port: \"" .. a_Split[5] .. "\"."
	end
	local Message
	if (a_Split[6]) then
		Message = table.concat(a_Split, " ", 6)
	else
		Message = "hello"
	end
	
	-- Define minimum callbacks for the UDP endpoint:
	local Callbacks =
	{
		OnError = function (a_Endpoint, a_ErrorCode, a_ErrorMsg)
			LOG("Error in UDP datagram sending: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
		
		OnReceivedData = function ()
			-- ignore
		end,
	}
	
	-- Send the data:
	local Endpoint = cNetwork:CreateUDPEndpoint(0, Callbacks)
	Endpoint:EnableBroadcasts()
	if not(Endpoint:Send(Message, Host, Port)) then
		Endpoint:Close()
		return true, "Sending UDP datagram failed"
	end
	Endpoint:Close()
	return true, "UDP datagram sent"
end





function HandleConsoleNetWasc(a_Split)
	local Callbacks =
	{
		OnConnected = function (a_Link)
			LOG("Connected to webadmin, starting TLS...")
			local res, msg = a_Link:StartTLSClient("", "", "")
			if not(res) then
				LOG("Failed to start TLS client: " .. msg)
				return
			end
			-- We need to send a keep-alive due to #1737
			a_Link:Send("GET / HTTP/1.0\r\nHost: localhost\r\nConnection: keep-alive\r\n\r\n")
		end,
		
		OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
			LOG("Connection to webadmin failed: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
		
		OnReceivedData = function (a_Link, a_Data)
			LOG("Received data from webadmin:\r\n" .. a_Data)
			
			-- Close the link once all the data is received:
			if (a_Data == "0\r\n\r\n") then  -- Poor man's end-of-data detection; works on localhost
				-- TODO: The Close() method is not yet exported to Lua
				-- a_Link:Close()
			end
		end,
		
		OnRemoteClosed = function (a_Link)
			LOG("Connection to webadmin was closed")
		end,
	}
	
	if not(cNetwork:Connect("localhost", "8080", Callbacks)) then
		LOG("Canot connect to webadmin")
	end
	
	return true
end




