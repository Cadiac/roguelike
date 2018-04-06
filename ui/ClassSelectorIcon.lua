ClassSelectorIcon = Object:extend()

function ClassSelectorIcon:new(x, y, opts)
  self.x, self.y = x, y

  self.timer = Timer()
  self.name = opts.name
  self.action = opts.action

  self.icon_width = 100
  self.icon_height = 100

  self.selected = false

  self.font = fonts.m5x7_16
  self.text_scale = 2
  self.text_width = self.font:getWidth(self.name) * self.text_scale
  self.text_height = self.font:getHeight(self.name) * self.text_scale

  self.rectangle_x = self.x - self.icon_width/2
  self.rectangle_y = self.y - self.icon_height/2

  self.text_x = self.x - self.text_width/2
  self.text_y = self.rectangle_y + self.icon_height + 10
end

function ClassSelectorIcon:destroy()
end

function ClassSelectorIcon:update(dt)
  local mouse_x, mouse_y = love.mouse.getPosition()

  if mouse_x >= self.rectangle_x and mouse_x <= self.rectangle_x + self.icon_width and
     mouse_y >= self.rectangle_y and mouse_y <= self.rectangle_y + self.icon_height then

    self.selected = true

    self.icon_width = 125
    self.icon_height = 125
    self.rectangle_x = self.x - self.icon_width/2
    self.rectangle_y = self.y - self.icon_height/2
    self.text_y = self.rectangle_y + self.icon_height + 10
    -- Start game
    if input:pressed('left_click') then
      self.action()
    end
  else
    self.selected = false
    self.icon_width = 100
    self.icon_height = 100
    self.rectangle_x = self.x - self.icon_width/2
    self.rectangle_y = self.y - self.icon_height/2
    self.text_y = self.rectangle_y + self.icon_height + 10
  end
end

function ClassSelectorIcon:draw()
  love.graphics.setFont(self.font)

  if self.selected then
    love.graphics.setColor(lightning_color)
  else
    love.graphics.setColor(holy_color)
  end

  love.graphics.rectangle('line', self.rectangle_x, self.rectangle_y, self.icon_width, self.icon_height)
  love.graphics.print(self.name,
    self.text_x,
    self.text_y,
    0,
    self.text_scale,
    self.text_scale
  )
end
