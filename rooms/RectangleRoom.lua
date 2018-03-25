local RectangleRoom = Object:extend()

function RectangleRoom:new()
  print('Initialized RectangleRoom')
end

function RectangleRoom:update()
end

function RectangleRoom:draw()
  love.graphics.rectangle('fill', 300 - 100/2, 200 - 50/2, 100, 50)
end

return RectangleRoom
