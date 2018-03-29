local PolygonRoom = Object:extend()

function PolygonRoom:new()
  self.area = Area()
end

function PolygonRoom:destroy()
  self.area:destroy()
  self.area = nil
end

function PolygonRoom:update()
end

function PolygonRoom:draw()
  love.graphics.polygon('fill', 300, 200 - 50, 300 + 50, 200, 300, 200 + 50, 300 - 50, 200)
end

return PolygonRoom
