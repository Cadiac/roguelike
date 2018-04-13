Skill = Object:extend()

function Skill:new()
  self.timer = Timer()

  self.name = 'Empty skill'
  self.cooldown = 1
  self.cooldown_remaining = 0
  self.description = 'This description was intentionally left blank.'
  self.mana_cost = 10
  self.damage = 10
  self.icon = love.graphics.newImage('resources/sprites/skill_poisondart_icon.png')
  self.color = {255, 255, 255}
end

function Skill:destroy()
  self.timer:destroy()
  Skill.super.destroy(self)
end

function Skill:update(dt)
  if self.timer then self.timer:update(dt) end
  if self.cooldown_remaining > 0 then self.cooldown_remaining = math.max(self.cooldown_remaining - dt, 0) end
end

function Skill:cast(area, caster, ...)
  if self.cooldown_remaining == 0 and caster.mana > self.mana_cost then
    caster:changeMana(-self.mana_cost)
    self.cooldown_remaining = self.cooldown
    self:effect(area, caster, ...)
  end
end

-- Dummy skill, shoots projectile.
function Skill:effect(area, caster, ...)
  local distance = 1.5*caster.w or 30
  local particle_x, particle_y = coordsInDirection(caster.x, caster.y, caster.w, caster.r)

  area:addGameObject('ShootEffect', particle_x, particle_y, {parent = caster, distance = distance, color = self.color})
  area:addGameObject('Projectile',
    particle_x,
    particle_y,
    {
      r = caster.r,
      color = self.color,
      damage = self.damage,
      caster = caster
    }
  )
end

-- Skills
skills = {
  ['PoisonDart'] = {
    cooldown = 1,
    mana_cost = 10,
    color = poison_color,
    description = 'Poisons enemy, dealing damage over time.',
    icon = love.graphics.newImage('resources/sprites/skill_poisondart_icon.png'),
    action = spell_action
  },
  ['Fireball'] = {
    cooldown = 4,
    mana_cost = 25,
    color = fire_color,
    description = 'Fiery ball that deals fire damage.',
    icon = love.graphics.newImage('resources/sprites/skill_fireball_icon.png'),
    action = spell_action
  },
  ['Icewall'] = {
    cooldown = 10,
    mana_cost = 50,
    color = ice_color,
    description = 'Creates a wall that blocks enemies and projectiles.',
    icon = love.graphics.newImage('resources/sprites/skill_icewall_icon.png'),
    action = spell_action
  },
  ['ChainLightning'] = {
    cooldown = 7,
    mana_cost = 30,
    color = lightning_color,
    description = 'Attack that chains to nearby enemies, dealing 25% less damage each jump.',
    icon = love.graphics.newImage('resources/sprites/skill_chainlightning_icon.png'),
    action = spell_action
  },
  ['WaterBolt'] = {
    cooldown = 7,
    mana_cost = 30,
    color = water_color,
    description = 'Water bolt dealing minor damage, and setting enemies wet.',
    icon = love.graphics.newImage('resources/sprites/skill_chainlightning_icon.png'),
    action = spell_action
  },
  ['BloodCircle'] = {
    cooldown = 7,
    mana_cost = 30,
    color = blood_color,
    description = 'Blood circle forms from the ground, dealing heavy damage in small AoE after 3 seconds.',
    icon = love.graphics.newImage('resources/sprites/skill_chainlightning_icon.png'),
    action = spell_action
  },
  ['DeathBolt'] = {
    cooldown = 7,
    mana_cost = 30,
    color = blood_color,
    description = 'Death type attack that leaves a damage over time effect on enemies it hits.',
    icon = love.graphics.newImage('resources/sprites/skill_chainlightning_icon.png'),
    action = spell_action
  },
  ['Barrier'] = {
    cooldown = 7,
    mana_cost = 30,
    color = holy_color,
    description = 'Barrier that temporarily protects player from taking damage.',
    icon = love.graphics.newImage('resources/sprites/skill_chainlightning_icon.png'),
    action = spell_action
  }
}
