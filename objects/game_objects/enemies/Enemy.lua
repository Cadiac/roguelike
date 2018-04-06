Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
  Enemy.super.new(self, area, x, y, opts)
  self.depth = 90

  self.x, self.y = x, y
  self.w = 12

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Enemy')

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
    ['skill_slot_1'] = Skill()
  }

  self.direction = 'left'

  self.timer:every(5, function() self:attack() end)
  self.timer:every(2, function()
    local rand = random(0, 3)

    if rand == 0 then self.direction = 'left'
    elseif rand == 1 then self.direction = 'right'
    elseif rand == 2 then self.direction = 'up'
    else self.direction = 'down' end
  end)
end

function Enemy:destroy()
  Enemy.super.destroy(self)
end

function Enemy:update(dt)
  Enemy.super.update(self, dt)

  self.mana = math.min(self.mana + self.mana_regen * dt, self.max_mana)

  for keybind, skill in pairs(self.equipped_skills) do
    skill:update(dt)
    if input:down(keybind, 0.5) then skill:cast(self.area, self, self.x, self.y, self.r) end
  end

  self.vx = 0
  self.vy = 0

  if self.direction == 'left' then self.vx = -self.v_max end
  if self.direction == 'right' then self.vx = self.v_max end
  if self.direction == 'up' then self.vy = -self.v_max end
  if self.direction == 'down' then self.vy = self.v_max end

  self.collider:setLinearVelocity(self.vx, self.vy)

  if self.collider:enter('Projectile') then self:takeDamage(50, 'physical') end
end

function Enemy:draw()
  love.graphics.setColor(poison_color)
  love.graphics.circle('fill', self.x, self.y, self.w)

  self.r = angleTowardsCoords(self.x, self.y, current_room.room.player.x, current_room.room.player.y)

  love.graphics.line(self.x, self.y, coordsInDirection(self.x, self.y, 2*self.w, self.r))
end

function Enemy:tick()
  self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Enemy:takeDamage(damage, type)
  self.hp = math.max(self.hp - damage, 0)

  if self.hp == 0 then self:die() end
end

function Enemy:changeMana(change)
  self.mana = math.max(self.mana + change, 0)
end

function Enemy:attack()
  self.equipped_skills.skill_slot_1:cast(self.area, self, self.x, self.y, self.r)
end

function Enemy:die()
  self.mana = 0
  self.hp = 0
  self.dead = true

  for i = 1, love.math.random(8, 12) do
    self.area:addGameObject('ExplodeParticle', self.x, self.y)
  end
end
