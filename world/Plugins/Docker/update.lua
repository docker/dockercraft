-- UPDATE OPERATIONS
-- The following functions can be used to update blocks in the map.
-- There are 3 update types:
-- UPDATE_SET: set a block
-- UPDATE_DIG: remove a block
-- UPDATE_SIGN: update a sign
-- Update operations are queued.
-- An new update queue can be created using NewUpdateQueue()

UPDATE_SET = 0
UPDATE_DIG = 1
UPDATE_SIGN = 2

function NewUpdateQueue(world)
    q = {
        first=nil,
        last=nil,
        current=nil,
        world=world,
        newUpdate=Queue.newUpdate,
        update=Queue.update
    }
    return q
end

Queue = {first=nil,last=nil,current=nil,world=nil}

-- Queue.newUpdate creates an update operation and
-- inserts it in the queue or returns an error
-- in case of UPDATE_SIGN, line 1 to 4  should
-- be present in meta parameter.
-- the delay is optional and will make sure that
-- the update is not triggered before given amount
-- of ticks (0 by default)
function Queue:newUpdate(updateType, x, y, z, blockID, meta, delay)
    if updateType ~= UPDATE_SET and updateType ~= UPDATE_DIG and updateType ~= UPDATE_SIGN
    then
        return NewError(1,"NewUpdate: wrong update type")
    end

    if delay == nil
    then
        delay = 0
    end
    
    update = {op=updateType,next=nil,world=self.world,x=x,y=y,z=z,blockID=blockID,meta=meta,delay=delay}

    -- update.exec executes update operation
    -- and returns an error if it fails
    function update:exec()
        w = self.world:getWorld()
        if w == nil
        then
            return NewError(1, "NewUpdate: can't get world object")
        end

        if self.op == UPDATE_SET
        then
            w:SetBlock(self.x,self.y,self.z,self.blockID,self.meta)
        elseif self.op == UPDATE_DIG
        then
            w:DigBlock(self.x,self.y,self.z)
        elseif self.op == UPDATE_SIGN
        then
            w:SetSignLines(self.x,self.y,self.z,self.meta.line1,self.meta.line2,self.meta.line3,self.meta.line4)
        else
            return NewError(1,"update:exec: unknown update type: " .. tostring(self.op))
        end
    end -- ends update.exec

    if self.first == nil then
    	self.first = update
    	self.last = update
    else
    	self.last.next = update
    	self.last = update
    end
end -- ends queue.newUpdate

-- Queue:update triggers updates starting from
-- the first one. It stops when the limit
-- is reached, of if there are no more
-- operations in the queue. It returns
-- the amount of updates executed.
-- When an update has a delay > 0, the delay
-- is decremented, and the number of updates
-- executed is not incremented.
function Queue:update(limit)
    n = 0
    self.current = self.first

    while n < limit and self.current ~= nil
    do
        if self.current.delay == 0 then
            err = self.current:exec()
            if err ~= nil then
                LOG("queue:update error: " .. err.message)
                break
            end

            if self.current == self.first then
                self.first = self.current.next
            end
            n = n + 1
        else
            self.current.delay = self.current.delay - 1
        end
        self.current = self.current.next
    end
    return n
end
