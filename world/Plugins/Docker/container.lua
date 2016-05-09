-- Container object is the representation of a Docker
-- container in the Minecraft world

-- constant variables
CONTAINER_CREATED = 0
CONTAINER_RUNNING = 1
CONTAINER_STOPPED = 2

-- NewContainer returns a Container object,
-- representation of a Docker container in
-- the Minecraft world
function NewContainer()
    c = {
        world = nil,
        displayed = false,
        x = 0,
        z = 0,
        name="",
        id="",
        imageRepo="",
        imageTag="",
        running=false,
        init=Container.init,
        setInfos=Container.setInfos,
        destroy=Container.destroy,
        display=Container.display,
        updateMemSign=Container.updateMemSign,
        updateCPUSign=Container.updateCPUSign,
        addGround=Container.addGround
    }
    return c
end

Container = {world=nil, displayed = false, x = 0, z = 0, name="",id="",imageRepo="",imageTag="",running=false}

-- Container:init sets Container's position
function Container:init(x,z)
    self.x = x
    self.z = z
    self.displayed = false
end

-- Container:setInfos sets Container's id, name, imageRepo,
-- image tag and running state
function Container:setInfos(world,id,name,imageRepo,imageTag,running)
    self.world = world
    self.id = id
    self.name = name
    self.imageRepo = imageRepo
    self.imageTag = imageTag
    self.running = running
end

-- Container:destroy removes all blocks of the
-- container, it won't be visible on the map anymore
function Container:destroy(running)
    local x = self.x+2
    local y = GROUND_LEVEL+2
    local z = self.z+2
    local world = self.world:getWorld()
    world:BroadcastSoundEffect("random.explode", x, y, z, 1, 1)
    world:BroadcastParticleEffect("hugeexplosion",x, y, z, 0, 0, 0, 1, 1)

    -- if a block is removed before it's button/lever/sign, that object will drop
    -- and the player can collect it. Remove these first

    -- lever
    self.world:digBlock(self.x+1,GROUND_LEVEL+3,self.z+1)
    -- signs
    self.world:digBlock(self.x+3,GROUND_LEVEL+2,self.z-1)
    self.world:digBlock(self.x,GROUND_LEVEL+2,self.z-1)
    self.world:digBlock(self.x+1,GROUND_LEVEL+2,self.z-1)
    -- torch
    self.world:digBlock(self.x+1,GROUND_LEVEL+3,self.z+1)
    --button
    self.world:digBlock(self.x+2,GROUND_LEVEL+3,self.z+2)

    -- rest of the blocks
    for py = GROUND_LEVEL+1, GROUND_LEVEL+4
    do
        for px=self.x-1, self.x+4
        do
            for pz=self.z-1, self.z+5
            do
                self.world:digBlock(px,py,pz)
            end
        end
    end
end

