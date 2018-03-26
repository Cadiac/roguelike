Circle = GameObject:extend()

function Circle:new(area, x, y)
  Circle.super.new(self, area, x, y, opts)

  self.x, self.y = x, y
  self.radius = random(10, 50)
  self.creation_time = love.timer.getTime()

  self.timer:tween(2, self, {radius = 50}, 'in-out-cubic')
end

function Circle:update(dt)
  Circle.super.update(self, dt)
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end
