Skill = Object:extend()

function Skill:new(skill)
  self.timer = Timer()

  self.cooldown = skill.cooldown
  self.cooldown_remaining = 0

  self.mana_cost = skill.mana_cost or 10
  self.description = skill.description
  self.icon = skill.icon
  self.color = skill.color or {255, 255, 255}
  self.action = skill.action
end

function Skill:destroy()
  self.timer:destroy()
end

function Skill:update(dt)
  if self.timer then self.timer:update(dt) end
  if self.cooldown_remaining > 0 then self.cooldown_remaining = math.max(self.cooldown_remaining - dt, 0) end
end

function Skill:cast(area, caster, ...)
  if self.cooldown_remaining == 0 and caster.mana > self.mana_cost then
    caster:changeMana(-self.mana_cost)
    self.cooldown_remaining = self.cooldown
    if self.action then self.action(area, caster, caster.x, caster.y, caster.r, self.color) end
  end
end

-- Dummy spell
local function spell_action(area, player, x, y, r, color)
  local distance = 30
  local particle_x, particle_y = coordsInDirection(x, y, distance, r)

  area:addGameObject('ShootEffect', particle_x, particle_y, {player = player, distance = distance, color = color})
  area:addGameObject('Projectile', particle_x, particle_y, {r = r, color = color})
end

-- Skills
skills = {
  ['PoisonDart'] = {
    cooldown = 1,
    mana_cost = 10,
    color = poison_color,
    description = 'Poisons enemy, dealing damage over time.',
    icon = love.graphics.newImage('resources/sprites/skill_poison_icon.png'),
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
  }
}
