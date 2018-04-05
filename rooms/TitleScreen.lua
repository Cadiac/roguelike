local TitleScreen = Object:extend()

function TitleScreen:new()
  self.font = fonts.m5x7_16
  self.start_button_hilight = false
end

function TitleScreen:destroy()
end

function TitleScreen:update(dt)
  local mouse_x, mouse_y = love.mouse.getPosition()

  -- Start game button
  local newgame = 'New Game'
  local newgame_w = self.font:getWidth(newgame)
  local newgame_x = gw - (newgame_w * 3) + 90
  local newgame_y = gh/2 + 70
  local newgame_button_width = (newgame_w * 3) + 8
  local newgame_button_height = 16 * 3

  if mouse_x >= newgame_x and mouse_x <= newgame_x + newgame_button_width and
     mouse_y >= newgame_y and mouse_y <= newgame_y + newgame_button_height then
    self.start_button_hilight = true
    -- Start game
    if input:pressed('mouse1') then
      gotoRoom('CircleRoom')
      self.start_button_hilight = false
    end
  else
    self.start_button_hilight = false
  end
end

function TitleScreen:draw()
  local mouse_x, mouse_y = love.mouse.getPosition()

  local title = 'Unnamed Game'
  local title_width = self.font:getWidth(title)
  local title_x = gw - (title_width * 3) + 90
  local title_y = gh/2

  love.graphics.setFont(self.font)
  love.graphics.setColor(holy_color)
  -- love.graphics.rectangle('fill', title_x, title_y, (title_width * 3) + 8, 16 * 3)
  -- love.graphics.setColor(death_color)
  love.graphics.print(title, title_x + 5, title_y + 3, 0, 3, 3)

  local newgame = 'New Game'
  local newgame_w = self.font:getWidth(newgame)
  local newgame_x = gw - (newgame_w * 3) + 90
  local newgame_y = gh/2 + 70
  local newgame_button_width = (newgame_w * 3) + 8
  local newgame_button_height = 16 * 3

  if self.start_button_hilight then
    love.graphics.setColor(lightning_color)
  else
    love.graphics.setColor(holy_color)
  end

  love.graphics.rectangle('fill', newgame_x, newgame_y, newgame_button_width, newgame_button_height)
  love.graphics.setColor(death_color)
  love.graphics.print(newgame, newgame_x + 5, newgame_y + 3, 0, 3, 3)

  local continue = 'Continue'
  local continue_w = self.font:getWidth(continue)
  local continue_x = gw - (continue_w * 3) + 90
  local continue_y = gh/2 + 140

  love.graphics.setColor(holy_color)
  love.graphics.rectangle('fill', continue_x, continue_y, (continue_w * 3) + 8, 16 * 3)
  love.graphics.setColor(death_color)
  love.graphics.print(continue, continue_x + 5, continue_y + 3, 0, 3, 3)

  local settings = 'Settings'
  local settings_w = self.font:getWidth(settings)
  local settings_x = gw - (settings_w * 3) + 90
  local settings_y = gh/2 + 210

  love.graphics.setColor(holy_color)
  love.graphics.rectangle('fill', settings_x, settings_y, (settings_w * 3) + 8, 16 * 3)
  love.graphics.setColor(death_color)
  love.graphics.print(settings, settings_x + 5, settings_y + 3, 0, 3, 3)
end

return TitleScreen
