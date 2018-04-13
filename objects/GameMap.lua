GameMap = Object:extend()

function GameMap:new(game, file_name)
  self.depth = 10
  self.game = game
  self.tile_size = 16
  self.file_name = file_name or 'resources/sprites/dungeon.lua'
  self.map = sti(
    self.file_name,
    nil,
    (gw/2)/sx - self.tile_size/sx,
    (gh/2)/sy - self.tile_size/sy
  )

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
  self.map:draw(-camera.x / sx, -camera.y / sy, sx, sy)
end

function GameMap:spawn_thin_wall(x, y, width, height)
  local wall = self.game.area.world:newLineCollider(
    x * sx - self.tile_size,
    y * sy - self.tile_size,
    (x + width) * sx - self.tile_size,
    (y + height) * sy - self.tile_size
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')

  return wall
end

function GameMap:spawn_wall(x, y, width, height)
  local wall = self.game.area.world:newRectangleCollider(
    x * sx - self.tile_size,
    y * sy - self.tile_size,
    width * sx,
    height * sy
  )
  wall:setCollisionClass('Solid')
  wall:setType('static')

  return wall
end

function GameMap:spawn_destructible(x, y, width, height)
  local destructible = self.game.area:addGameObject(
    'DestructibleObject',
    x * sx - self.tile_size,
    y * sy - self.tile_size,
    {
      width = width,
      height = height,
      color = {0, 0, 0, 0},
      hp = 3,
    }
  )
end
