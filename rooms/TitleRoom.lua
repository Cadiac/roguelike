local TitleScreen = Object:extend()

function TitleScreen:new()
  self.font = fonts.m5x7_16
  self.start_button_hilight = false

  self.newgame_button = Button(gw, gh/2 + 80, {
    ['text'] = 'New Game',
    ['action'] = function() gotoRoom('ClassSelectionRoom') end,
    ['text_scale'] = 3,
    ['transparent'] = true
  })

  self.continue_button = Button(gw, gh/2 + 150, {
    ['text'] = 'Continue',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 3,
    ['transparent'] = true
  })

  self.settings_button = Button(gw, gh/2 + 220, {
    ['text'] = 'Settings',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 3,
    ['transparent'] = true
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
  local text = 'Unnamed Game'
  local text_scale = 5
  local text_width = self.font:getWidth(text) * text_scale

  local text_x = gw - text_width/2
  local text_y = gh/2

  love.graphics.setFont(self.font)
  love.graphics.setColor(holy_color)
  love.graphics.print(text,
    text_x,
    text_y,
    0,
    text_scale,
    text_scale
  )

  self.newgame_button:draw()
  self.continue_button:draw()
  self.settings_button:draw()
end

return TitleScreen
