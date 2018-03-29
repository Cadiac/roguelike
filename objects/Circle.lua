Circle = GameObject:extend()

function Circle:new(area, x, y)
  Circle.super.new(self, area, x, y, opts)

  self.x, self.y = x, y
  self.radius = random(10, 50)
  self.creation_time = love.timer.getTime()

  local function resize_loop()
    self.timer:tween(2, self, {radius = 50}, 'in-out-cubic', function()
      self.timer:tween(2, self, {radius = 0}, 'in-out-cubic', function()
        resize_loop()
      end)
    end)
  end

  resize_loop()
end

function Circle:destroy()
  Circle.super.destroy(self)
end

function Circle:update(dt)
  Circle.super.update(self, dt)
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end
