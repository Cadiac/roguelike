local CircleRoom = Object:extend()

function CircleRoom:new()
  self.area = Area()
  self.area:addPhysicsWorld()

  self.font = fonts.VT323_16

  self.timer = Timer()
  self.main_canvas = love.graphics.newCanvas(gw, gh)

  self.area.world:addCollisionClass('Solid')
  self.area.world:addCollisionClass('Player')
  self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile'}})

  ground = self.area.world:newRectangleCollider(0, gh - 20, gw, 20)
  ground:setCollisionClass('Solid')
  ground:setType('static')

  wall_left = self.area.world:newRectangleCollider(0, 0, 20, gh)
  wall_left:setCollisionClass('Solid')
  wall_left:setType('static')

  wall_right = self.area.world:newRectangleCollider(gw - 20, 0, 20, gh)
  wall_right:setCollisionClass('Solid')
  wall_right:setType('static')

  self.player = self.area:addGameObject('Player', gw/2, gh/2, {
    skill_slot_1 = Skill(skills['PoisonDart']),
    skill_slot_2 = Skill(skills['Fireball']),
    skill_slot_3 = Skill(skills['Icewall']),
    skill_slot_4 = Skill(skills['ChainLightning'])
  })

  input:bind('o', function()
    if (self.player) then
      self.player.dead = true
      self.player = nil
    end
  end)

  local function process()
    timer:cancel('process_every')

    for i = 1, 10 do
      self.timer:after(i*0.25, function()
        self.area:addGameObject('Circle', random(0, gw), random(0, gh))
      end)
    end
  end

  process()
end

function CircleRoom:destroy()
  self.area:destroy()
  self.area = nil
end

function CircleRoom:update(dt)
  if input:pressed('expand') then
    self.timer:tween('transform', 1, self.circle, {radius = 96}, 'in-out-linear')
  end
  if input:pressed('shrink') then
    self.timer:tween('transform', 1, self.circle, {radius = 24}, 'in-out-linear')
  end

  camera.smoother = Camera.smooth.damped(5)
  camera:lockPosition(dt, gw/2, gh/2)

  self.area:update(dt)
  self.timer:update(dt)
end

function CircleRoom:draw()
  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    ResourceBar(50, gh - 35, {
      resource = self.player.mana,
      resource_max = self.player.max_mana,
      color = mana_color,
      width = 100
    })
    ResourceBar(gw - 150, gh - 35, {
      resource = self.player.hp,
      resource_max = self.player.max_hp,
      color = hp_color,
      width = 100
    })
    ActionBarIcon(gw/2 - 67, gh - 35, {
      cooldown = self.player.skill_slot_1.cooldown,
      cooldown_remaining = self.player.skill_slot_1.cooldown_remaining,
      current_mana = self.player.mana,
      mana_cost = self.player.skill_slot_1.mana_cost,
      skill_icon = self.player.skill_slot_1.icon,
      hotkey = '1'
    })
    ActionBarIcon(gw/2 - 32, gh - 35, {
      cooldown = self.player.skill_slot_2.cooldown,
      cooldown_remaining = self.player.skill_slot_2.cooldown_remaining,
      current_mana = self.player.mana,
      mana_cost = self.player.skill_slot_2.mana_cost,
      skill_icon = self.player.skill_slot_2.icon,
      hotkey = '2'
    })
    ActionBarIcon(gw/2 + 3, gh - 35, {
      cooldown = self.player.skill_slot_3.cooldown,
      cooldown_remaining = self.player.skill_slot_3.cooldown_remaining,
      current_mana = self.player.mana,
      mana_cost = self.player.skill_slot_3.mana_cost,
      skill_icon = self.player.skill_slot_3.icon,
      hotkey = '3'
    })
    ActionBarIcon(gw/2 + 38, gh - 35, {
      cooldown = self.player.skill_slot_4.cooldown,
      cooldown_remaining = self.player.skill_slot_4.cooldown_remaining,
      current_mana = self.player.mana,
      mana_cost = self.player.skill_slot_4.mana_cost,
      skill_icon = self.player.skill_slot_4.icon,
      hotkey = '4'
    })
  	camera:detach()
  love.graphics.setCanvas()

  love.graphics.setColor(default_color)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return CircleRoom
