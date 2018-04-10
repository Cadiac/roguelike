Player = GameObject:extend()

function Player:new(area, x, y, opts)
  Player.super.new(self, area, x, y, opts)
  self.depth = 100

  self.type = 'player'

  self.x, self.y = x, y
  self.w = 6 * sx

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Player')

  self.r = -math.pi/2
  self.vx = 0
  self.vy = 0
  self.v_max = 100

  self.mana = 50
  self.max_mana = 100
  self.mana_regen = 20

  self.hp = 100
  self.max_hp = 100

  self.equipped_skills = {
    ['skill_slot_1'] = Skill(),
    ['skill_slot_2'] = Icewall(),
    ['skill_slot_3'] = Fireball(),
    ['skill_slot_4'] = PoisonDart()
  }
end

function Player:destroy()
  Player.super.destroy(self)
end

function Player:update(dt)
  Player.super.update(self, dt)

  -- Mouse coordinates are scaled
  local mouse_x, mouse_y = camera:getMousePosition(sx, sy)
  self.r = angleTowardsCoords(self.x, self.y, mouse_x, mouse_y)

  self.mana = math.min(self.mana + self.mana_regen * dt, self.max_mana)

  for keybind, skill in pairs(self.equipped_skills) do
    skill:update(dt)
    if input:down(keybind, 0.5) then skill:cast(self.area, self, self.x, self.y, self.r) end
  end

  self.vx = 0
  self.vy = 0

  local left = input:down('left')
  local right = input:down('right')
  local up = input:down('up')
  local down = input:down('down')

  if left then self.vx = -self.v_max end
  if right then self.vx = self.v_max end
  if up then self.vy = -self.v_max end
  if down then self.vy = self.v_max end

  if (left and right) then self.vx = 0
  elseif (up and down) then self.vy = 0
  elseif (left or right) and (up or down) then
    self.vx = 0.7071 * self.vx
    self.vy = 0.7071 * self.vy
  end

  self.collider:setLinearVelocity(self.vx, self.vy)

  if self.collider:enter('Enemy') then self:takeDamage(10, 'physical') end
  if self.collider:enter('Projectile') then
    local collision_data = self.collider:getEnterCollisionData('Projectile')
    local projectile = collision_data.collider:getObject()

    if projectile.caster.type ~= 'player' then
      self:takeDamage(projectile.damage, 'physical')
      projectile:die()
    end
  end
end

function Player:draw()
  love.graphics.setColor(hp_color)
  love.graphics.circle('fill', self.x, self.y, self.w)
  love.graphics.setColor(hp_color)
  love.graphics.line(self.x, self.y, coordsInDirection(self.x, self.y, 2*self.w, self.r))

  if drawDebug then love.graphics.line(self.x, self.y, coordsInDirection(self.x, self.y, 2*gw, self.r)) end
end

function Player:tick()
  self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:takeDamage(damage, type)
  self.hp = math.max(self.hp - damage, 0)

  flash(0.05)
  slow(0.15, 0.2)
  camera:shake(3, 30, 0.4)

  if self.hp == 0 then self:die() end
end

function Player:changeMana(change)
  self.mana = math.max(self.mana + change, 0)
end

function Player:die()
  self.mana = 0
  self.hp = 0
  self.dead = true
  flash(0.15)
  slow(0.15, 1)
  camera:shake(3, 30, 0.4)

  for i = 1, love.math.random(8, 12) do
    self.area:addGameObject('ExplodeParticle', self.x, self.y)
  end

  current_room.room:finish()
end
