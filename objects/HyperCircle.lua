local HyperCircle = Circle:extend()

function HyperCircle:new(x, y, radius, line_width, padding)
  HyperCircle.super.new(self, x, y, radius)
  self.line_width = line_width
  self.padding = padding
  self.outer_radius = self.padding + self.radius
end

function HyperCircle:update(dt)
  HyperCircle.super.update(self, dt)
  self.outer_radius = (self.radius + self.padding + (dt * self.expansion_rate)) % (self.max_radius + self.padding)
end

function HyperCircle:draw()
  HyperCircle.super.draw(self)
  love.graphics.setLineWidth(self.line_width)
  love.graphics.circle('line', self.x, self.y, self.outer_radius)
  love.graphics.setLineWidth(1)
end

return HyperCircle
