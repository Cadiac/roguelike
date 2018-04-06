EndScreen = Object:extend()

function EndScreen:new(stage)
  self.game = game
  self.font = fonts.m5x7_16
  print('Endscreen')
end

function EndScreen:update(dt)
  if input:pressed('return') or input:pressed('escape') then timer:after(0.15, function() gotoRoom('TitleRoom') end) end
  if input:pressed('restart') then
    timer:after(0.15, function() gotoRoom('GameRoom') end)
  end
end

function EndScreen:draw()
  love.graphics.setFont(self.font)
  love.graphics.setColor(default_color)
  local backtomenu = string.upper(keybindings['return']) .. ' TO GO TO BACK TO MENU'
  love.graphics.print(backtomenu, gw/2, gh/2 + 30, 0, 1, 1, math.floor(self.font:getWidth(backtomenu)/2), 0)

  local quickrestart = string.upper(keybindings['restart']) .. ' TO QUICK RESTART'
  love.graphics.print(quickrestart, gw/2, gh/2 + 40, 0, 1, 1, math.floor(self.font:getWidth(quickrestart)/2), 0)
end
