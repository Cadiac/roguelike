Circle = GameObject:extend()

function Circle:new(area, x, y, radius)
  Circle.super.new(self, area, x, y, opts)

  self.x, self.y, self.radius = x, y, radius
  self.creation_time = love.timer.getTime()

  self.timer:tween(2, self, {radius = 50}, 'in-out-cubic', function()
    self.timer:tween(2, self, {radius = 0}, 'in-out-cubic', function()
      self.dead = true
    end)
  end)
end

function Circle:update(dt)
  Circle.super.update(self, dt)
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end
