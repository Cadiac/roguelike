Button = Object:extend()

function Button:new(x, y, opts)
  self.x, self.y = x, y

  self.text = opts.text or 'Close'
  self.action = opts.action
  self.transparent = opts.transparent or false

  self.font = fonts.m5x7_16
  self.text_scale = opts.text_scale or 1
  self.text_width = self.font:getWidth(self.text) * self.text_scale
  self.text_height = self.font:getHeight(self.text) * self.text_scale

  self.text_x = self.x - self.text_width/2
  self.text_y = self.y

  self.rectangle_x = self.text_x - self.text_width/4
  self.rectangle_y = self.text_y - self.text_scale
  self.rectangle_width = (3/2) * self.text_width
  self.rectangle_height = (4/3) * self.text_height

  self.start_button_hilight = false
end

function Button:destroy()
end

function Button:update(dt)
  local mouse_x, mouse_y = love.mouse.getPosition()

  -- Start game button
  if mouse_x >= self.rectangle_x and mouse_x <= self.rectangle_x + self.rectangle_width and
     mouse_y >= self.rectangle_y and mouse_y <= self.rectangle_y + self.rectangle_height then
    self.start_button_hilight = true
    -- Start game
    if input:pressed('left_click') then
      self.action()
      self.start_button_hilight = false
    end
  else
    self.start_button_hilight = false
  end
end

function Button:draw()
  love.graphics.setFont(self.font)

  if self.start_button_hilight then
    love.graphics.setColor(lightning_color)
  else
    love.graphics.setColor(holy_color)
  end

  if not self.transparent then
    love.graphics.rectangle('fill', self.text_x - self.text_width/4, self.rectangle_y, self.rectangle_width, self.rectangle_height)
    love.graphics.setColor(death_color)
  end

  love.graphics.print(self.text,
    self.text_x,
    self.text_y,
    0,
    self.text_scale,
    self.text_scale
  )
end
