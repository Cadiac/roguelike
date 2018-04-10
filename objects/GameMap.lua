GameMap = Object:extend()

function GameMap:new(game)
  self.depth = 10
  self.game = game
  self.player_x = 0
  self.player_y = 0
  -- self.tileSize = 32
  -- self.tileQuads = {}

  -- self.game = game
  -- self.game.coordinator:generateMap()
  -- self.map = self.game.coordinator.map
  -- self.player_x = self.game.player.x
  -- self.player_y = self.game.player.y

  -- local x, y = camera:getWorldCoords(0,0)
  -- print('(0,0) ' .. '(' .. x .. ',' .. y .. ')')
  -- x, y = camera:getWorldCoords(gw,0)
  -- print('(' .. gw .. ', 0) (' .. x .. ',' .. y .. ')')
  -- x, y = camera:getWorldCoords(0,gh)
  -- print('(0,' .. gh .. ') (' .. x .. ',' .. y .. ')')
  -- x, y = camera:getWorldCoords(gw,gh)
  -- print('(' .. gw .. ',' .. gh .. ') (' .. x .. ',' .. y .. ')')
  -- x, y = camera:getWorldCoords(100,100)
  -- print('(100, 100) (' .. x .. ',' .. y .. ')')

  -- -- grass
  -- self.tileQuads['grass'] = love.graphics.newQuad(0 * self.tileSize, 20 * self.tileSize, self.tileSize, self.tileSize,
  --   atlas:getWidth(), atlas:getHeight())
  -- -- kitchen floor tile
  -- self.tileQuads['parquet'] = love.graphics.newQuad(2 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
  --   atlas:getWidth(), atlas:getHeight())
  -- -- parquet flooring
  -- self.tileQuads['kitchen'] = love.graphics.newQuad(4 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
  --   atlas:getWidth(), atlas:getHeight())
  -- -- middle of red carpet
  -- self.tileQuads['red'] = love.graphics.newQuad(3 * self.tileSize, 9 * self.tileSize, self.tileSize, self.tileSize,
  --   atlas:getWidth(), atlas:getHeight())
  self.map = sti('resources/sprites/dungeon.lua', nil, 113, 60)
end

function GameMap:update(dt)
  self.map:update(dt)
  if self.game then
    -- self.map = self.game.coordinator.map
    self.player_x = math.floor(self.game.player.x)
    self.player_y = math.floor(self.game.player.y)
  end
end

function GameMap:draw()
  self.map:draw(-camera.x / sx, -camera.y / sy, sx, sy)
  -- local camera_x, camera_y = camera:position()
  -- local visible_min_x, visible_min_y = camera:getWorldCoords(camera_x - 64, camera_y - 64)
  -- local visible_max_x, visible_max_y = camera:getWorldCoords(camera_x + 2 * gw, camera_y + 2 * gh)

  -- local rendered = 0
  -- if self.game and self.game.coordinator and self.game.coordinator.map then
  --   for index = 1, #self.game.coordinator.map do
  --     local x = (index - 1) % self.game.coordinator.max_width * self.tileSize
  --     local y = math.floor((index - 1) / self.game.coordinator.max_height) * self.tileSize
  --     if x >= visible_min_x/sx and y >= visible_min_y/sy and x <= visible_max_x/sx and y <= visible_max_y/sy then
  --       rendered = rendered + 1
  --       love.graphics.draw(atlas, self.tileQuads[self.game.coordinator.map[index]['type']], x, y, 0)
  --     end
  --   end
  -- end
  -- print('Rendered ' .. rendered .. ' tiles')
end

function GameMap:getObjects()
  return self.map.objects
end
