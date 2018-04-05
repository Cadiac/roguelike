Fireball = Skill:extend()

function Fireball:new()
  self.name = 'Fireball'
  self.description = 'Fiery ball that deals fire damage.'

  self.cooldown = 4
  self.cooldown_remaining = 0
  self.mana_cost = 25
  self.icon = love.graphics.newImage('resources/sprites/skill_fireball_icon.png')
  self.color = fire_color
end

function Fireball:effect(area, caster)
  local distance = 30
  local particle_x, particle_y = coordsInDirection(caster.x, caster.y, distance, caster.r)

  area:addGameObject('ShootEffect', particle_x, particle_y, {parent = caster, distance = distance, color = self.color})
  area:addGameObject('Projectile', particle_x, particle_y, {r = caster.r, color = self.color, s = 10, v = 100})
end
