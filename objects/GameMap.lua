GameMap = Object:extend()

function GameMap:new(game, file_name)
  self.depth = 10
  self.game = game
  self.file_name = file_name or 'resources/sprites/dungeon.lua'
  self.tile_size = 16
  self.map = sti.new(self.file_name, nil, -self.tile_size, -self.tile_size)

  for k, object in pairs(self.map.objects) do
    if object.name == 'player' then
      self.game:spawnPlayer(object.x, object.y)
    elseif object.name == 'wall' then
      if object.width == 0 or object.height == 0 then
        self:spawn_thin_wall(object.x, object.y, object.width, object.height)
      else
        self:spawn_wall(object.x, object.y, object.width, object.height)
      end
    elseif object.name == 'destructible' then
      self:spawn_destructible(object.x, object.y, object.width, object.height)
    elseif object.name == 'chest' then
      self:spawn_destructible(object.x, object.y, object.width, object.height)
    else
      print('Unknown object ' .. object.name .. ' at map ' .. file_name)
    end
  end

  self.map:removeLayer("Spawns")
  self.map:removeLayer("Game objects")
  self.map:removeLayer("Walls")
end

function GameMap:update(dt)
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

function GameMap:spawn_thin_wall(x, y, width, height)
  local wall = self.game.area.world:newLineCollider(
    x - self.map.tilewidth,
    y - self.map.tileheight,
    (x + width) - self.map.tilewidth,
    (y + height) - self.map.tileheight
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')


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

  return wall
end

function GameMap:spawn_wall(x, y, width, height)
  local wall = self.game.area.world:newRectangleCollider(
    x - self.map.tilewidth,
    y - self.map.tileheight,
    width,
    height
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')

  self.game.area.light_world:newRectangle(
    x - self.map.tilewidth + width/2,
    y - self.map.tileheight + height/2,
    width,
    height
  )

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
