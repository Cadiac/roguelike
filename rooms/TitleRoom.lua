local TitleRoom = Object:extend()

function TitleRoom:new()
  self.font = fonts.m5x7_16
  self.start_button_hilight = false
  self.menu_canvas = love.graphics.newCanvas(gw, gh)

  self.newgame_button = Button(gw/2, gh/4 + 50, {
    ['text'] = 'New Game',
    ['action'] = function() gotoRoom('ClassSelectionRoom') end,
    ['text_scale'] = 2,
    ['transparent'] = true
  })

  self.continue_button = Button(gw/2, gh/4 + 90, {
    ['text'] = 'Continue',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 2,
    ['transparent'] = true
  })

  self.settings_button = Button(gw/2, gh/4 + 130, {
    ['text'] = 'Settings',
    ['action'] = function() gotoRoom('GameRoom') end,
    ['text_scale'] = 2,
    ['transparent'] = true
  })
end

function TitleRoom:destroy()
end

function TitleRoom:update(dt)
  self.newgame_button:update(dt)
  self.continue_button:update(dt)
  self.settings_button:update(dt)
end

function TitleRoom:draw()
  local text = 'Unnamed Game'
  local text_scale = 3
  local text_width = self.font:getWidth(text) * text_scale

  local text_x = (gw/2) - text_width/2
  local text_y = gh/4

  love.graphics.setCanvas{self.menu_canvas}
  love.graphics.clear()

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

  love.graphics.setCanvas()
  love.graphics.setColor(default_color)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.menu_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return TitleRoom
