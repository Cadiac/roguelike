local Circle = Object:extend()

function Circle:new(x, y, radius)
  self.x, self.y, self.radius = x, y, radius
  self.creation_time = love.timer.getTime()
  timer:after(2, function()
    timer:tween(6, self, {radius = 96}, 'in-out-cubic', function()
        timer:tween(6, self, {radius = 24}, 'in-out-cubic')
    end)
end)
end

function Circle:update(dt)
  -- self.radius = (self.radius + (dt * self.expansion_rate)) % self.max_radius
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Circle
