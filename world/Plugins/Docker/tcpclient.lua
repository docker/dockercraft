json = require "json"

TCP_CLIENT = {

	OnConnected = function (TCPConn)
		-- The specified link has succeeded in connecting to the remote server.
		-- Only called if the link is being connected as a client (using cNetwork:Connect() )
		-- Not used for incoming server links
		-- All returned values are ignored
		LOG("TCP_CLIENT OnConnected")
		LOG("TCP_CLIENT sending...")
		v = {foo="bar",baz=2}
		msg = json.stringify(v) .. "\n"
		TCPConn:Send(msg)
		LOG("TCP_CLIENT sent")
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
		LOG("TCP_CLIENT OnReceivedData")
	end,
	
	OnRemoteClosed = function (TCPConn)
		-- The remote peer has closed the link
		-- The link is already closed, any data sent to it now will be lost
		-- No other callback will be called for this link from now on
		-- All returned values are ignored
		LOG("TCP_CLIENT OnRemoteClosed")
	end,
}