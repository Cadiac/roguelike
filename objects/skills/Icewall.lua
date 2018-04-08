Icewall = Skill:extend()

function Icewall:new()
  self.name = 'Icewall'
  self.description = 'Creates a wall that blocks enemies and projectiles.'

  self.cooldown = 5
  self.cooldown_remaining = 0
  self.mana_cost = 10
  self.icon = love.graphics.newImage('resources/sprites/skill_icewall_icon.png')
  self.color = ice_color
  self.wall_hp = 3
end

function Icewall:effect(area, caster)
  local distance = 100
  local start_x, start_y = coordsInDirection(caster.x, caster.y, distance, caster.r)

  area:addGameObject('ShootEffect', start_x, start_y, {parent = caster, distance = 30, color = self.color})
  area:addGameObject('DestructibleObject', start_x, start_y, {
    width = 20,
    height = 20,
    color = self.color,
    r = caster.r,
    hp = self.wall_hp,
    max_age = self.cooldown
  })

  local x, y = coordsInDirection(start_x, start_y, -20, caster.r + math.pi/2)
  area:addGameObject('DestructibleObject', x, y, {
    width = 20,
    height = 20,
    color = self.color,
    r = caster.r,
    hp = self.wall_hp,
    max_age = self.cooldown
  })

  local x, y = coordsInDirection(start_x, start_y, -40, caster.r + math.pi/2)
  area:addGameObject('DestructibleObject', x, y, {
    width = 20,
    height = 20,
    color = self.color,
    r = caster.r,
    hp = self.wall_hp,
    max_age = self.cooldown
  })

  local x, y = coordsInDirection(start_x, start_y, 20, caster.r + math.pi/2)
  area:addGameObject('DestructibleObject', x, y, {
    width = 20,
    height = 20,
    color = self.color,
    r = caster.r,
    hp = self.wall_hp,
    max_age = self.cooldown
  })

  local x, y = coordsInDirection(start_x, start_y, 40, caster.r + math.pi/2)
  area:addGameObject('DestructibleObject', x, y, {
    width = 20,
    height = 20,
    color = self.color,
    r = caster.r,
    hp = self.wall_hp,
    max_age = self.cooldown
  })
end
