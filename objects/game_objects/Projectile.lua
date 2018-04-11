Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
  Projectile.super.new(self, area, x, y, opts)
  self.depth = 50

  self.s = (opts.s or 1) * gscale
  self.v = opts.v or 200

  self.start_x = x
  self.start_y = y
  self.max_range = opts.max_range or (2 * gw)

  self.damage = opts.damage or 0
  self.caster = opts.caster
  self.color = opts.color or default_color

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
  self.collider:setObject(self)
  self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
  self.collider:setCollisionClass('Projectile')
end

function Projectile:destroy()
  Projectile.super.destroy(self)
end

function Projectile:update(dt)
  Projectile.super.update(self, dt)

  if self.max_range and distance(self.x, self.y, self.start_x, self.start_y) > self.max_range then self:die() end

  if self.collider:enter('Solid') then self:die() end
end

function Projectile:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle('line', self.x, self.y, self.s)
end

function Projectile:die()
  self.dead = true
  self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {w = 3*self.s, color = self.color})
end
