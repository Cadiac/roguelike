local Circle = Object:extend()

local expansion_rate = 500
local max_radius = 300

function Circle:new(x, y, radius)
  self.x, self.y, self.radius = x, y, radius
  self.creation_time = love.timer.getTime()
end

function Circle:update(dt)
  self.radius = (self.radius + (dt * expansion_rate)) % max_radius
end

function Circle:draw()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end

return Circle
