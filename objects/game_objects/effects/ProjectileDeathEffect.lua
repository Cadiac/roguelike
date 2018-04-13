ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
  ProjectileDeathEffect.super.new(self, area, x, y, opts)
  self.depth = 50

  self.s = opts.s or 2.5
  self.current_color = opts.color or default_color
  self.death_color = {255, 255, 255, 128}
  self.timer:after(0.1, function()
    self.current_color = self.death_color
    self.timer:after(0.15, function() self.dead = true end)
  end)
end

function ProjectileDeathEffect:destroy()
  ProjectileDeathEffect.super.destroy(self)
end

function ProjectileDeathEffect:update(dt)
  ProjectileDeathEffect.super.update(self, dt)
end

function ProjectileDeathEffect:draw()
  love.graphics.setColor(self.current_color)
  love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end
