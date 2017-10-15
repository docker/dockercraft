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

function NewUpdateQueue()
  queue = {first=0, last=-1, current=nil}

  -- queue.newUpdate creates an update operation and
  -- inserts it in the queue or returns an error
  -- in case of UPDATE_SIGN, line 1 to 4  should
  -- be present in meta parameter.
  -- the delay is optional and will make sure that
  -- the update is not triggered before given amount
  -- of ticks (0 by default)
  function queue:newUpdate(updateType, x, y, z, blockID, meta, delay)
    if updateType ~= UPDATE_SET and updateType ~= UPDATE_DIG and updateType ~= UPDATE_SIGN
    then
      return NewError(1,"NewUpdate: wrong update type")
    end

    if delay == nil
    then
      delay = 0
    end

    update = {op=updateType,x=x,y=y,z=z,blockID=blockID,meta=meta,delay=delay}

    -- update.exec executes update operation
    -- and returns an error if it fails
    function update:exec()
      if self.op == UPDATE_SET
      then
        cRoot:Get():GetDefaultWorld():SetBlock(self.x,self.y,self.z,self.blockID,self.meta)
      elseif self.op == UPDATE_DIG
      then
        cRoot:Get():GetDefaultWorld():DigBlock(self.x,self.y,self.z)
      elseif self.op == UPDATE_SIGN
      then
        cRoot:Get():GetDefaultWorld():SetSignLines(self.x,self.y,self.z,self.meta.line1,self.meta.line2,self.meta.line3,self.meta.line4)
      else
        return NewError(1,"update:exec: unknown update type: " .. tostring(self.op))
      end
    end

    self:push(update)
  end -- ends queue.newUpdate

  -- update triggers updates starting from
  -- the first one. It stops when the limit
  -- is reached, of if there are no more
  -- operations in the queue. It returns
  -- the amount of updates executed.
  -- When an update has a delay > 0, the delay
  -- is decremented, and the number of updates
  -- executed is not incremented.
  function queue:update(limit)
    local n = 0
    if self.current == nil
    then
      self.current = self:pop()
    end
    while n < limit and self.current ~= nil
    do
      if self.current.delay == 0
      then
        err = self.current:exec()
        if err ~= nil
        then
          break
        end
        n = n + 1
        self.current = self:pop()
      else
        self.current.delay = self.current.delay - 1
      end
    end
    return n
  end

  function queue:push(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
  end

  function queue:pop()
    local first = self.first
    if first > self.last then return nil end
    local value = self[first]
    self[first] = nil -- to allow garbage collection
    self.first = first + 1
    return value
  end

  return queue
end

-- setBlock adds an update in given queue to
-- set a block at x,y,z coordinates
function setBlock(queue,x,y,z,blockID,meta)
  queue:newUpdate(UPDATE_SET, x, y, z, blockID, meta)
end

-- setBlock adds an update in given queue to
-- remove a block at x,y,z coordinates
function digBlock(queue,x,y,z)
  queue:newUpdate(UPDATE_DIG, x, y, z)
end

-- setBlock adds an update in given queue to
-- update a sign at x,y,z coordinates with
-- 4 lines of text
function updateSign(queue,x,y,z,line1,line2,line3,line4,delay)
  meta = {line1=line1,line2=line2,line3=line3,line4=line4}
  queue:newUpdate(UPDATE_SIGN, x, y, z, nil, meta, delay)
end
