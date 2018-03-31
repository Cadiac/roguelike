Player = GameObject:extend()

function Player:new(area, x, y, opts)
  Player.super.new(self, area, x, y, opts)

  self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)

  self.r = -math.pi/2
  self.vx = 0
  self.vy = 0

  self.attack_speed = 10

  self.run_a = 100
  self.stop_a = 1000

  self.timer:every(5, function() self:tick() end)
end

function Player:destroy()
  Player.super.destroy(self)
end

function Player:update(dt)
  Player.super.update(self, dt)

  self.vx = 0
  self.vy = 0

  local left = input:down('left')
  local right = input:down('right')
  local up = input:down('up')
  local down = input:down('down')

  if left then self.vx = -100 end
  if right then self.vx = 100 end
  if up then self.vy = -100 end
  if down then self.vy = 100 end

  if (left and right) then self.vx = 0
  elseif (up and down) then self.vy = 0
  elseif (left or right) and (up or down) then
    self.vx = 0.7071 * self.vx
    self.vy = 0.7071 * self.vy
  end

  self.collider:setLinearVelocity(self.vx, self.vy)

  if input:down('shoot', 1.0/self.attack_speed) then self:shoot() end

  if self.collider:enter('Solid') then self:die() end
end

function Player:draw()
  love.graphics.setColor(224, 0, 0, 255)
  love.graphics.circle('line', self.x, self.y, self.w)

  -- Mouse coordinates are scaled
  self.r = angleTowardsCoords(self.x, self.y, love.mouse.getX() / sx, love.mouse.getY() / sy)

  love.graphics.line(self.x, self.y, coordsInDirection(self.x, self.y, 2*self.w, self.r))
  love.graphics.setColor(255, 255, 255, 255)
end

function Player:shoot()
  local distance = 1.5*self.w

  local particle_x, particle_y = coordsInDirection(self.x, self.y, distance, self.r)

  self.area:addGameObject('ShootEffect', particle_x, particle_y, {player = self, distance = distance})
  self.area:addGameObject('Projectile', particle_x, particle_y, {r = self.r})
end

function Player:tick()
  self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:die()
  self.dead = true
  flash(0.05)
  slow(0.15, 1)
  camera:shake(3, 30, 0.4)

  for i = 1, love.math.random(8, 12) do
    self.area:addGameObject('ExplodeParticle', self.x, self.y)
  end
end
