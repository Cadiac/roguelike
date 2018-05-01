local tile_size  = 16

local Wall = Object:extend()

function Wall:new(start_corner, end_corner)
  self.start_corner = start_corner
  self.end_corner = end_corner

  self.horizontal = start_corner.y == end_corner.y

  self.center = self:getCenter()
  self.potential_corridors = self:findPotentialCorridors()
end

function Wall:getCenter()
  return {
    x = (self.start_corner.x + self.end_corner.x) / 2,
    y = (self.start_corner.y + self.end_corner.y) / 2
  }
end

function Wall:findPotentialCorridors()
  local potential_corridors = {}

  for x = self.start_corner.x + tile_size, self.end_corner.x - tile_size, tile_size do
    table.insert(potential_corridors, { x = x, y = self.start_corner.y })
    table.insert(potential_corridors, { x = x, y = self.end_corner.y })
  end

  for y = self.start_corner.y + tile_size, self.end_corner.y - tile_size, tile_size do
    table.insert(potential_corridors, { x = self.start_corner.x, y = y })
    table.insert(potential_corridors, { x = self.end_corner.x, y = y })
  end

  return potential_corridors
end

function Wall:draw()
  love.graphics.setColor(0, 255, 0)
  love.graphics.line(self.start_corner.x, self.start_corner.y, self.end_corner.x, self.end_corner.y)

  for _key, potential_corridor in pairs(self.potential_corridors) do
    love.graphics.setColor({0, 0, 255})
    love.graphics.circle('fill', potential_corridor.x, potential_corridor.y, 4)
  end

end

local Room = Object:extend()

