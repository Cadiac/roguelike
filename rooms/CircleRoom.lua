local CircleRoom = Object:extend()

function CircleRoom:new()
  print('Initialized CircleRoom')
  self.area = Area()
  self.timer = Timer()
  self.main_canvas = love.graphics.newCanvas(gw, gh)

  local function process()
    timer:cancel('process_every')

    for i = 1, 10 do
      self.timer:after(i*0.25, function()
        self.area:addGameObject('Circle', random(0, gw), random(0, gh))
      end)
    end

    self.timer:after(2.5, function()
      self.timer:every('process_every', random(0.5, 1), function()
        table.remove(self.area.game_objects, love.math.random(1, #self.area.game_objects))
        if #self.area.game_objects == 0 then
          process()
        end
      end, 10)
    end)
  end

  process()
end

function CircleRoom:update(dt)
  if input:pressed('expand') then
    self.timer:tween('transform', 1, self.circle, {radius = 96}, 'in-out-linear')
  end
  if input:pressed('shrink') then
    self.timer:tween('transform', 1, self.circle, {radius = 24}, 'in-out-linear')
  end

  camera.smoother = Camera.smooth.damped(5)
  camera:lockPosition(dt, gw/2, gh/2)

  self.area:update(dt)
  self.timer:update(dt)
end

function CircleRoom:draw()
  love.graphics.setCanvas(self.main_canvas)
  love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
  	camera:detach()
  love.graphics.setCanvas()

  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
  love.graphics.setBlendMode('alpha')
end

return CircleRoom
