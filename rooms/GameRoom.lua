local GameRoom = Object:extend()

function GameRoom:new(player_class)
  self.area = Area()
  self.area:addPhysicsWorld()
  self.area:addLightWorld()

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

  self.cam_player_x_min = love.graphics.getWidth()*0.45
  self.cam_player_y_min = love.graphics.getHeight()*0.45
  self.cam_player_x_max = love.graphics.getWidth()*0.55
  self.cam_player_y_max = love.graphics.getHeight()*0.55

  self.coordinator = GameCoordinator(self)
  self.map = GameMap(self)

  -- create light
  self.player_light = self.area.light_world:newLight(self.player.x, self.player.y, 255, 127, 63, 300)
  self.player_light:setGlowStrength(0.3)

  -- Debug purposes
  -- self.area.light_world:newCircle(self.player.x - 100, self.player.y, 6)
  -- self.area.light_world:newCircle(self.player.x + 100, self.player.y, 6)
  -- self.area.light_world:newCircle(self.player.x, self.player.y - 100, 6)
  -- self.area.light_world:newCircle(self.player.x, self.player.y + 100, 6)
end

function GameRoom:destroy()
  self.area:destroy()
  self.area = nil
end

function GameRoom:update(dt)
  self.area:update(dt)
  self.timer:update(dt)
  self.coordinator:update(dt)

	if love.keyboard.isDown("o") then
		zoom = zoom - 1 * dt
	elseif love.keyboard.isDown("p") then
		zoom = zoom + 1 * dt
	end

  camera:zoomTo(zoom)

  local mouse_x, mouse_y = camera:getMousePosition(sx * camera.scale, sy * camera.scale)

  if self.player then
    camera:lockWindow(dt,
      ((self.player.x + self.player.x + mouse_x) / 3),
      ((self.player.y + self.player.y + mouse_y) / 3),
      self.cam_player_x_min,
      self.cam_player_x_max,
      self.cam_player_y_min,
      self.cam_player_y_max
    )
  end

  self.player_light:setPosition(
    self.player.x,
    self.player.y
  )

  self.map:update(dt)
  self.area.light_world:update(dt)
  self.area.light_world:setTranslation(
    -camera.x + gw/2 - ((camera.scale - 1) * camera.x),
    -camera.y + gh/2 - ((camera.scale - 1) * camera.y),
    camera.scale
  )

  if self.show_endscreen and self.endscreen_object then self.endscreen_object:update(dt) end
end

function GameRoom:draw()
  camera:attach()
    self.area.light_world:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", 0, 0, gw, gh)
      self.map:draw()
      self.area:draw()
    end)
  camera:detach()

  if self.player then GameHUD(self.player) end
  if self.show_endscreen and self.endscreen_object then self.endscreen_object:draw() end
  -- love.graphics.setCanvas()

  -- love.graphics.setColor(default_color)
  -- love.graphics.setBlendMode('alpha', 'premultiplied')
  -- love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  -- love.graphics.setBlendMode('alpha')
end

function GameRoom:finish()
  self.timer:after(1, function()
    self.show_endscreen = true
    self.endscreen_object = EndScreen(self)
  end)
end

function GameRoom:spawnPlayer(x, y)
  print('Spawning player at ', x, y)
  self.player = self.area:addGameObject(self.player_class, x, y)
  camera:lookAt(self.player.x, self.player.y)
end

return GameRoom
