local RectangleRoom = Object:extend()

function RectangleRoom:new()
  self.generator = MapGenerator()
  self.generator:generate()
end

function RectangleRoom:destroy()

end

function RectangleRoom:update()

end

function RectangleRoom:draw()
  self.generator:draw()
end

return RectangleRoom
