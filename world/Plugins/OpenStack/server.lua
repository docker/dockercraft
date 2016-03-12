-- server design is copied from Dockercraft container

-- Server class

cServer = {}
cServer.__index = cServer

-- for null object
cNilServer = {}
cNilServer.__index = cNilServer

-- contains all server objects
local g_Servers = {}

function cServer.new(a_X, a_Z, a_Id, a_Name, a_Status)
	local self = setmetatable({}, cServer)

	self.m_X = a_X
	self.m_Z = a_Z
	self.m_Name = a_Name
	self.m_Id = a_Id
	self.m_ImageName = ""
	self.m_IsRunning = false
	if a_Status == SERVER_RUNNING then
		self.m_IsRunning = true
	end

	self:AddGround()
	self:Display()

	return self
end

function cNilServer.new()
	local self = setmetatable({}, cNilServer)

	self.m_X = 0
	self.m_Z = 0
	self.m_Name = ""
	self.m_Id = ""
	self.m_ImageName = ""
	self.m_IsRnning = false

	return self
end

-- Null object
local g_NilServerObject = cNilServer.new()

-- constant variables
SERVER_CREATED = 0
SERVER_RUNNING = 1
SERVER_STOPPED = 2


function cServer:SetRunning(a_IsRunning)
	if self.m_IsRunning ~= a_IsRunning then
		self.m_IsRunning = a_IsRunning
		self:Display()
	end
end

-- Null object function does nothing
function cNilServer:SetRunning(...)
end


function cServer:Delete()
	for py = GROUND_LEVEL + 1, GROUND_LEVEL + 4 do
		for px = self.m_X - 1, self.m_X + 4 do
			for pz = self.m_Z - 1, self.m_Z + 5 do
				digBlock(UpdateQueue, px, py, pz)
			end	
		end
	end
end

-- Null object function does nothing
function cNilServer:Delete(...)
end

