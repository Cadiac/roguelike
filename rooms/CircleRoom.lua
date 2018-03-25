local CircleRoom = Object:extend()

function CircleRoom:new()
  print('Initialized CircleRoom')
  self.area = Area()
  self.timer = Timer()
  self.timer:every(0.25, function()
    self.area:addGameObject('Circle', random(0, 480), random(0, 270), 0)
  end)
end

function CircleRoom:update(dt)
  if input:pressed('expand') then
    self.timer:tween('transform', 1, self.circle, {radius = 96}, 'in-out-linear')
  end
  if input:pressed('shrink') then
    self.timer:tween('transform', 1, self.circle, {radius = 24}, 'in-out-linear')
  end

  self.area:update(dt)
  self.timer:update(dt)
end

function CircleRoom:draw()
  self.area:draw()
end

return CircleRoom
