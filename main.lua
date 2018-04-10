Object = require 'libraries/classic/classic'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/enhanced_timer/EnhancedTimer'
Camera = require 'libraries/hump/camera'
fn = require 'libraries/moses/moses'
Physics = require 'libraries/windfield/windfield'
sti = require 'libraries/sti/sti'

require 'globals'
require 'GameObject'
require 'utils'
require 'objects/Area'
require 'objects/Shake'
require 'objects/GameCoordinator'
require 'objects/GameMap'

-- GameObjects
require 'objects/game_objects/Circle'
require 'objects/game_objects/Rectangle'
require 'objects/game_objects/Projectile'
require 'objects/game_objects/InfoText'
require 'objects/game_objects/DestructibleObject'

-- Player Classes
require 'objects/game_objects/player/Player'
require 'objects/game_objects/player/Cleric'
require 'objects/game_objects/player/Elementalist'
require 'objects/game_objects/player/Necromancer'

-- Enemies
require 'objects/game_objects/enemies/Enemy'

-- Effects
require 'objects/game_objects/effects/ShootEffect'
require 'objects/game_objects/effects/ProjectileDeathEffect'
require 'objects/game_objects/effects/ExplodeParticle'
require 'objects/game_objects/effects/TickEffect'

-- Other UI
require 'ui/GameHUD'
require 'ui/EndScreen'
require 'ui/ResourceBar'
require 'ui/ActionBarIcon'
require 'ui/Button'
require 'ui/ClassSelectorIcon'

-- Skills
require 'objects/skills/Skill'
require 'objects/skills/Fireball'
require 'objects/skills/PoisonDart'
require 'objects/skills/Icewall'

local available_rooms = {
  ['TitleRoom'] = require 'rooms/TitleRoom',
  ['ClassSelectionRoom'] = require 'rooms/ClassSelectionRoom',
  ['GameRoom'] = require 'rooms/GameRoom',
  ['RectangleRoom'] = require 'rooms/RectangleRoom'
}

fonts = {}

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

  -- Fonts
  local m5x7_8 = love.graphics.newFont('resources/fonts/m5x7.ttf', 8)
  m5x7_8:setFilter('nearest', 'nearest')
  fonts['m5x7_8'] = m5x7_8

  local m5x7_16 = love.graphics.newFont('resources/fonts/m5x7.ttf', 16)
  m5x7_16:setFilter('nearest', 'nearest')
  fonts['m5x7_16'] = m5x7_16

  love.graphics.setFont(m5x7_16)

  resize(gscale)

  -- Rooms
  rooms = {}

  current_room = nil
  selected_class = 'Elementalist'
  gotoRoom('TitleRoom')

  keybindings = {
    ['left_click'] = 'mouse1',
    ['skill_slot_1'] = '1',
    ['skill_slot_2'] = '2',
    ['skill_slot_3'] = '3',
    ['skill_slot_4'] = '4',
    ['left'] = 'a',
    ['right'] = 'd',
    ['up'] = 'w',
    ['down'] = 's',
    ['restart'] = 'r',
    ['return'] = 'return',
    ['escape'] = 'escape'
  }

  rebindKeys()

  -- Sprites
  atlas = love.graphics.newImage('resources/sprites/example-tileset.png')
  atlas:setFilter('nearest', 'nearest')
end

function love.update(dt)
  timer:update(dt*slow_amount)
  camera:update(dt*slow_amount)
  if current_room and current_room.room then current_room.room:update(dt*slow_amount) end
end

function love.draw()
  local mouse_x, mouse_y = love.mouse.getPosition()

  -- Render room
  if current_room and current_room.room then current_room.room:draw() end
  -- Flash damage indicator
  if flash_frames then
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
    love.graphics.setColor(default_color)
  end

  -- Mouse
  love.graphics.line(mouse_x - 10, mouse_y, mouse_x + 10, mouse_y)
  love.graphics.line(mouse_x, mouse_y - 10, mouse_x, mouse_y + 10)

  if drawDebug then
    local statistics = ("fps: %d, mem: %dKB, mouse: (%d,%d), player: (%d,%d), camera: (%d,%d)"):format(
      love.timer.getFPS(),
      collectgarbage("count"),
      mouse_x,
      mouse_y,
      (current_room.room.player and current_room.room.player.x) or 0,
      (current_room.room.player and current_room.room.player.y) or 0,
      camera.x or 0,
      camera.y or 0
    )
    love.graphics.setColor(default_color)
    love.graphics.print(statistics, 10, 10)
    love.graphics.line(sx*gw/2, 0, sx*gw/2, sy*gh)
    love.graphics.line(0, sy*gh/2, sx*gw, sy*gh/2)
  end
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

function rebindKeys()
  input:unbindAll()
  for event, keybinding in pairs(keybindings) do
    input:bind(keybinding, event)
  end

  if drawDebug then
    input:bind('f1', function() gotoRoom('TitleRoom') end)
    input:bind('f2', function() gotoRoom('GameRoom') end)
    input:bind('f3', function() gotoRoom('RectangleRoom') end)
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

    input:bind('f6', function()
      if current_room and current_room.room then
        current_room.room:destroy()
        rooms[current_room.type] = nil
        current_room = nil
      end
    end)

    input:bind('f12', function() debug.debug() end)
  end
end
