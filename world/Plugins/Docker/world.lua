function NewWorld(name)
    w = {
        -- name of the world
        Name = name,
        -- array of container objects
        containers = {},
        --
        signsToUpdate = {},
        -- as a lua array cannot contain nil values, we store references to this object
        -- in the "Containers" array to indicate that there is no container at an index
        emptyContainerSpace = {},
        -- queue containing the updates that need to be applied to the minecraft world
        -- groundMinX
        groundMinX = GROUND_MIN_X,
        updateQueue = nil,
        getWorld = World.getWorld,
        setBlock = World.setBlock,
        digBlock = World.digBlock,
        updateSign = World.updateSign,
        updateStats = World.updateStats,
        getStartStopLeverContainer = World.getStartStopLeverContainer,
        getRemoveButtonContainer = World.getRemoveButtonContainer,
        destroyContainer = World.destroyContainer,
        updateContainer = World.updateContainer
    }
    w.updateQueue = NewUpdateQueue(w)
    return w
end

World = {Name="",containers={},signsToUpdate={},emptyContainerSpace={},groundMinX=GROUND_MIN_X,updateQueue=nil}

-- getWorld returns the cWorld object for this world
function World:getWorld()
    return cRoot:Get():GetWorld(self.Name)
end

-- setBlock adds an update in given queue to
-- set a block at x,y,z coordinates
function World:setBlock(x,y,z,blockID,meta)
    self.updateQueue:newUpdate(UPDATE_SET, x, y, z, blockID, meta)
end

-- digBlock adds an update in given queue to
-- remove a block at x,y,z coordinates
function World:digBlock(x,y,z)
    self.updateQueue:newUpdate(UPDATE_DIG, x, y, z)
end

-- updateSign adds an update in given queue to
-- update a sign at x,y,z coordinates with
-- 4 lines of text
function World:updateSign(x,y,z,line1,line2,line3,line4,delay)
    meta = {line1=line1,line2=line2,line3=line3,line4=line4}
    self.updateQueue:newUpdate(UPDATE_SIGN, x, y, z, nil, meta, delay)
end

-- updateStats update CPU and memory usage displayed
-- on container sign (container identified by id)
function World:updateStats(id, mem, cpu)
    for i=1, table.getn(self.containers)
    do
        if self.containers[i] ~= self.emptyContainerSpace and self.containers[i].id == id
        then
            self.containers[i]:updateMemSign(mem)
            self.containers[i]:updateCPUSign(cpu)
            break
        end
    end
end

-- getStartStopLeverContainer returns the container
-- id that corresponds to lever at x,y coordinates
function World:getStartStopLeverContainer(x, z)
    for i=1, table.getn(self.containers)
    do
        if self.containers[i] ~= self.emptyContainerSpace and x == self.containers[i].x + 1 and z == self.containers[i].z + 1
        then
            return self.containers[i].id
        end
    end
    return ""
end

-- getRemoveButtonContainer returns the container
-- id and state for the button at x,y coordinates
function World:getRemoveButtonContainer(x, z)
    for i=1, table.getn(self.containers)
        do
            if self.containers[i] ~= self.emptyContainerSpace and x == self.containers[i].x + 2 and z == self.containers[i].z + 3
            then
                return self.containers[i].id, self.containers[i].running
            end
        end
    return "", true
end

-- destroyContainer looks for the first container having the given id,
-- removes it from the Minecraft world and from the 'Containers' array
function World:destroyContainer(id)
    LOG("destroyContainer: " .. id)
    -- loop over the containers and remove the first having the given id
    for i=1, table.getn(self.containers)
        do
            if self.containers[i] ~= self.emptyContainerSpace and self.containers[i].id == id
            then
                -- remove the container from the self
                self.containers[i]:destroy()
                -- if the container being removed is the last element of the array
                -- we reduce the size of the "Container" array, but if it is not,
                -- we store a reference to the "EmptyContainerSpace" object at the
                -- same index to indicate this is a free space now.
                -- We use a reference to this object because it is not possible to
                -- have 'nil' values in the middle of a lua array.
                if i == table.getn(self.containers)
                then
                    table.remove(self.containers, i)
                    -- we have removed the last element of the array. If the array
                    -- has tailing empty container spaces, we remove them as well.
                    while self.containers[table.getn(self.containers)] == self.emptyContainerSpace
                    do

                        table.remove(self.containers, table.getn(self.containers))
                    end
                else
                    self.containers[i] = self.emptyContainerSpace
                end
                -- we removed the container, we can exit the loop
                break
            end
        end
end

-- updateContainer accepts 3 different states: running, stopped, created
-- sometimes "start" events arrive before "create" ones
-- in this case, we just ignore the update
function World:updateContainer(id,name,imageRepo,imageTag,state)
    LOG("Update container with ID: " .. id .. "in world: " .. self.Name .. " state: " .. state)

    -- first pass, to see if the container is
    -- already displayed (maybe with another state)
    for i=1, table.getn(self.containers)
    do
        -- if container found with same ID, we update it
        if self.containers[i] ~= self.emptyContainerSpace and self.containers[i].id == id
        then
            self.containers[i]:setInfos(self,id,name,imageRepo,imageTag,state == CONTAINER_RUNNING)
            self.containers[i]:display(state == CONTAINER_RUNNING)
            LOG("found. updated. now return")
            return
        end
    end

    -- if container isn't already displayed, we see if there's an empty space
    -- in the self to display the container
    x = CONTAINER_START_X
    index = -1

    for i=1, table.getn(self.containers)
    do
        -- use first empty location
        if self.containers[i] == self.emptyContainerSpace
        then
            LOG("Found empty location: Containers[" .. tostring(i) .. "]")
            index = i
            break
        end
        x = x + CONTAINER_OFFSET_X
    end

    container = NewContainer()
    container:init(x,CONTAINER_START_Z)
    container:setInfos(self,id,name,imageRepo,imageTag,state == CONTAINER_RUNNING)
    container:addGround()
    container:display(state == CONTAINER_RUNNING)

    if index == -1
    then
        table.insert(self.containers, container)
    else
        self.containers[index] = container
    end
end

