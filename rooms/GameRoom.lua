local GameRoom = Object:extend()

function GameRoom:new(player_class)
  self.area = Area()
  self.area:addPhysicsWorld()

  self.font = fonts.VT323_16

  self.timer = Timer()
  self.main_canvas = love.graphics.newCanvas(gw, gh)

  self.show_endscreen = false
  self.endscreen_object = nil

  self.player_class = player_class or selected_class

  self.area.world:addCollisionClass('Solid')
  self.area.world:addCollisionClass('Player')
  self.area.world:addCollisionClass('Enemy')
  self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile'}})

  -- ceiling = self.area.world:newRectangleCollider(0, 0, gw, 20)
  -- ceiling:setCollisionClass('Solid')
  -- ceiling:setType('static')

  -- ground = self.area.world:newRectangleCollider(0, gh - 20, gw, 20)
  -- ground:setCollisionClass('Solid')
  -- ground:setType('static')

  -- wall_left = self.area.world:newRectangleCollider(0, 0, 20, gh)
  -- wall_left:setCollisionClass('Solid')
  -- wall_left:setType('static')

  -- wall_right = self.area.world:newRectangleCollider(gw - 20, 0, 20, gh)
  -- wall_right:setCollisionClass('Solid')
  -- wall_right:setType('static')

  self.player = self.area:addGameObject(self.player_class, gw/2, gh/2)

  self.enemies = {
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000)),
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000)),
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000)),
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000)),
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000)),
    self.area:addGameObject('Enemy', gw/2 + random(-1000, 1000), gh/2 + random(-1000, 1000))
  }

  local function process()
    self.timer:cancel('process_every')

    for i = 1, 10 do
      self.timer:after(i*0.25, function()
        self.area:addGameObject('Circle', random(0, gw), random(0, gh))
      end)
    end
  end

  process()
end

function GameRoom:destroy()
  self.area:destroy()
  self.area = nil
end

function GameRoom:update(dt)
  camera.smoother = Camera.smooth.damped(5)
  -- camera:lockPosition(dt, gw/2, gh/2)

  self.area:update(dt)
  self.timer:update(dt)

  local dx,dy = self.player.x - camera.x, self.player.y - camera.y
  camera:move(dx/2, dy/2)

  if self.show_endscreen and self.endscreen_object then self.endscreen_object:update(dt) end
end

function GameRoom:draw()
  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()

    GameHUD(self.player)
    if self.show_endscreen and self.endscreen_object then self.endscreen_object:draw() end
  love.graphics.setCanvas()

  love.graphics.setColor(default_color)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

function GameRoom:finish()
  self.timer:after(1, function()
    self.show_endscreen = true
    self.endscreen_object = EndScreen(self)
  end)
end

return GameRoom