function Room:new(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.walls = {
    Wall(
      { x = self.x, y = self.y },
      { x = self.x + self.width, y = self.y }
    ),
    Wall(
      { x = self.x, y = self.y },
      { x = self.x, y = self.y + self.height }
    ),
    Wall(
      { x = self.x, y = self.y + self.height },
      { x = self.x + self.width, y = self.y + self.height }
    ),
    Wall(
      { x = self.x + self.width, y = self.y },
      { x = self.x + self.width, y = self.y + self.height }
    )
  }
end

function Room:getWalls()
  return self.walls
end

function Room:draw()
  love.graphics.rectangle('fill',
    self.x,
    self.y,
    self.width,
    self.height
  )

  for _key, wall in pairs(self.walls) do
    wall:draw()
  end
end

local Leaf = Object:extend()

function Leaf:new(x, y, width, height, level)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.min_dimension = 64
  self.max_dimension = 320
  self.tile_size = 32
  self.split_low = 0.40
  self.split_high = 0.60

  self.level = level or 0

  self.room = nil
  self.left_child = nil
  self.right_child = nil
  self.corridors = {}
  self.potential_corridors = {
    top = {},
    bottom = {},
    left = {},
    right = {}
  }
end

function Leaf:split(max_level)
  -- Has the leaf already been split
  if self.left_child or self.right_child then return false end
  if self.level > max_level then return false end

  local split_vertical = love.math.random() > 0.5

  if self.width > self.height and self.height / self.width >= 0.05 then split_vertical = true
  elseif self.height > self.width and self.width / self.height >= 0.05 then split_vertical = false end

  if split_vertical then
    -- If the area is too small stop splitting
    if self.width - self.min_dimension < self.min_dimension then return false end

    -- Round down to tilesize
    local rand_position = random(self.split_low, self.split_high) * self.width
    local split_position = math.floor(rand_position - rand_position % self.tile_size)

    self.left_child = Leaf(self.x, self.y, split_position, self.height, self.level+1)
    self.right_child = Leaf(self.x + split_position, self.y, self.width - split_position, self.height, self.level+1)
  else
    if self.height - self.min_dimension < self.min_dimension then return false end

    -- Round down to tilesize
    local rand_position = random(self.split_low, self.split_high) * self.height
    local split_position = math.floor(rand_position - rand_position % self.tile_size)

    self.left_child = Leaf(self.x, self.y, self.width, split_position, self.level+1)
    self.right_child = Leaf(self.x, self.y + split_position, self.width, self.height - split_position, self.level+1)
  end

  self.left_child:split(max_level)
  self.right_child:split(max_level)

  return true
end

function Leaf:hasChildren()
  return self.left_child or self.right_child
end

function Leaf:hasGrandChildren()
  return (self.left_child and (self.left_child.left_child or self.left_child.right_child))
      or (self.right_child and (self.right_child.left_child or self.right_child.right_child))
end

function Leaf:createRooms()
  if self.left_child or self.right_child then
    if self.left_child then self.left_child:createRooms() end
    if self.right_child then self.right_child:createRooms() end
  else
    local rand_width = random(self.min_dimension, self.width - self.width % self.tile_size)
    local rand_height = random(self.min_dimension, self.height - self.height % self.tile_size)

    local room_width = math.floor(rand_width - rand_width % self.tile_size)
    local room_height = math.floor(rand_height - rand_height % self.tile_size)

    local offset_x = random(0, self.width - room_width)
    local offset_y = random(0, self.height - room_height)

    local room_x = math.floor((self.x + offset_x) - (self.x + offset_x) % self.tile_size)
    local room_y = math.floor((self.y + offset_y) - (self.y + offset_y) % self.tile_size)

    self.room = Room(room_x, room_y, room_width, room_height)
  end
end

function Leaf:getRooms()
  if self.room then
    return {self.room}
  end

  local rooms = {}

  if self.left_child then
    rooms = fn.append(rooms, self.left_child:getRooms())
  end

  if self.right_child then
    rooms = fn.append(rooms, self.right_child:getRooms())
  end

  return rooms
end

function Leaf:createCorridors()
  if self.left_child and self.right_child then
    if not self.left_child.room then self.left_child:createCorridors() end
    if not self.right_child.room then self.right_child:createCorridors() end

    local closest = self:findClosestWall()
    print('Closest for', self.x, self.y)
    print(inspect(closest.wall))
    print(inspect(closest.closest.wall))

    -- Next find out which potential corridors to use
    print('Best corridor is')
    self.path = closest.wall:findBestPathBetween(closest.closest.wall)
    self.closest = closest
  end
end

function Leaf:getRoomCorners()
  return {
    { x = self.room.x, y = self.room.y },
    { x = self.room.x + self.room.width, y = self.room.y },
    { x = self.room.x, y = self.room.y + self.room.height },
    { x = self.room.x + self.room.width, y = self.room.y + self.room.height },
  }
end

function Leaf:findRoomClosestToLeaf(leaf)
  local rooms = self:getRooms()

  return fn(rooms)
    :sortBy(function(room)
      return distance(
        room.x + room.width/2,
        room.y + room.height/2,
        leaf.x + leaf.width/2,
        leaf.y + leaf.height/2
      )
    end)
    :pop()
    :value()
end

function Leaf:findClosestWall()
  if not self.left_child or not self.right_child then return nil end

  -- Begin by finding rooms closest to each each leaf
  local left_room = self.right_child:findRoomClosestToLeaf(self.left_child)
  local left_room_walls = left_room:getWalls()
  local right_room = self.left_child:findRoomClosestToLeaf(self.right_child)
  local right_room_walls = right_room:getWalls()

  return fn(left_room_walls)
    :map(function(_k1, left_wall)
      return {
        wall = left_wall,
        x1 = left_wall.center.x,
        y1 = left_wall.center.y,
        closest = fn(right_room_walls)
          :map(function(_k2, right_wall)
            return {
              wall = right_wall,
              x2 = right_wall.center.x,
              y2 = right_wall.center.y,
              distance = distance(left_wall.center.x, left_wall.center.y, right_wall.center.x, right_wall.center.y)
            }
          end)
          :sort(function(a, b)
            return a.distance < b.distance
          end)
          :pop()
          :value()
      }
    end)
    :sort(function(a, b)
      return a.closest.distance < b.closest.distance
    end)
    :pop()
    :value()
end

function Wall:findBestPathBetween(wall)
  if not self.potential_corridors or not wall.potential_corridors then return nil end

  local straight_path = self:findStraightPath(wall)
  if straight_path then return straight_path end

  if self.horizontal == wall.horizontal then
    local Z_shape_path = self:findZPath(wall)
    if Z_shape_path then return Z_shape_path end
  else
    local L_shape_path = self:findLPath(wall)
    if L_shape_path then return L_shape_path end
  end
end

function Wall:findStraightPath(wall)
  return fn(self.potential_corridors)
  :map(function(_key, corridor)
    return {
      start_pos = corridor,
      end_pos = fn(wall.potential_corridors)
        :filter(function(_k, corr)
          return corr.x == corridor.x or corr.y == corridor.y
        end)
        :value()
    }
  end)
  :filter(function(_key, corridor)
    return not fn.isEmpty(corridor.end_pos)
  end)
  :map(function(_key, corridor)
    return {
      corridors = {
        {
          start_pos = corridor.start_pos,
          end_pos = fn.pop(corridor.end_pos)
        }
      }
    }
  end)
  :pop()
  :value()
end

function Wall:findLPath(wall)
  local start_corridor = fn(self.potential_corridors):sample():value()
  local end_corridor = fn(wall.potential_corridors):sample():value()

  if self.horizontal then
    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = start_corridor.x,
            y = end_corridor.y
          }
        },
        {
          start_pos = {
            x = start_corridor.x,
            y = end_corridor.y
          },
          end_pos = end_corridor
        }
      }
    }
  else
    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = end_corridor.x,
            y = start_corridor.y
          }
        },
        {
          start_pos = {
            x = end_corridor.x,
            y = start_corridor.y
          },
          end_pos = end_corridor
        }
      }
    }
  end
