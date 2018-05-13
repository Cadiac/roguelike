GameMap = Object:extend()

function GameMap:new(game, coordinator, file_name)
  self.game = game
  self.coordinator = coordinator

  self.timer = Timer()

  self.file_name = file_name or 'resources/sprites/level-1.lua'
  self.tile_size = 16
  self.map = sti.new(self.file_name, nil, -self.tile_size, -self.tile_size)

  for k, object in pairs(self.map.objects) do
    if object.type == 'Player' then
      self.coordinator:spawnPlayer(object.x, object.y)
    elseif object.type == 'Wall' then
      if object.width == 0 or object.height == 0 then
        self:spawn_thin_wall(object.x, object.y, object.width, object.height)
      else
        self:spawn_wall(object.x, object.y, object.width, object.height)
      end
    elseif object.type == 'InvisibleWall' then
      if object.width == 0 or object.height == 0 then
        self:spawn_thin_wall(object.x, object.y, object.width, object.height, true)
      else
        self:spawn_wall(object.x, object.y, object.width, object.height, true)
      end
    elseif object.type == 'Destructible' then
      self:spawn_destructible(object.x, object.y, object.width, object.height)
    elseif object.type == 'Chest' then
      self:spawn_destructible(object.x, object.y, object.width, object.height)
    elseif object.type == 'Light' then
      self:spawn_light(object.x, object.y)
    elseif object.type == 'Room' then
      -- Do nothing
    elseif object.type == 'Door' then
      -- Do nothing
    else
      print('Unknown object ' .. object.name .. ' at map ' .. self.file_name)
    end
  end

  self.map:removeLayer("Spawns")
  self.map:removeLayer("Rooms")
  self.map:removeLayer("Doors")
  self.map:removeLayer("Walls")
end

function GameMap:destroy()
  if self.timer then self.timer:destroy() end
end

function GameMap:update(dt)
  if self.timer then self.timer:update(dt) end
  self.map:update(dt)
end

function GameMap:draw()
  -- self.map:draw(
  --   math.floor(-camera.x + (gw/2) / camera.scale - self.map.tilewidth),
  --   math.floor(-camera.y + (gh/2) / camera.scale - self.map.tileheight),
  --   camera.scale,
  --   camera.scale
  -- )
  self.map:draw()
end

function GameMap:spawn_thin_wall(x, y, width, height, invisible)
  local wall = self.game.area.world:newLineCollider(
    x - self.map.tilewidth,
    y - self.map.tileheight,
    (x + width) - self.map.tilewidth,
    (y + height) - self.map.tileheight
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')


  if not invisible then
    if width == 0 then
      self.game.area.light_world:newRectangle(
        x - self.map.tilewidth + width/2,
        y - self.map.tileheight + height/2,
        1,
        height
      )
    elseif height == 0 then
      self.game.area.light_world:newRectangle(
        x - self.map.tilewidth + width/2,
        y - self.map.tileheight + height/2,
        width,
        1
      )
    end
  end

  return wall
end

function GameMap:spawn_wall(x, y, width, height, invisible)
  local wall = self.game.area.world:newRectangleCollider(
    x - self.map.tilewidth,
    y - self.map.tileheight,
    width,
    height
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')

  if not invisible then
    self.game.area.light_world:newRectangle(
      x - self.map.tilewidth + width/2,
      y - self.map.tileheight + height/2,
      width,
      height
    )
  end

  return wall
end

function GameMap:spawn_destructible(x, y, width, height)
  local destructible = self.game.area:addGameObject(
    'DestructibleObject',
    x - self.map.tilewidth,
    y - self.map.tileheight,
    {
      width = width,
      height = height,
      color = {0, 0, 0, 0},
      hp = 3,
    }
  )

  return destructible
end

function GameMap:spawn_light(x, y)
  local light = self.game.area.light_world:newLight(
    x - self.map.tilewidth,
    y - self.map.tileheight,
    255, 64, 28,
    100
  )

  -- Flicker
  self.timer:every(0.5, function()
    self.timer:tween(
      random(0.2, 0.3),
      light,
      {range = random(95, 110)},
      'linear'
    )
  end)

  return light
end
