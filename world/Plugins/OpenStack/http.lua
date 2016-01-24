function request(Host, Port, Method, Path, Body, ReceiveCallback)
	local data = ""
	local ConnectCallbacks =
	{
		OnConnected = function (a_Link)
			-- Connection succeeded, send the http request:
			if Body ~= nill and string.len(Body) > 0 then
				send_text = Method .. " " .. Path .. " HTTP/1.1\r\nHost: " .. Host .. "\r\nContent-Type: application/json\r\nContent-Length: " ..  string.len(Body) .. "\r\n\r\n" .. Body .. "\r\n"
			else
				LOG("no body")
				send_text = Method .. " " .. Path .. " HTTP/1.1\r\nHost: " .. Host .. "\r\nContent-Type: application/json\r\n\r\n\r\n"
			end


			LOG(send_text)
			a_Link:Send(send_text)
		end,
		
		OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
			-- Log the error to console:
			LOG("An error has occurred while talking to google.com: " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
		
		OnReceivedData = function (a_Link, a_Data)
			data = data .. a_Data
			LOG(a_Data)
		end,
		
		OnRemoteClosed = function (a_Link)
			LOG(data)
			res, body = string.match(data, '^%S+ (%d+) .+\r\n\r\n(.*)$')
			if  ReceiveCallback ~= nil then
				ReceiveCallback(res, body)
			end
			LOG("Connection to " .. Host .. " closed")
		end,
	}

	-- Connect:
	if not(cNetwork:Connect(Host, Port, ConnectCallbacks)) then
		-- Highly unlikely, but better check for errors
		LOG("Cannot queue connection to " .. Host)
	end
end

function listen(Port, ReceiveCallback)
	local data = {}
	local length = {}

	-- Define the callbacks used for the incoming connections:
	local Callbacks =
	{
		OnConnected = function (a_Link)
			-- This will not be called for a server connection, ever
			LOG("Port" .. Port .. "connected")
			assert(false, "Unexpected Connect callback call")
		end,
		
		OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
			-- Log the error to console:
			local RemoteName = "'" .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. "'"
			LOG("An error has occurred while talking to " .. RemoteName .. ": " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,
		
		OnReceivedData = function (a_Link, a_Data)
			local key = a_Link:GetRemoteIP() .. '_' .. a_Link:GetRemotePort()
			LOG(key)
			-- Send the received data back to the remote peer
			if data[key] == nil then
				length_str, data[key] = string.match(a_Data, '^.+Content%-Length: (%d+).+\r\n\r\n(.*)$')
				length[key] = tonumber(length_str)
			else
				data[key] = data[key] .. a_Data
			end
			if string.len(data[key]) >= length[key] then
				ReceiveCallback(data[key])
				a_Link:Close()
				data[key] = nil
				length[key] = nil
			end
		end,
		
		OnRemoteClosed = function (a_Link)
			-- Log the event into the console:
			local RemoteName = "'" .. a_Link:GetRemoteIP() .. ":" .. a_Link:GetRemotePort() .. "'"
			LOG("Connection to '" .. RemoteName .. "' closed")
		end,
	}

	-- Define the callbacks used by the server:
	local ListenCallbacks =
	{
		OnAccepted = function (a_Link)
			-- No processing needed, just log that this happened:
			LOG("OnAccepted callback called")
		end,
		
		OnError = function (a_ErrorCode, a_ErrorMsg)
			-- An error has occured while listening for incoming connections, log it:
			LOG("Cannot listen, error " .. a_ErrorCode .. " (" .. a_ErrorMsg .. ")")
		end,

		OnIncomingConnection = function (a_RemoteIP, a_RemotePort, a_LocalPort)
			-- A new connection is being accepted, give it the EchoCallbacks
			return Callbacks
		end,
	}

	-- Start the server:
	local Server = cNetwork:Listen(Port, ListenCallbacks)
	if not(Server:IsListening()) then
		-- The error has been already printed in the OnError() callbacks
		-- Just bail out
		return;
	end

	-- Store the server globally, so that it stays open:
	g_Server = Server


	-- Elsewhere in the code, when terminating:
	-- Close the server and let it be garbage-collected:
	-- g_Server:Close()
	-- g_Server = nil
end