end

function Wall:findZPath(wall)
  local start_corridor = fn(self.potential_corridors):sample():value()
  local end_corridor = fn(wall.potential_corridors):sample():value()

  if self.horizontal then
    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = start_corridor.x,
            y = (start_corridor.y + end_corridor.y) / 2
          }
        },
        {
          start_pos = {
            x = start_corridor.x,
            y = (start_corridor.y + end_corridor.y) / 2
          },
          end_pos = {
            x = end_corridor.x,
            y = (start_corridor.y + end_corridor.y) / 2
          }
        },
        {
          start_pos = {
            x = end_corridor.x,
            y = (start_corridor.y + end_corridor.y) / 2
          },
          end_pos = end_corridor
        }
      }
    }
  else
    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = (start_corridor.x + end_corridor.x) / 2,
            y = start_corridor.y
          }
        },
        {
          start_pos = {
            x = (start_corridor.x + end_corridor.x) / 2,
            y = start_corridor.y
          },
          end_pos = {
            x = (start_corridor.x + end_corridor.x) / 2,
            y = end_corridor.y
          }
        },
        {
          start_pos = {
            x = (end_corridor.x + start_corridor.x) / 2,
            y = end_corridor.y
          },
          end_pos = end_corridor
        }
      }
    }
  end
end

function Leaf:draw()
  love.graphics.setColor(default_color)

  -- love.graphics.setLineWidth(3)
  -- love.graphics.rectangle('line',
  --   self.x,
  --   self.y,
  --   self.width,
  --   self.height
  -- )

  if self.room then self.room:draw() end

  -- if self.closest then
  --   love.graphics.setColor(hp_color)
  --   love.graphics.setLineWidth(3)
  --   love.graphics.line(self.closest.x1, self.closest.y1, self.closest.closest.x2, self.closest.closest.y2)
  -- end

  if self.path then
    love.graphics.setColor(255, 0, 255)
    love.graphics.setLineWidth(3)
    for _key, corridor in pairs(self.path.corridors) do
      love.graphics.line(corridor.start_pos.x, corridor.start_pos.y, corridor.end_pos.x, corridor.end_pos.y)
    end
  end

  if self.left_child then self.left_child:draw() end
  if self.right_child then self.right_child:draw() end
end

MapGenerator = Object:extend()

function MapGenerator:new(game)
  self.max_width = gw
  self.max_height = gh
  self.max_level = 4

  self.root_leaf = nil
  self.leafs = {}
end

function MapGenerator:generate()
  self.root_leaf = Leaf(0, 0, self.max_width, self.max_height)
  table.insert(self.leafs, self.root_leaf)

  self.root_leaf:split(self.max_level)
  self.root_leaf:createRooms()
  self.root_leaf:createCorridors()

  -- for level = self.max_level, 0, -1 do
  --   for _, leaf in pairs(self:getLeafsByLevel(level)) do
  --     leaf:createCorridors()
  --   end
  -- end
end

function MapGenerator:draw()
  love.graphics.setColor(64, 64, 64)
  love.graphics.setLineWidth(1)

  for x = 0, gw, 16 do
    love.graphics.line(x, 0, x, gh)
  end

  for y = 0, gh, 16 do
    love.graphics.line(0, y, gw, y)
  end

  self.root_leaf:draw(default_color)
end

function MapGenerator:getLeafsByLevel(level, leaf)
  if not leaf then leaf = self.root_leaf end

  if leaf.level == level then return {leaf} end

  local leafs = {}

  if leaf.left_child then
    leafs = fn.append(leafs, self:getLeafsByLevel(level, leaf.left_child))
  end

  if leaf.right_child then
    leafs = fn.append(leafs, self:getLeafsByLevel(level, leaf.right_child))
  end

  return leafs
end
