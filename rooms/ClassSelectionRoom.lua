local ClassSelectionRoom = Object:extend()

function ClassSelectionRoom:new()
  self.font = fonts.m5x7_16
  self.class_icon_1 = ClassSelectorIcon(
    (gw*sx)/2,
    gh/2 + 150,
    {
      ['name'] = 'Cleric',
      ['action'] = function() gotoRoom('GameRoom') end
    }
  )
  self.class_icon_2 = ClassSelectorIcon(
    (gw*sx)/2 - 150,
    gh/2 + 150,
    {
      ['name'] = 'Mage',
      ['action'] = function() gotoRoom('GameRoom') end
    }
  )
  self.class_icon_3 = ClassSelectorIcon(
    (gw*sx)/2 + 150,
    gh/2 + 150,
    {
      ['name'] = 'Necromancer',
      ['action'] = function() gotoRoom('GameRoom') end
    }
  )
end

function ClassSelectionRoom:destroy()
end

function ClassSelectionRoom:update(dt)
  self.class_icon_1:update(dt)
  self.class_icon_2:update(dt)
  self.class_icon_3:update(dt)
end

function ClassSelectionRoom:draw()
  local text = 'Choose your class'
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

  self.class_icon_1:draw()
  self.class_icon_2:draw()
  self.class_icon_3:draw()
end

return ClassSelectionRoom
