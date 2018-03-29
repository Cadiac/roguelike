Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Camera = require 'libraries/hump/camera'
fn = require 'libraries/moses/moses'
Physics = require 'libraries/windfield/windfield'

require 'GameObject'
require 'utils'
require 'objects/Area'
require 'objects/Shake'

-- GameObjects
require 'objects/Circle'
require 'objects/Rectangle'
require 'objects/Player'

local available_rooms = {
  CircleRoom = require 'rooms/CircleRoom',
  RectangleRoom = require 'rooms/RectangleRoom',
  PolygonRoom = require 'rooms/PolygonRoom',
}

drawDebug = true

function love.load()
  input = Input()
  timer = Timer()
  camera = Camera()

  love.mouse.setVisible(false)
  love.mouse.setGrabbed(true)

  -- Pixelated look
  love.graphics.setDefaultFilter('nearest')
  love.graphics.setLineStyle('rough')

  -- resize(2)

  -- Rooms
  rooms = {}

  current_room = nil
  gotoRoom('CircleRoom')

  input:bind('f1', function() gotoRoom('CircleRoom') end)
  input:bind('f2', function() gotoRoom('RectangleRoom') end)
  input:bind('f3', function() gotoRoom('PolygonRoom') end)
  input:bind('f4', function() camera:shake(4, 30, 0.5) end)

  input:bind('f5', function()
    print("Before collection: " .. collectgarbage("count")/1024)
    collectgarbage()
    print("After collection: " .. collectgarbage("count")/1024)
    print("Object count: ")
    local counts = type_count()
    for k, v in pairs(counts) do print(k, v) end
    print("-------------------------------------")
  end)

  input:bind('g', function()
    if current_room and current_room.room then
      current_room.room:destroy()
      rooms[current_room.type] = nil
      current_room = nil
    end
  end)

  input:bind('mouse1', 'shoot')
  input:bind('h', 'damage')
  input:bind('e', 'expand')
  input:bind('n', 'shrink')

  input:bind('a', 'left')
  input:bind('d', 'right')
  input:bind('w', 'up')
  input:bind('s', 'down')

  -- image = love.graphics.newImage('resources/sprites/ball.png')

  hp_bar_bg = {x = gw/2, y = gh/2, w = 200, h = 40}
  hp_bar_fg = {x = gw/2, y = gh/2, w = 200, h = 40}
end

function love.update(dt)
  if current_room and current_room.room then current_room.room:update(dt) end

  timer:update(dt)
  camera:update(dt)

  if input:pressed('damage') then
    timer:tween('fg', love.math.random(), hp_bar_fg, {w = hp_bar_fg.w - 25}, 'in-out-cubic')
    timer:after('bg_after', 0.25, function()
      timer:tween('bg_tween', 0.5, hp_bar_bg, {w = hp_bar_bg.w - 25}, 'in-out-cubic')
    end)
  end

  if input:pressed('left') then print('left') end
  if input:pressed('right') then print('right') end
  if input:pressed('up') then print('up') end
  if input:pressed('down') then print('down') end

  if input:pressed('shoot') then print('pressed') end
  if input:released('shoot') then print('released') end
  if input:down('shoot') then print('down') end
  if input:down('shoot', 0.5) then print('shoot event') end
end

function love.draw()
  -- Debug statistics
  local statistics = ("fps: %d, mem: %dKB"):format(love.timer.getFPS(), collectgarbage("count"))
  love.graphics.print(statistics, 10, 10)

  -- Mouse
  local mouse_x, mouse_y = love.mouse.getPosition()
  love.graphics.line(mouse_x - 10, mouse_y, mouse_x + 10, mouse_y)
  love.graphics.line(mouse_x, mouse_y - 10, mouse_x, mouse_y + 10)

  -- love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))
  if current_room and current_room.room then current_room.room:draw() end

  -- love.graphics.setColor(222, 64, 64)
  -- love.graphics.rectangle('fill', hp_bar_bg.x, hp_bar_bg.y - hp_bar_bg.h/2, hp_bar_bg.w, hp_bar_bg.h)
  -- love.graphics.setColor(222, 96, 96)
  -- love.graphics.rectangle('fill', hp_bar_fg.x, hp_bar_fg.y - hp_bar_fg.h/2, hp_bar_fg.w, hp_bar_fg.h)
  -- love.graphics.setColor(255, 255, 255)
end

function gotoRoom(room_type, ...)
  if current_room and current_room.room and current_room.room.destroy then
    current_room.room:destroy()
    rooms[current_room.type] = nil
    current_room = nil
  end

  if rooms[room_type] then
    current_room = {
      room = rooms[room_type],
      type = room_type
    }
  elseif available_rooms[room_type] then
    rooms[room_type] = available_rooms[room_type](...)
    current_room = {
      room = rooms[room_type],
      type = room_type
    }
  else
    print('Unknown room!', room_type)
  end
end

function resize(s)
  love.window.setMode(s*gw, s*gh)
  sx, sy = s, s
end
