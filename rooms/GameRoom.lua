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

  camera.smoother = Camera.smooth.damped(20)
  camera.scale = 1

  self.cam_player_x_min = love.graphics.getWidth()*0.45
  self.cam_player_y_min = love.graphics.getHeight()*0.45
  self.cam_player_x_max = love.graphics.getWidth()*0.55
  self.cam_player_y_max = love.graphics.getHeight()*0.55

  self.coordinator = GameCoordinator(self)
  self.map = GameMap(self)
end

function GameRoom:destroy()
  self.area:destroy()
  self.area = nil
end

function GameRoom:update(dt)
  self.area:update(dt)
  self.timer:update(dt)
  self.coordinator:update(dt)

  if self.player then
    local mouse_x, mouse_y = camera:getMousePosition(sx, sy)

    camera:lockWindow(dt,
      (self.player.x + self.player.x + mouse_x) / 3,
      (self.player.y + self.player.y + mouse_y) / 3,
      self.cam_player_x_min,
      self.cam_player_x_max,
      self.cam_player_y_min,
      self.cam_player_y_max
    )
  end

  self.map:update(dt)

  if self.show_endscreen and self.endscreen_object then self.endscreen_object:update(dt) end
end

function GameRoom:draw()
  love.graphics.setCanvas{self.main_canvas, stencil=true}
  love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.map:draw()
    self.area:draw()
    camera:detach()

    if self.player then GameHUD(self.player) end
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

function GameRoom:spawnPlayer(x, y)
  print('Spawning player at ', x * sx, y * sy)
  self.player = self.area:addGameObject(self.player_class, x * sx, y * sy)
  camera:lookAt(self.player.x, self.player.y)
end

return GameRoom
