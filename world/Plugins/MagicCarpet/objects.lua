-- Location object
cLocation = {}
function cLocation:new( x, y, z )
	local object = { x = x, y = y, z = z }
	setmetatable(object, { __index = cLocation })
	return object
end

-- Offsets
cFibers = { }
function cFibers:new()
	local object = {
						cLocation:new( 2, -1, 2 ),
						cLocation:new( 2, -1, 1 ),
						cLocation:new( 2, -1, 0 ),
						cLocation:new( 2, -1, -1 ),
						cLocation:new( 2, -1, -2 ),
						cLocation:new( 1, -1, 2 ),
						cLocation:new( 1, -1, 1 ),
						cLocation:new( 1, -1, 0 ),
						cLocation:new( 1, -1, -1 ),
						cLocation:new( 1, -1, -2 ),
						cLocation:new( 0, -1, 2 ),
						cLocation:new( 0, -1, 1 ),
						cLocation:new( 0, -1, 0 ),
						cLocation:new( 0, -1, -1 ),
						cLocation:new( 0, -1, -2 ),
						cLocation:new( -1, -1, 2 ),
						cLocation:new( -1, -1, 1 ),
						cLocation:new( -1, -1, 0 ),
						cLocation:new( -1, -1, -1 ),
						cLocation:new( -1, -1, -2 ),
						cLocation:new( -2, -1, 2 ),
						cLocation:new( -2, -1, 1 ),
						cLocation:new( -2, -1, 0 ),
						cLocation:new( -2, -1, -1 ),
						cLocation:new( -2, -1, -2 ),
						imadeit = false,
					}
	setmetatable(object, { __index = cFibers })
	return object;
end

-- Carpet object
cCarpet = {}
function cCarpet:new()
	local object = {	Location = cLocation:new(0,0,0),
						Fibers = cFibers:new(),
					}
	setmetatable(object, { __index = cCarpet })
	return object
end

function cCarpet:remove()
	local World = cRoot:Get():GetDefaultWorld()
	for i, fib in ipairs( self.Fibers ) do
		local x = self.Location.x + fib.x
		local y = self.Location.y + fib.y
		local z = self.Location.z + fib.z
		local BlockID = World:GetBlock( x, y, z )
		if( fib.imadeit == true and BlockID == E_BLOCK_GLASS ) then
			World:SetBlock( x, y, z, 0, 0 )
			fib.imadeit = false
		end
	end
end

function cCarpet:draw()
	local World = cRoot:Get():GetDefaultWorld()
	for i, fib in ipairs( self.Fibers ) do
		local x = self.Location.x + fib.x
		local y = self.Location.y + fib.y
		local z = self.Location.z + fib.z
		local BlockID = World:GetBlock( x, y, z )
		if( BlockID == 0  ) then
			fib.imadeit = true
			World:SetBlock( x, y, z, E_BLOCK_GLASS, 0 )
		else
			fib.imadeit = false
		end
	end
end

function cCarpet:moveTo( NewPos )
	local x = math.floor( NewPos.x )
	local y = math.floor( NewPos.y )
	local z = math.floor( NewPos.z )
	if( self.Location.x ~= x or self.Location.y ~= y or self.Location.z ~= z ) then
		self:remove()
		self.Location = cLocation:new( x, y, z )
		self:draw()
	end
end

function cCarpet:getY()
	return self.Location.y
end