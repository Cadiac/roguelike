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
require 'objects/ShootEffect'
require 'objects/Projectile'
require 'objects/ProjectileDeathEffect'
require 'objects/ExplodeParticle'
require 'objects/TickEffect'

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

  resize(gscale)

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

  hp_bar_bg = {x = gw/2, y = gh/2, w = 200, h = 40}
  hp_bar_fg = {x = gw/2, y = gh/2, w = 200, h = 40}
end

function love.update(dt)
  timer:update(dt*slow_amount)
  camera:update(dt*slow_amount)
  if current_room and current_room.room then current_room.room:update(dt*slow_amount) end
end

function love.draw()
  -- Mouse
  local mouse_x, mouse_y = love.mouse.getPosition()
  love.graphics.line(mouse_x - 10, mouse_y, mouse_x + 10, mouse_y)
  love.graphics.line(mouse_x, mouse_y - 10, mouse_x, mouse_y + 10)

  -- Debug
  local statistics = ("fps: %d, mem: %dKB, mouse: (%d,%d)"):format(love.timer.getFPS(), collectgarbage("count"), mouse_x, mouse_y)
  love.graphics.print(statistics, 10, 10)

  -- Flash background color
  if flash_frames then
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
    love.graphics.setColor(255, 255, 255)
  end

  -- Render room
  if current_room and current_room.room then current_room.room:draw() end
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
