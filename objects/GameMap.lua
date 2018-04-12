GameMap = Object:extend()

function GameMap:new(game)
  self.depth = 10
  self.game = game
  -- self.map = sti('resources/sprites/dungeon.lua', nil, 113, 60)
  self.map = sti('resources/sprites/dungeon.lua')
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
