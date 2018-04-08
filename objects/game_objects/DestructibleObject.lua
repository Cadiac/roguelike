DestructibleObject = GameObject:extend()

function DestructibleObject:new(area, x, y, opts)
  DestructibleObject.super.new(self, area, x, y, opts)
  self.depth = 50

  self.age = 0
  self.max_age = opts.max_age
  self.width = opts.width or 50
  self.height = opts.height or 50
  self.r = opts.r or 0
  self.hp = opts.hp or 1
  self.color = opts.color or default_color

  self.collider = self.area.world:newRectangleCollider(x, y, self.width, self.height)
  self.collider:setCollisionClass('Solid')
  self.collider:setType('static')
  self.collider:setAngle(self.r)
  self.x, self.y = self.collider:getPosition()
end

function DestructibleObject:destroy()
  DestructibleObject.super.destroy(self)
end

function DestructibleObject:update(dt)
  DestructibleObject.super.update(self, dt)

  if self.collider:enter('Projectile') then self.hp = self.hp - 1 end
  if self.hp <= 0 then self:die() end
  if self.max_age then
    self.age = self.age + dt
    if self.age >= self.max_age then self:die() end
  end
end

function DestructibleObject:draw()
  love.graphics.setColor(self.color)
  -- NOTE: Because we're defining the collider by center point, but we draw rectangle collider from top left corner.
  -- The middle should be at x + width/2 and y + height/2
  pushRotate(self.x, self.y, self.r)
  love.graphics.rectangle('fill', self.x - self.width/2, self.y - self.height/2, self.width, self.height)
  love.graphics.pop()
end

function DestructibleObject:die()
  self.dead = true
  self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {w = 2*self.width, color = self.color})
end
