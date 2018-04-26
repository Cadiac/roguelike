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

    self.room = {
      x = math.floor((self.x + offset_x) - (self.x + offset_x) % self.tile_size),
      y = math.floor((self.y + offset_y) - (self.y + offset_y) % self.tile_size),
      width = room_width,
      height = room_height
    }
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

function Leaf:markPotentialCorridors()
  if self.room then
    for x = self.room.x + self.tile_size, self.room.x + self.room.width - self.tile_size, self.tile_size do
      table.insert(self.potential_corridors.top, { x = x, y = self.room.y })
      table.insert(self.potential_corridors.bottom, { x = x, y = self.room.y + self.room.height })
    end

    for y = self.room.y + self.tile_size, self.room.y + self.room.height - self.tile_size, self.tile_size do
      table.insert(self.potential_corridors.left, { x = self.room.x, y = y })
      table.insert(self.potential_corridors.right, { x = self.room.x + self.room.width, y = y })
    end
  else
    if self.left_child then self.left_child:markPotentialCorridors() end
    if self.right_child then self.right_child:markPotentialCorridors() end
  end
end

function Leaf:createCorridors()
  if self.left_child and self.right_child then
    if self.left_child.room and self.right_child.room then
      local closest = self.left_child:findClosestWall(self.right_child)
      print('Closest for', self.left_child.x, self.left_child.y)
      print(inspect(closest))

      self.closest = closest
      -- Find closest walls



      -- for _key, corridor in pairs(self.right_child.potential_corridors) do
      --   -- Find closest wall, and attempt to find potential corridors from there

      --   local vertical_corridors = fn.where(self.left_child.potential_corridors, { x = corridor.x }) or {}
      --   local horizontal_corridors = fn.where(self.left_child.potential_corridors, { y = corridor.y }) or {}

      --   local matching = fn.append(vertical_corridors, horizontal_corridors)

      --   local c = fn.sample(matching)

      --   if c then
      --     table.insert(self.corridors, {
      --       x1 = corridor.x,
      --       y1 = corridor.y,
      --       x2 = c.x,
      --       y2 = c.y
      --     })
      --   end
      -- end
    else
      self.left_child:createCorridors()
      self.right_child:createCorridors()
    end
  end
end

function Leaf:getRoomPoints()
  return {
    { x = self.room.x, y = self.room.y },
    { x = self.room.x + self.room.width, y = self.room.y },
    { x = self.room.x, y = self.room.y + self.room.height },
    { x = self.room.x + self.room.width, y = self.room.y + self.room.height },
  }
end

function Leaf:findClosestWall(leaf)
  if not self.room or not leaf.room then return nil end

  local first = self:getRoomPoints()
  local second = leaf:getRoomPoints()

  return fn(first)
    :map(function(_k1, corner1)
      return {
        x1 = corner1.x,
        y1 = corner1.y,
        closest = fn(second)
          :map(function(_k2, corner2)
            return {
              x2 = corner2.x,
              y2 = corner2.y,
              distance = distance(corner1.x, corner1.y, corner2.x, corner2.y)
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
    :take(2)
    :value()
end

function Leaf:draw()
  love.graphics.setColor(default_color)
  love.graphics.setLineWidth(3)
  love.graphics.rectangle('line',
    self.x,
    self.y,
    self.width,
    self.height
  )

  if self.room then
    love.graphics.rectangle('fill',
      self.room.x,
      self.room.y,
      self.room.width,
      self.room.height
    )
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.level, self.room.x + self.room.width/2, self.room.y + self.room.height/2)
  end

  -- for _key, corridor in ipairs(self.corridors) do
  --   love.graphics.setColor(hp_color)
  --   love.graphics.setLineWidth(3)
  --   love.graphics.line(corridor.x1, corridor.y1, corridor.x2, corridor.y2)

  --   -- Door
  --   love.graphics.circle('fill', corridor.x1, corridor.y1, 10)
  --   love.graphics.circle('fill', corridor.x2, corridor.y2, 10)
  -- end

  if self.closest then
    love.graphics.setColor(hp_color)
    love.graphics.setLineWidth(3)
    love.graphics.line(self.closest[1].x1, self.closest[1].y1, self.closest[1].closest.x2, self.closest[1].closest.y2)
    love.graphics.line(self.closest[2].x1, self.closest[2].y1, self.closest[2].closest.x2, self.closest[2].closest.y2)
  end

  if self.potential_corridors and self.potential_corridors.top then
    for _key, potential_corridor in pairs(self.potential_corridors.top) do
      love.graphics.setColor({255, 0, 0})
      love.graphics.circle('fill', potential_corridor.x, potential_corridor.y, 4)
    end
  end

  if self.potential_corridors and self.potential_corridors.bottom then
    for _key, potential_corridor in pairs(self.potential_corridors.bottom) do
      love.graphics.setColor({0, 255, 0})
      love.graphics.circle('fill', potential_corridor.x, potential_corridor.y, 4)
    end
  end

  if self.potential_corridors and self.potential_corridors.left then
    for _key, potential_corridor in pairs(self.potential_corridors.left) do
      love.graphics.setColor({0, 0, 255})
      love.graphics.circle('fill', potential_corridor.x, potential_corridor.y, 4)
    end
  end

  if self.potential_corridors and self.potential_corridors.right then
    for _key, potential_corridor in pairs(self.potential_corridors.right) do
      love.graphics.setColor({0, 255, 255})
      love.graphics.circle('fill', potential_corridor.x, potential_corridor.y, 4)
    end
  end

  if self.left_child then self.left_child:draw() end
  if self.right_child then self.right_child:draw() end
end

MapGenerator = Object:extend()

function MapGenerator:new(game)
  self.max_width = gw
  self.max_height = gh
  self.max_level = 3

  self.root_leaf = nil
  self.leafs = {}
end

function MapGenerator:generate()
  self.root_leaf = Leaf(0, 0, self.max_width, self.max_height)
  table.insert(self.leafs, self.root_leaf)

  self.root_leaf:split(self.max_level)
  self.root_leaf:createRooms()
  self.root_leaf:markPotentialCorridors()
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
