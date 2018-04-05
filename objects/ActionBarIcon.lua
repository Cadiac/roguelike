function ActionBarIcon(x, y, opts)
  local cooldown = opts.cooldown or 1
  local cooldown_remaining = opts.cooldown_remaining or 0
  local skill_icon = opts.skill_icon
  local mana_cost = opts.mana_cost
  local current_mana = opts.current_mana
  local hotkey = opts.hotkey

  local width = opts.width or 32
  local height = opts.height or 32
  local font = fonts.m5x7_16

  local progress = (cooldown - cooldown_remaining) / cooldown

  local function cooldownIndicatorMask()
    love.graphics.rectangle('fill', x, y, width, height)
  end

  -- Background
  love.graphics.draw(skill_icon, x, y)
  -- Low mana warning overlay
  if current_mana < mana_cost then
    love.graphics.setColor(0, 0, 0, 224)
    love.graphics.rectangle('fill', x, y, width, height)
  end
  -- Cooldown indicator
  love.graphics.stencil(cooldownIndicatorMask, 'replace', 1)
  love.graphics.setStencilTest('equal', 1)
  love.graphics.setColor(0, 0, 0, 192)
  love.graphics.arc('fill', x + width / 2, y + width / 2, width, -math.pi/2 + 2*math.pi*progress, 3/2*math.pi, 10)
  love.graphics.setStencilTest()
  -- Border
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', x, y, width, height)
  -- Hotkey
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(hotkey, x, y, width, 'left', 0, 1, 1, -2, 2)
  -- Manacost
  love.graphics.setFont(font)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(mana_cost, x, y + height - 10, width, 'right', 0, 1, 1, 1, 4)
end
