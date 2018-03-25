Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
fn = require 'libraries/moses/moses'

require 'GameObject'
require 'utils'
require 'objects/Area'

-- GameObjects
require 'objects/Circle'
require 'objects/Rectangle'

local available_rooms = {
  CircleRoom = require 'rooms/CircleRoom',
  RectangleRoom = require 'rooms/RectangleRoom',
  PolygonRoom = require 'rooms/PolygonRoom',
}

function love.load()
  input = Input()
  timer = Timer()

  -- Rooms
  rooms = {}

  current_room = nil
  gotoRoom('CircleRoom')

  input:bind('f1', function() gotoRoom('CircleRoom') end)
  input:bind('f2', function() gotoRoom('RectangleRoom') end)
  input:bind('f3', function() gotoRoom('PolygonRoom') end)

  input:bind('mouse1', 'shoot')
  input:bind('d', 'damage')
  input:bind('e', 'expand')
  input:bind('s', 'shrink')

  -- image = love.graphics.newImage('resources/sprites/ball.png')

  hp_bar_bg = {x = gw/2, y = gh/2, w = 200, h = 40}
  hp_bar_fg = {x = gw/2, y = gh/2, w = 200, h = 40}
end

function love.update(dt)
  if current_room then current_room:update(dt) end

  timer:update(dt)

  if input:pressed('damage') then
    timer:tween('fg', love.math.random(), hp_bar_fg, {w = hp_bar_fg.w - 25}, 'in-out-cubic')
    timer:after('bg_after', 0.25, function()
      timer:tween('bg_tween', 0.5, hp_bar_bg, {w = hp_bar_bg.w - 25}, 'in-out-cubic')
    end)
  end

  if input:pressed('shoot') then print('pressed') end
  if input:released('shoot') then print('released') end
  if input:down('shoot') then print('down') end
  if input:down('shoot', 0.5) then print('shoot event') end
end

function love.draw()
  love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
  -- love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))
  if current_room then current_room:draw() end

  -- love.graphics.setColor(222, 64, 64)
  -- love.graphics.rectangle('fill', hp_bar_bg.x, hp_bar_bg.y - hp_bar_bg.h/2, hp_bar_bg.w, hp_bar_bg.h)
  -- love.graphics.setColor(222, 96, 96)
  -- love.graphics.rectangle('fill', hp_bar_fg.x, hp_bar_fg.y - hp_bar_fg.h/2, hp_bar_fg.w, hp_bar_fg.h)
  -- love.graphics.setColor(255, 255, 255)
end

function gotoRoom(room_type, ...)
  if rooms[room_type] then
    current_room = rooms[room_type]
  elseif available_rooms[room_type] then
    rooms[room_type] = available_rooms[room_type](...)
    current_room = rooms[room_type]
  else
    print('Unknown room!', room_type)
  end
end