-- Container:display displays all Container's blocks
-- Blocks will be blue if the container is running,
-- orange otherwise.
function Container:display(running)
    local metaPrimaryColor = E_META_WOOL_LIGHTBLUE
    local metaSecondaryColor = E_META_WOOL_BLUE

    if running == false
    then
        metaPrimaryColor = E_META_WOOL_ORANGE
        metaSecondaryColor = E_META_WOOL_RED
    end

    self.displayed = true

    for px=self.x, self.x+3
    do
        for pz=self.z, self.z+4
        do
                self.world:setBlock(px,GROUND_LEVEL+1,pz,E_BLOCK_WOOL,metaPrimaryColor)
        end
    end

    for py=GROUND_LEVEL+2, GROUND_LEVEL+3
    do
        self.world:setBlock(self.x+1,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

        -- leave empty space for the door
        -- setBlock(self.x+2,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

        self.world:setBlock(self.x,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)
        self.world:setBlock(self.x+3,py,self.z,E_BLOCK_WOOL,metaPrimaryColor)

        self.world:setBlock(self.x,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)
        self.world:setBlock(self.x+3,py,self.z+1,E_BLOCK_WOOL,metaSecondaryColor)

        self.world:setBlock(self.x,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)
        self.world:setBlock(self.x+3,py,self.z+2,E_BLOCK_WOOL,metaPrimaryColor)

        self.world:setBlock(self.x,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)
        self.world:setBlock(self.x+3,py,self.z+3,E_BLOCK_WOOL,metaSecondaryColor)

        self.world:setBlock(self.x,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
        self.world:setBlock(self.x+3,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)

        self.world:setBlock(self.x+1,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
        self.world:setBlock(self.x+2,py,self.z+4,E_BLOCK_WOOL,metaPrimaryColor)
    end

    -- torch
    self.world:setBlock(self.x+1,GROUND_LEVEL+3,self.z+3,E_BLOCK_TORCH,E_META_TORCH_ZP)

    -- start / stop lever
    self.world:setBlock(self.x+1,GROUND_LEVEL + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XP)
    self.world:updateSign(self.x+1,GROUND_LEVEL + 3,self.z + 2,"","START/STOP","---->","",2)


    if running
    then
        self.world:setBlock(self.x+1,GROUND_LEVEL+3,self.z+1,E_BLOCK_LEVER,1)
    else
        self.world:setBlock(self.x+1,GROUND_LEVEL+3,self.z+1,E_BLOCK_LEVER,9)
    end

    -- remove button

    self.world:setBlock(self.x+2,GROUND_LEVEL + 3,self.z + 2,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_XM)
    self.world:updateSign(self.x+2,GROUND_LEVEL + 3,self.z + 2,"","REMOVE","---->","",2)

    self.world:setBlock(self.x+2,GROUND_LEVEL+3,self.z+3,E_BLOCK_STONE_BUTTON,E_BLOCK_BUTTON_XM)

    -- door
    -- Cuberite bug with Minecraft 1.8 apparently, doors are not displayed correctly
    -- setBlock(UpdateQueue,self.x+2,GROUND_LEVEL+2,self.z,E_BLOCK_WOODEN_DOOR,E_META_CHEST_FACING_ZM)

    for px=self.x, self.x+3
    do
        for pz=self.z, self.z+4
        do
            self.world:setBlock(px,GROUND_LEVEL + 4,pz,E_BLOCK_WOOL,metaPrimaryColor)
        end
    end

    self.world:setBlock(self.x+3,GROUND_LEVEL + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
    self.world:updateSign(self.x+3,GROUND_LEVEL + 2,self.z - 1,string.sub(self.id,1,8),self.name,self.imageRepo,self.imageTag,2)

    -- Mem sign
    self.world:setBlock(self.x,GROUND_LEVEL + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)

    -- CPU sign
    self.world:setBlock(self.x+1,GROUND_LEVEL + 2,self.z - 1,E_BLOCK_WALLSIGN,E_META_CHEST_FACING_ZM)
end


-- Container:updateMemSign updates the mem usage
-- value displayed on Container's sign
function Container:updateMemSign(s)
    self.world:updateSign(self.x,GROUND_LEVEL + 2,self.z - 1,"Mem usage","",s,"")
end

-- Container:updateCPUSign updates the mem usage
-- value displayed on Container's sign
function Container:updateCPUSign(s)
    self.world:updateSign(self.x+1,GROUND_LEVEL + 2,self.z - 1,"CPU usage","",s,"")
end

-- Container:addGround creates ground blocks
-- necessary to display the container
function Container:addGround()
    LOG("Drawing ground in " .. self.world.Name .. " for container " .. self.id)
    if self.world.groundMinX > self.x - 2
    then
        local groundMinX = self.world.groundMinX
        local y = GROUND_LEVEL
	self.world.groundMinX = self.x - 2
        for x=self.world.groundMinX, groundMinX
        do
            for z=GROUND_MIN_Z,GROUND_MAX_Z
            do
                self.world:setBlock(x,y,z,E_BLOCK_WOOL,E_META_WOOL_WHITE)
            end
        end
    end
end
