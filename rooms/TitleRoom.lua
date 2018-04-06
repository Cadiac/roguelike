local TitleScreen = Object:extend()

function TitleScreen:new()
  self.font = fonts.m5x7_16
  self.start_button_hilight = false

  self.newgame_button = Button(gw, gh/2 + 70, {
    ['text'] = 'New Game',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 3
  })

  self.continue_button = Button(gw, gh/2 + 140, {
    ['text'] = 'Continue',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 1
  })

  self.settings_button = Button(gw, gh/2 + 210, {
    ['text'] = 'Settings',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 2
  })
end

function TitleScreen:destroy()
end

function TitleScreen:update(dt)
  self.newgame_button:update(dt)
  self.continue_button:update(dt)
  self.settings_button:update(dt)
end

function TitleScreen:draw()
  local title = 'Unnamed Game'
  local title_width = self.font:getWidth(title)
  local title_x = gw - (title_width * 3) + 90
  local title_y = gh/2

  love.graphics.setFont(self.font)
  love.graphics.setColor(holy_color)
  love.graphics.print(title, title_x + 5, title_y + 3, 0, 3, 3)

  self.newgame_button:draw()
  self.continue_button:draw()
  self.settings_button:draw()
end

return TitleScreen