function cServer:Display()

	metaPrimaryColor = E_META_WOOL_LIGHTBLUE
	metaSecondaryColor = E_META_WOOL_BLUE

	if self.m_IsRunning == false then
		metaPrimaryColor = E_META_WOOL_ORANGE
		metaSecondaryColor = E_META_WOOL_RED
	end
	
	for px = self.m_X, self.m_X + 3 do
		for pz = self.m_Z, self.m_Z + 4 do
			setBlock(UpdateQueue,px,GROUND_LEVEL + 1,pz,E_BLOCK_WOOL,metaPrimaryColor)
		end
	end

	for py = GROUND_LEVEL + 2, GROUND_LEVEL + 3 do
		setBlock(UpdateQueue,self.m_X + 1,py,self.m_Z,E_BLOCK_WOOL,metaPrimaryColor)

		-- leave empty space for the door
		-- setBlock(UpdateQueue,self.m_X+2,py,self.m_Z,E_BLOCK_WOOL,metaPrimaryColor)
		
		setBlock(UpdateQueue, self.m_X, py, self.m_Z, E_BLOCK_WOOL, metaPrimaryColor)
		setBlock(UpdateQueue, self.m_X + 3, py, self.m_Z, E_BLOCK_WOOL, metaPrimaryColor)

		setBlock(UpdateQueue, self.m_X, py, self.m_Z + 1, E_BLOCK_WOOL, metaSecondaryColor)
		setBlock(UpdateQueue, self.m_X + 3, py, self.m_Z+1, E_BLOCK_WOOL, metaSecondaryColor)

		setBlock(UpdateQueue, self.m_X, py, self.m_Z + 2, E_BLOCK_WOOL, metaPrimaryColor)
		setBlock(UpdateQueue, self.m_X + 3, py, self.m_Z + 2, E_BLOCK_WOOL, metaPrimaryColor)

		setBlock(UpdateQueue, self.m_X, py, self.m_Z + 3, E_BLOCK_WOOL, metaSecondaryColor)
		setBlock(UpdateQueue, self.m_X + 3, py, self.m_Z + 3, E_BLOCK_WOOL, metaSecondaryColor)

		setBlock(UpdateQueue, self.m_X, py, self.m_Z + 4, E_BLOCK_WOOL, metaPrimaryColor)
		setBlock(UpdateQueue, self.m_X + 3,py, self.m_Z + 4, E_BLOCK_WOOL, metaPrimaryColor)

		setBlock(UpdateQueue, self.m_X + 1, py, self.m_Z + 4, E_BLOCK_WOOL, metaPrimaryColor)
		setBlock(UpdateQueue, self.m_X + 2, py, self.m_Z + 4, E_BLOCK_WOOL, metaPrimaryColor)
	end

	-- torch
	setBlock(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 3, self.m_Z + 3, E_BLOCK_TORCH, E_META_TORCH_ZP)

	-- start / stop lever
	setBlock(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 3, self.m_Z + 2, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_XP)
	updateSign(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 3, self.m_Z + 2, "", "START/STOP", "---->", "", 2)


	if self.m_IsRunning == true then
		setBlock(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 3, self.m_Z + 1, E_BLOCK_LEVER, 1)
	else
		setBlock(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 3, self.m_Z + 1, E_BLOCK_LEVER, 9)
	end


	-- remove button

	setBlock(UpdateQueue, self.m_X + 2, GROUND_LEVEL + 3, self.m_Z + 2, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_XM)
	updateSign(UpdateQueue, self.m_X + 2, GROUND_LEVEL + 3, self.m_Z + 2, "", "REMOVE","---->", "", 2)

	setBlock(UpdateQueue, self.m_X + 2, GROUND_LEVEL + 3, self.m_Z+3, E_BLOCK_STONE_BUTTON, E_BLOCK_BUTTON_XM)


	-- door
	-- Cuberite bug with Minecraft 1.8 apparently, doors are not displayed correctly
	-- setBlock(UpdateQueue,self.m_X+2,GROUND_LEVEL+2,self.m_Z,E_BLOCK_WOODEN_DOOR,E_META_CHEST_FACING_ZM)


	for px = self.m_X, self.m_X + 3 do
		for pz = self.m_Z, self.m_Z + 4 do
			setBlock(UpdateQueue, px, GROUND_LEVEL + 4, pz, E_BLOCK_WOOL,metaPrimaryColor)
		end	
	end

	setBlock(UpdateQueue, self.m_X + 3, GROUND_LEVEL + 2, self.m_Z - 1, E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
	updateSign(UpdateQueue,self.m_X + 3, GROUND_LEVEL + 2, self.m_Z - 1, string.sub(self.m_Id, 1, 8), self.m_Name, self.m_ImageName, "", 2)

	-- Mem sign
	setBlock(UpdateQueue, self.m_X, GROUND_LEVEL + 2, self.m_Z - 1, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_ZM)

	-- CPU sign
	setBlock(UpdateQueue, self.m_X + 1, GROUND_LEVEL + 2, self.m_Z - 1, E_BLOCK_WALLSIGN, E_META_CHEST_FACING_ZM)
end

-- Null object function does nothing
function cNilServer:Display(...)
end


function cServer:UpdateMemSign(a_Sign)
	updateSign(UpdateQueue, self.m_X,GROUND_LEVEL + 2, self.m_Z - 1, "Mem usage", "", a_Sign, "")
end

-- Null object function does nothing
function cNilServer:UpdateMemSign(...)
end


function cServer:UpdateCPUSign(a_Sign)
	updateSign(UpdateQueue, self.m_X+1, GROUND_LEVEL + 2, self.m_Z - 1, "CPU usage", "", a_Sign, "")
end

-- Null object function does nothing
function cNilServer:UpdateCPUSign(...)
end


function cServer:AddGround()
	if GROUND_MIN_X > self.m_X - 2 then 
		OLD_GROUND_MIN_X = GROUND_MIN_X
		GROUND_MIN_X = self.m_X - 2
		for x= GROUND_MIN_X, OLD_GROUND_MIN_X do
			for z=GROUND_MIN_Z,GROUND_MAX_Z do
				setBlock(UpdateQueue, x, y, z, E_BLOCK_WOOL, E_META_WOOL_WHITE)
			end
		end	
	end
end

-- Null object function does nothing
function cNilServer:AddGround(...)
end


-- return index of empty server if there is null object in g_Servers.
-- else, add null object at the tail of g_Servers and return index of tail
function GetSpaceIndex()
	for i, server in ipairs(g_Servers) do
		if server == g_NilServerObject then
			return i
		end
	end
	table.insert(g_Servers, g_NilServerObject)
	return table.getn(g_Servers)
end


-- current version calculate a position from index of server of a list 
-- return x and z
function GetPosition(a_Index)
	x = SERVER_START_X + SERVER_OFFSET_X * (a_Index - 1)
	z = SERVER_START_Z
	return x, z
end

-- a_Status should SERVER_RUNNING or SERVER_STOPPED
function UpdateServer(a_Id, a_Name, a_Status)
	imageName = "" --  TODO

	for i, server in ipairs(g_Servers) do
		if server.m_Id == a_Id then
			if a_Status == SERVER_RUNNING then
				server:SetRunning(true)
			else
				server:SetRunning(false)
			end
			LOG("found. updated. now return")
			return
		end
	end
	i = GetSpaceIndex()
	LOG("index: " .. i)
	x, z = GetPosition(i)
	LOG('Update ' .. tostring(x) .. ',' .. tostring(z) .. ',' .. a_Id)
	server = cServer.new(x, z, a_Id, a_Name, a_Status)
	LOG(x,z, a_Id, a_Name, a_status)
	g_Servers[i] = server
end


function DeleteServer(a_Id)
	-- loop over the servers and remove the first having the given id
	for i, server in ipairs(g_Servers) do
		LOG(server.m_Id .. ', ' .. a_Id)
		if server.m_Id == a_Id then
			server:Delete()
			g_Servers[i] = g_NilServerObject
			break
		end
	end

	-- delete nil tailing
	while g_Servers[table.getn(g_Servers)] == g_NilServerObject do
		table.remove(g_Servers, table.getn(g_Servers))
	end
end


function DeleteAllServers()
	for i, server in ipairs(g_Servers) do
		server:Delete()
	end

	g_Servers = {}
end

function GetAllServers()
	return g_Servers;
end

function GetDeleteButtonServer(a_X, a_Z)
	-- TODO refactor
	for i, server in ipairs(g_Servers) do
		if a_X == server.m_X + 2 and a_Z == server.m_Z + 3 then
			return server.m_Id
		end
	end
	return ""
end

function GetStartStopLeverServer(a_X, a_Z)
	-- TODO refactor
	for i, server in ipairs(g_Servers) do
		if a_X == server.m_X + 1 and a_Z == server.m_Z + 1 then
			return server.m_Id
		end
	end
	return ""
end