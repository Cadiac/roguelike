PoisonDart = Skill:extend()

function PoisonDart:new()
  self.name = 'PoisonDart'
  self.description = 'Fiery ball that deals fire damage.'

  self.cooldown = 4
  self.cooldown_remaining = 0
  self.mana_cost = 25
  self.damage = 20
  self.icon = love.graphics.newImage('resources/sprites/skill_poisondart_icon.png')
  self.color = poison_color
end

function PoisonDart:effect(area, caster)
  local distance = 1.5*caster.w or 30
  local particle_x, particle_y = coordsInDirection(caster.x, caster.y, caster.w, caster.r)

  area:addGameObject('ShootEffect', particle_x, particle_y, {parent = caster, distance = distance, color = self.color})

  for i = 1, love.math.random(8, 12) do
    area:addGameObject('Projectile',
      particle_x,
      particle_y,
      {
        r = caster.r + (math.pi/6)*love.math.random(),
        color = self.color,
        s = 1,
        v = 200 + love.math.random(0, 50),
        max_range = 100 + love.math.random(0, 20),
        damage = self.damage,
        caster = caster
      }
    )
  end
end
