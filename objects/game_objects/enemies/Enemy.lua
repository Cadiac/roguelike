Enemy = GameObject:extend()

function Enemy:new(area, x, y, opts)
  Enemy.super.new(self, area, x, y, opts)
  self.depth = 90

  self.type = 'enemy'

  self.x, self.y = x, y
  self.w = 12

  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)
  self.collider:setCollisionClass('Enemy')

  self.r = -math.pi/2
  self.vx = 0
  self.vy = 0
  self.v_max = 90

  self.mana = 50
  self.max_mana = 100
  self.mana_regen = 20

  self.hp = 100
  self.max_hp = 100

  self.passive = true
  self.passive_end = nil

  self.equipped_skills = {
    ['skill_slot_1'] = Skill()
  }

end

function Enemy:destroy()
  Enemy.super.destroy(self)
end

function Enemy:update(dt)
  Enemy.super.update(self, dt)

  if self.passive and
    not current_room.room.player.dead and
    distance(self.x, self.y, current_room.room.player.x, current_room.room.player.y) <= gw
  then
    print('Player nearby, waking up')
    self.passive = false
    self.passive_end = love.timer.getTime()
  end

  if not self.passive then
    -- Go passive again if player is dead or far
    if current_room.room.player.dead then
      print('Job Done!')
      self.r = self.r + math.pi
      self.vx, self.vy = coordsInDirection(0, 0, self.v_max, self.r)
      self.collider:setLinearVelocity(self.vx, self.vy)
      self.passive = true
    elseif love.timer.getTime() - self.passive_end > 10 and distance(
      self.x, self.y, current_room.room.player.x, current_room.room.player.y) > gw then
      print('Sleeping')
      self.passive = true
    else
      self.mana = math.min(self.mana + self.mana_regen * dt, self.max_mana)
      self.r = angleTowardsCoords(self.x, self.y, current_room.room.player.x, current_room.room.player.y)

      for _, skill in pairs(self.equipped_skills) do
        skill:update(dt)
        if not self.passive then skill:cast(self.area, self, self.x, self.y, self.r) end
      end

      -- Track players
      self.vx, self.vy = coordsInDirection(0, 0, self.v_max, self.r)
      self.collider:setLinearVelocity(self.vx, self.vy)

      if self.collider:enter('Projectile') then
        local collision_data = self.collider:getEnterCollisionData('Projectile')
        local projectile = collision_data.collider:getObject()

        if projectile.caster.type ~= 'enemy' then
          self:takeDamage(projectile.damage, 'physical')
          projectile:die()
        end
      end
    end
  end
end

function Enemy:draw()
  love.graphics.setColor(poison_color)
  love.graphics.circle('fill', self.x, self.y, self.w)
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

function Enemy:die()
  self.mana = 0
  self.hp = 0
  self.dead = true

  for i = 1, love.math.random(8, 12) do
    self.area:addGameObject('ExplodeParticle', self.x, self.y)
  end
end
