GameMap = Object:extend()

function GameMap:new(x, y, opts)
  self.depth = 10
end

function GameMap:update(dt)
end

function GameMap:draw()
  love.graphics.draw(tilesetBatch, 0, 0)
end

