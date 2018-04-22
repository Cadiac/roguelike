MapGenerator = Object:extend()

function MapGenerator:new(game)
  self.max_width = 1000
  self.max_height = 1000

  self.root_leaf = nil
  self.leafs = {}
end

function MapGenerator:generate()
  self.root_leaf = Leaf(0, 0, gw, gh)
  table.insert(self.leafs, self.root_leaf)

  self.root_leaf:split()
  self.root_leaf:createRooms()
  self.root_leaf:createCorridors()
end

function MapGenerator:draw()
  self.root_leaf:draw(default_color)
end

Leaf = Object:extend()

function Leaf:new(x, y, width, height, level)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.min_dimension = 50
  self.max_dimension = 300

  self.level = level or 0

  self.room = nil
  self.left_child = nil
  self.right_child = nil
  self.corridors = {}
end

function Leaf:split()
  -- Has the leaf already been split
  if self.left_child or self.right_child then return false end
  if self.level > 4 then return false end

  local split_vertical = love.math.random() > 0.5

  if split_vertical then
    -- If the area is too small stop splitting
    if self.width - self.min_dimension < self.min_dimension then return false end

    local split_position = random(self.min_dimension, self.width - self.min_dimension)

    self.left_child = Leaf(self.x, self.y, split_position, self.height, self.level+1)
    self.right_child = Leaf(self.x + split_position, self.y, self.width - split_position, self.height, self.level+1)
  else
    if self.height - self.min_dimension < self.min_dimension then return false end

    local split_position = random(self.min_dimension, self.height - self.min_dimension)

    self.left_child = Leaf(self.x, self.y, self.width, split_position, self.level+1)
    self.right_child = Leaf(self.x, self.y + split_position, self.width, self.height - split_position, self.level+1)
  end

  self.left_child:split()
  self.right_child:split()

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
    local room_width = random(self.width/2, self.width)
    local room_height = random(self.height/2, self.height)

    self.room = {
      x = self.x + random(0, self.width - room_width),
      y = self.y + random(0, self.height - room_height),
      width = room_width,
      height = room_height
    }
  end
end

function Leaf:createCorridors()
  if self.left_child and self.right_child and not self:hasGrandChildren() then
    print('Creating corridor between ('
          .. self.left_child.x  .. ' , ' .. self.left_child.y
          .. ') and ('
          .. self.right_child.x .. ' , ' .. self.right_child.y .. ').')

    -- Vertical split
    if math.floor(self.left_child.x) == math.floor(self.right_child.x) then
      local min_x = math.max(self.left_child.room.x, self.right_child.room.x)
      local max_x = math.min(
        self.left_child.room.x + self.left_child.room.width,
        self.right_child.room.x + self.right_child.room.width
      )

      local corridor_x = random(min_x, max_x)
      local corridor_min_y = math.min(self.left_child.room.y, self.right_child.room.y)
      local corridor_max_y = math.max(self.left_child.room.y, self.right_child.room.y)

      table.insert(self.corridors, {
        x1 = corridor_x,
        y1 = corridor_min_y,
        x2 = corridor_x,
        y2 = corridor_max_y
      })
    -- Horizontal split
    else
      local min_y = math.max(self.left_child.room.y, self.right_child.room.y)
      local max_y = math.min(
        self.left_child.room.y + self.left_child.room.height,
        self.right_child.room.y + self.right_child.room.height
      )

      local corridor_y = random(min_y, max_y)
      local corridor_min_x = math.min(self.left_child.room.x, self.right_child.room.x)
      local corridor_max_x = math.max(self.left_child.room.x, self.right_child.room.x)

      table.insert(self.corridors, {
        x1 = corridor_min_x,
        y1 = corridor_y,
        x2 = corridor_max_x,
        y2 = corridor_y
      })
    end
  else
    if self.left_child then self.left_child:createCorridors() end
    if self.right_child then self.right_child:createCorridors() end
  end
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

  for _key, corridor in ipairs(self.corridors) do
    love.graphics.setColor(hp_color)
    love.graphics.setLineWidth(3)
    love.graphics.line(corridor.x1, corridor.y1, corridor.x2, corridor.y2)

    -- Door
    love.graphics.circle('fill', corridor.x1, corridor.y1, 10)
  end

  if self.left_child then self.left_child:draw() end
  if self.right_child then self.right_child:draw() end
end
