local PolygonRoom = Object:extend()

function PolygonRoom:new()
  print('Initialized PolygonRoom')
end

function PolygonRoom:update()
end

function PolygonRoom:draw()
  love.graphics.polygon('fill', 300, 200 - 50, 300 + 50, 200, 300, 200 + 50, 300 - 50, 200)
end

return PolygonRoom
