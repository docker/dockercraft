json = require "json"

TCP_CONN = nil
TCP_DATA = ""

TCP_CLIENT = {

  OnConnected = function (TCPConn)
    -- The specified link has succeeded in connecting to the remote server.
    -- Only called if the link is being connected as a client (using cNetwork:Connect() )
    -- Not used for incoming server links
    -- All returned values are ignored
    LOG("tcp client connected")
    TCP_CONN = TCPConn

    -- list containers
    LOG("listing containers...")
    SendTCPMessage("info",{"containers"},0)
  end,

  OnError = function (TCPConn, ErrorCode, ErrorMsg)
    -- The specified error has occurred on the link
    -- No other callback will be called for this link from now on
    -- For a client link being connected, this reports a connection error (destination unreachable etc.)
    -- It is an Undefined Behavior to send data to a_TCPLink in or after this callback
    -- All returned values are ignored
    LOG("tcp client OnError: " .. ErrorCode .. ": " .. ErrorMsg)

    -- retry to establish connection
    LOG("retry cNetwork:Connect")
    cNetwork:Connect("127.0.0.1",25566,TCP_CLIENT)
  end,

  OnReceivedData = function (TCPConn, Data)
    -- Data has been received on the link
    -- Will get called whenever there's new data on the link
    -- a_Data contains the raw received data, as a string
    -- All returned values are ignored
    -- LOG("TCP_CLIENT OnReceivedData")

    TCP_DATA = TCP_DATA .. Data
    local shiftLen = 0

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
    LOG("tcp client OnRemoteClosed")

    -- retry to establish connection
    LOG("retry cNetwork:Connect")
    cNetwork:Connect("127.0.0.1",25566,TCP_CLIENT)
  end,
}

-- SendTCPMessage sends a message over global
-- tcp connection TCP_CONN. args and id are optional
-- id stands for the request id.
function SendTCPMessage(cmd, args, id)
  if TCP_CONN == nil
  then
    LOG("can't send TCP message, TCP_CLIENT not connected")
    return
  end
  local v = {cmd=cmd, args=args, id=id}
  local msg = json.stringify(v) .. "\n"
  TCP_CONN:Send(msg)
end

-- ParseTCPMessage parses a message received from
-- global tcp connection TCP_CONN
function ParseTCPMessage(message)
  local m = json.parse(message)
  if m.cmd == "event" and table.getn(m.args) > 0 and m.args[1] == "containers"
  then
    handleContainerEvent(m.data)
  end
end

-- handleContainerEvent handles a container
-- event TCP message.
function handleContainerEvent(event)

  event.imageTag = event.imageTag or ""
  event.imageRepo = event.imageRepo or ""
  event.name = event.name or ""

  if event.action == "containerInfos"
  then
    local state = CONTAINER_STOPPED
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
