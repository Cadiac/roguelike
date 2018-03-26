local RectangleRoom = Object:extend()

function RectangleRoom:new()
  print('Initialized RectangleRoom')
  self.area = Area()
  self.timer = Timer()
  for i = 1, 10 do
    self.area:addGameObject('Rectangle', random(0, gw), random(0, gh))
  end

  input:bind('d', 'removeRectangle')
end

function RectangleRoom:update()
  self.area:update(dt)
  self.timer:update(dt)

  if input:pressed('removeRectangle') then
    table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
    if #self.area.game_objects == 0 then
      for i = 1, 10 do
        self.area:addGameObject('Rectangle', random(0, gw), random(0, gh))
      end
    end
  end
end

function RectangleRoom:draw()
  self.area:draw()
end

return RectangleRoom
