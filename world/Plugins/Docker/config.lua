-- config sets all configuration variables
-- for the Docker plugin.

-- X,Z positions to draw first container
CONTAINER_START_X = -3
CONTAINER_START_Z = 2
-- offset to draw next container
CONTAINER_OFFSET_X = -6

-- the generated Minecraft world is just
-- a white horizontal plane generated at
-- this specific level
GROUND_LEVEL = 63

-- defines minimum surface to place one container
GROUND_MIN_X = CONTAINER_START_X - 2
GROUND_MAX_X = CONTAINER_START_X + 5
GROUND_MIN_Z = -4
GROUND_MAX_Z = CONTAINER_START_Z + 6

-- block updates are queued, this defines the 
-- maximum of block updates that can be handled
-- in one single tick, for performance issues.
MAX_BLOCK_UPDATE_PER_TICK = 50
