GameMap = Object:extend()

function GameMap:new(game)
  self.depth = 10
  self.game = game
  self.tile_size = 16
  self.map = sti(
    'resources/sprites/dungeon.lua',
    nil,
    gw/4 - self.tile_size/2,
    gh/4 - self.tile_size/2
  )
end

function GameMap:update(dt)
  self.map:update(dt)
end

function GameMap:draw()
  self.map:draw(-camera.x / sx, -camera.y / sy, sx, sy)
end

function GameMap:getObjects()
  return self.map.objects
end
