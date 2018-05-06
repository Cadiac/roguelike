local vector = require 'vector'

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

  local x_start = math.floor(self.start_corner.x + 1.5*tile_size)
  local x_end = math.floor(self.end_corner.x - 1.5*tile_size)

  for x = x_start, x_end, tile_size do
    table.insert(potential_corridors, { x = x, y = self.start_corner.y })
    table.insert(potential_corridors, { x = x, y = self.end_corner.y })
  end

  local y_start = math.floor(self.start_corner.y + 1.5*tile_size)
  local y_end = math.floor(self.end_corner.y - 1.5*tile_size)

  for y = y_start, y_end, tile_size do
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

  self.min_dimension = 96
  self.max_dimension = 320
  self.split_low = 0.40
  self.split_high = 0.60

  self.level = level or 0

  self.room = nil
  self.left_child = nil
  self.right_child = nil
  self.corridors = {}
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
    local split_position = math.floor(rand_position - rand_position % tile_size)

    self.left_child = Leaf(self.x, self.y, split_position, self.height, self.level+1)
    self.right_child = Leaf(self.x + split_position, self.y, self.width - split_position, self.height, self.level+1)
  else
    if self.height - self.min_dimension < self.min_dimension then return false end

    -- Round down to tilesize
    local rand_position = random(self.split_low, self.split_high) * self.height
    local split_position = math.floor(rand_position - rand_position % tile_size)

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
    local rand_width = random(self.min_dimension - tile_size*2, self.width - tile_size*2)
    local rand_height = random(self.min_dimension - tile_size*2, self.height - tile_size*2)

    local room_width = math.floor(rand_width - rand_width % tile_size)
    local room_height = math.floor(rand_height - rand_height % tile_size)

    local offset_x = random(tile_size, self.width - room_width - tile_size)
    local offset_y = random(tile_size, self.height - room_height - tile_size)

    local room_x = math.floor((self.x + offset_x) - (self.x + offset_x) % tile_size)
    local room_y = math.floor((self.y + offset_y) - (self.y + offset_y) % tile_size)

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

function Wall:findClosestCorridors(wall)
  return fn.reduce(self.potential_corridors, function(state, start_corridor)
    local closest = fn.reduce(wall.potential_corridors, function(acc, end_corridor)
      local min_distance = math.floor(distance(start_corridor.x, start_corridor.y, end_corridor.x, end_corridor.y))

      if not (acc and acc.distance) or acc.distance > min_distance then
        return {
          end_corridor = end_corridor,
          distance = min_distance
        }
      else
        return acc
      end
    end)

    if not (state and state.distance) or state.distance > closest.distance then
      return {
        start_corridor = start_corridor,
        end_corridor = closest.end_corridor,
        distance = closest.distance
      }
    else
      return state
    end
  end)
end

function Wall:findLPath(wall)
  local corridors = self:findClosestCorridors(wall)
  local start_corridor = corridors.start_corridor
  local end_corridor = corridors.end_corridor

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
  local corridors = self:findClosestCorridors(wall)
  local start_corridor = corridors.start_corridor
  local end_corridor = corridors.end_corridor

  if self.horizontal then
    local pivot_position = (start_corridor.y + end_corridor.y) / 2

    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = start_corridor.x,
            y = pivot_position
          }
        },
        {
          start_pos = {
            x = start_corridor.x,
            y = pivot_position
          },
          end_pos = {
            x = end_corridor.x,
            y = pivot_position
          }
        },
        {
          start_pos = {
            x = end_corridor.x,
            y = pivot_position
          },
          end_pos = end_corridor
        }
      }
    }
  else
    local pivot_position = (start_corridor.x + end_corridor.x) / 2

    return {
      corridors = {
        {
          start_pos = start_corridor,
          end_pos = {
            x = pivot_position,
            y = start_corridor.y
          }
        },
        {
          start_pos = {
            x = pivot_position,
            y = start_corridor.y
          },
          end_pos = {
            x = pivot_position,
            y = end_corridor.y
          }
        },
        {
          start_pos = {
            x = pivot_position,
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

local EMPTY_TILE = 0
local WALL_TILE = 1
local ROOM_TILE = 2
local PATH_TILE = 3

function MapGenerator:new(game)
  self.max_width = gw
  self.max_height = gh
  self.max_level = 4

  self.root_leaf = nil
  self.leafs = {}
  self.rooms = {}
  self.map_grid = {}

  for y = 0, gh, tile_size do
    self.map_grid[y] = {}
    for x = 0, gw, tile_size do
      self.map_grid[y][x] = EMPTY_TILE
    end
  end
end

function MapGenerator:generate()
  self.leafs = {}
  self.root_leaf = Leaf(0, 0, self.max_width, self.max_height)
  table.insert(self.leafs, self.root_leaf)

  self.root_leaf:split(self.max_level)
  self.root_leaf:createRooms()
  self.rooms = self.root_leaf:getRooms()

  for _key, room in pairs(self.rooms) do
    for y = room.y, room.y + room.height, tile_size do
      for x = room.x, room.x + room.width, tile_size do
        self.map_grid[y][x] = ROOM_TILE
      end
    end
  end

  self.root_leaf:createCorridors()

  self.corridors = {}

  for _key, leaf in pairs(self.leafs) do
    if leaf.path and leaf.path.corridors then
      self.corridors = fn.append(self.corridors, leaf.path.corridors)
    end
  end

  for _key, corridor in pairs(self.corridors) do
    for y = corridor.start_pos.y, corridor.end_pos.y, tile_size do
      for x = corridor.start_pos.x, corridor.end_pos.x, tile_size do
        self.map_grid[y][x] = PATH_TILE
      end
    end
  end
end

function MapGenerator:draw()
  love.graphics.setColor(64, 64, 64)
  love.graphics.setLineWidth(1)

  for x = tile_size, gw, tile_size do
    love.graphics.line(x, 0, x, gh)
  end

  for y = tile_size, gh, tile_size do
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

function MapGenerator:hasOverlapingPaths()
  local corridors_hit = fn.any(self.corridors, function(corridor)
    local corridor_hit = fn.any(self.rooms, function(room)
      local room_hit = fn.any(room:getWalls(), function(wall)
        -- print('Checking intersection')
        -- print(inspect(corridor))
        -- print(corridor.start_pos.x, corridor.start_pos.y)
        -- print(corridor.end_pos.x, corridor.end_pos.y)
        -- print(wall.start_corner.x, wall.start_corner.y)
        -- print(wall.end_corner.x, wall.end_corner.y)

        local wall_hit = vector.findIntersect(
          corridor.start_pos.x, corridor.start_pos.y,
          corridor.end_pos.x, corridor.end_pos.y,
          wall.start_corner.x, wall.start_corner.y,
          wall.end_corner.x, wall.end_corner.y
        )
        print('wall was', wall_hit)

        return wall_hit
      end)

      print('Room', room.x, room.y, room.width, room.height)
      print('Room was', room_hit)
      return room_hit
    end)

    print('Corridor was', corridor_hit)
    return corridor_hit
  end)

  print('Corridors were overlapping', corridors_hit)

  return corridors_hit
end
