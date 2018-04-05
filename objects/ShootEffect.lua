ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y, opts)
  ShootEffect.super.new(self, area, x, y, opts)
  self.depth = 75
  self.w = 8

  self.color = opts.color or {255, 255, 255}

  self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:update(dt)
  ShootEffect.super.update(self, dt)
  if self.player then
    self.x, self.y = coordsInDirection(self.player.x, self.player.y, self.distance, self.player.r)
  end
end

function ShootEffect:destroy()
  ShootEffect.super.destroy(self)
end

function ShootEffect:draw()
  love.graphics.setColor(self.color)
  pushRotate(self.x, self.y, self.player.r + math.pi/4)
  love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
  love.graphics.pop()
end
