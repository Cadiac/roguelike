HealthBar = GameObject:extend()

function HealthBar:new(area, x, y, opts)
  HealthBar.super.new(self, area, x, y, opts)
  self.depth = 80

  -- This will be the center point
  self.x, self.y = x, y
  self.width = 30
  self.height = 3

  self.font = fonts.m5x7_16
  self.parent = opts.parent
end

function HealthBar:destroy()
  HealthBar.super.destroy(self)
end

function HealthBar:update(dt)
  HealthBar.super.update(self, dt)
  self.x, self.y = self.parent.x, self.parent.y
end

function HealthBar:draw()
  -- Background
  love.graphics.setColor(8, 8, 8)
  love.graphics.rectangle('fill',
    self.x - self.width/2,
    self.y - 15,
    self.width,
    self.height
  )
  -- Health indicator
  love.graphics.setColor(hp_color)
  love.graphics.rectangle('fill',
    self.x - self.width/2,
    self.y - 15,
    self.width * (self.parent.hp / self.parent.max_hp),
    self.height
  )
  -- Borders
  love.graphics.setLineWidth(1.5 / camera.scale)
  love.graphics.setColor(default_color)
  love.graphics.rectangle('line',
    self.x - self.width/2,
    self.y - 15,
    self.width,
    self.height
  )
  love.graphics.setLineWidth(1)
end

function HealthBar:die()
  self.dead = true
end
