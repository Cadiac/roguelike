local Game = Object:extend()

function Game:new(player_class)
  self.area = Area()
  self.area:addPhysicsWorld()
  self.area:addLightWorld()

  self.player_class = player_class or selected_class

  self.font = fonts.VT323_16

  self.timer = Timer()
  self.main_canvas = love.graphics.newCanvas(gw, gh)

  self.show_endscreen = false
  self.endscreen_object = nil

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
  self.coordinator:initMap()
end

function Game:destroy()
  self.area:destroy()
  self.area = nil
end

function Game:update(dt)
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

  if self.coordinator.player then
    camera:lockWindow(dt,
      ((self.coordinator.player.x + self.coordinator.player.x + mouse_x) / 3),
      ((self.coordinator.player.y + self.coordinator.player.y + mouse_y) / 3),
      self.cam_player_x_min,
      self.cam_player_x_max,
      self.cam_player_y_min,
      self.cam_player_y_max
    )
  end

  self.area.light_world:update(dt)
  self.area.light_world:setTranslation(
    -camera.x + gw/2 - ((camera.scale - 1) * camera.x),
    -camera.y + gh/2 - ((camera.scale - 1) * camera.y),
    camera.scale
  )

  if self.show_endscreen and self.endscreen_object then self.endscreen_object:update(dt) end
end

function Game:draw()
  camera:attach()
    self.area.light_world:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", 0, 0, gw, gh)
      if self.coordinator.map then self.coordinator.map:draw() end
      self.area:draw()
    end)
  camera:detach()

  if self.coordinator.player then GameHUD(self.coordinator.player) end
  if self.show_endscreen and self.endscreen_object then self.endscreen_object:draw() end
end

function Game:finish()
  self.timer:after(1, function()
    self.show_endscreen = true
    self.endscreen_object = EndScreen(self)
  end)
end

return Game
