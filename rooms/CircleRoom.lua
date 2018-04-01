local CircleRoom = Object:extend()

function CircleRoom:new()
  self.area = Area()
  self.area:addPhysicsWorld()

  self.font = fonts.VT323_16

  self.timer = Timer()
  self.main_canvas = love.graphics.newCanvas(gw, gh)

  self.area.world:addCollisionClass('Solid')

  ground = self.area.world:newRectangleCollider(0, gh - 20, gw, 20)
  ground:setCollisionClass('Solid')
  ground:setType('static')

  wall_left = self.area.world:newRectangleCollider(0, 0, 20, gh)
  wall_left:setCollisionClass('Solid')
  wall_left:setType('static')

  wall_right = self.area.world:newRectangleCollider(gw - 20, 0, 20, gh)
  wall_right:setCollisionClass('Solid')
  wall_right:setType('static')

  self.player = self.area:addGameObject('Player', gw/2, gh/2)

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
    ResourceBar(50, gh - 30, {
      resource = self.player.mana,
      resource_max = self.player.max_mana,
      color = {0, 0, 255},
      width = 100
    })
    ResourceBar(gw - 150, gh - 30, {
      resource = self.player.hp,
      resource_max = self.player.max_hp,
      color = {255, 0, 0},
      width = 100
    })
  	camera:detach()
  love.graphics.setCanvas()

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return CircleRoom
