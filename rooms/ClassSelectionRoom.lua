local ClassSelectionRoom = Object:extend()

function ClassSelectionRoom:new()
  self.font = fonts.m5x7_16
  self.menu_canvas = love.graphics.newCanvas(gw, gh)

  self.class_icon_1 = ClassSelectorIcon(
    gw/2,
    gh/4 + 80,
    {
      ['name'] = 'Elementalist',
      ['action'] = function()
        selected_class = 'Elementalist'
        gotoRoom('GameRoom', 'Elementalist')
      end
    }
  )
  self.class_icon_2 = ClassSelectorIcon(
    gw/2 - 100,
    gh/4 + 60,
    {
      ['name'] = 'Cleric',
      ['action'] = function()
        selected_class = 'Cleric'
        gotoRoom('GameRoom', 'Cleric')
      end
    }
  )
  self.class_icon_3 = ClassSelectorIcon(
    gw/2 + 100,
    gh/4 + 60,
    {
      ['name'] = 'Necromancer',
      ['action'] = function()
        selected_class = 'Necromancer'
        gotoRoom('GameRoom', 'Necromancer')
      end
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
  local text_scale = 2
  local text_width = self.font:getWidth(text) * text_scale

  local text_x = (gw/2) - text_width/2
  local text_y = gh/4 - 50

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

    self.class_icon_1:draw()
    self.class_icon_2:draw()
    self.class_icon_3:draw()

  love.graphics.setCanvas()
  love.graphics.setColor(default_color)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.menu_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return ClassSelectionRoom
