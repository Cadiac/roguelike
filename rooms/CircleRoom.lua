local Circle = require 'objects/Circle'

local CircleRoom = Object:extend()

function CircleRoom:new()
  print('Initialized CircleRoom')
  self.circle = Circle(200, 150, 96)
end

function CircleRoom:update(dt)
  if input:pressed('expand') then
    timer:tween('transform', 1, self.circle, {radius = 96}, 'in-out-linear')
  end
  if input:pressed('shrink') then
    timer:tween('transform', 1, self.circle, {radius = 24}, 'in-out-linear')
  end

  self.circle:update(dt)
end

function CircleRoom:draw()
  self.circle:draw()
end

return CircleRoom
