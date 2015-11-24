json = require "json"

TCP_CONN = nil
TCP_DATA = ""

TCP_CLIENT = {

	OnConnected = function (TCPConn)
		-- The specified link has succeeded in connecting to the remote server.
		-- Only called if the link is being connected as a client (using cNetwork:Connect() )
		-- Not used for incoming server links
		-- All returned values are ignored
		LOG("TCP_CLIENT OnConnected")
		TCP_CONN = TCPConn
	end,
	
	OnError = function (TCPConn, ErrorCode, ErrorMsg)
		-- The specified error has occured on the link
		-- No other callback will be called for this link from now on
		-- For a client link being connected, this reports a connection error (destination unreachable etc.)
		-- It is an Undefined Behavior to send data to a_TCPLink in or after this callback
		-- All returned values are ignored
		LOG("TCP_CLIENT OnError: " .. ErrorCode .. ": " .. ErrorMsg)
	end,
	
	OnReceivedData = function (TCPConn, Data)
		-- Data has been received on the link
		-- Will get called whenever there's new data on the link
		-- a_Data contains the raw received data, as a string
		-- All returned values are ignored
		-- LOG("TCP_CLIENT OnReceivedData")

		TCP_DATA = TCP_DATA .. Data 
		shiftLen = 0

		for message in string.gmatch(TCP_DATA, '([^\n]+\n)') do
		    shiftLen = shiftLen + string.len(message)
		    -- remove \n at the end
		    message = string.sub(message,1,string.len(message)-1)
		    ParseTCPMessage(message)
		end

		TCP_DATA = string.sub(TCP_DATA,shiftLen+1)

	end,
	
	OnRemoteClosed = function (TCPConn)
		-- The remote peer has closed the link
		-- The link is already closed, any data sent to it now will be lost
		-- No other callback will be called for this link from now on
		-- All returned values are ignored
		LOG("TCP_CLIENT OnRemoteClosed")
	end,
}

function SendTCPMessage(cmd, args, id)
	if TCP_CONN == nil
	then
		LOG("can't send TCP message, TCP_CLIENT not connected")
		return
	end
	v = {cmd=cmd, args=args, id=id}
	msg = json.stringify(v) .. "\n"
	TCP_CONN:Send(msg)
end

function ParseTCPMessage(message)
	m = json.parse(message)
	if m.cmd == "event" and table.getn(m.args) > 0 and m.args[1] == "containers"
	then
		handleContainerEvent(m.data)
	end
end

function handleContainerEvent(event)	

	if event.action == "containerInfos"
	then
		state = CONTAINER_STOPPED
		if event.running then
			state = CONTAINER_RUNNING
		end
		updateContainer(event.id,event.name,event.imageRepo,event.imageTag,state)
	end

	if event.action == "startContainer"
	then
		updateContainer(event.id,event.name,event.imageRepo,event.imageTag,CONTAINER_RUNNING)
	end

	if event.action == "createContainer"
	then
		updateContainer(event.id,event.name,event.imageRepo,event.imageTag,CONTAINER_CREATED)
	end

	if event.action == "stopContainer"
	then
		updateContainer(event.id,event.name,event.imageRepo,event.imageTag,CONTAINER_STOPPED)
	end

	if event.action == "destroyContainer"
	then
		destroyContainer(event.id)
	end

	if event.action == "stats"
	then
		updateStats(event.id,event.ram,event.cpu)
	end
end
