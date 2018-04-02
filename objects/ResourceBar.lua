function ResourceBar(x, y, opts)
  local resource = opts.resource or 100
  local max_resource = opts.max_resource or 100

  local color = opts.color or hp_color
  local width = opts.width or 200
  local height = opts.height or 12
  local font = fonts.m5x7_16

  -- Background
  love.graphics.setColor(8, 8, 8)
  love.graphics.rectangle('fill', x, y, width + 1, height)
  -- Bar
  love.graphics.setColor(color)
  love.graphics.rectangle('fill', x, y, width * (resource / max_resource), height - 1)
  -- Border
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('line', x, y, width + 1, height)
  -- Text

  local text = ('%d / %d'):format(math.floor(resource), math.floor(max_resource))
  love.graphics.setFont(font)
  love.graphics.printf(text, x, y, width, 'center', 0, 1, 1, 0, 2)
end
