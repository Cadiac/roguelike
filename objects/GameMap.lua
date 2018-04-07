GameMap = Object:extend()

function GameMap:new(game)
  self.depth = 10

  self.tileSize = 32
  self.tilesDisplayWidth = 15
  self.tilesDisplayHeight = 15
  self.tileQuads = {}

  self.game = game
  self.game.coordinator:generateMap()
  self.map = self.game.coordinator.map
  self.player_x = self.game.player.x
  self.player_y = self.game.player.y

  self.map_width = 10
  self.map_height = 10
  self.map_display_buffer = 2

  -- grass
  self.tileQuads['grass'] = love.graphics.newQuad(0 * self.tileSize, 20 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- kitchen floor tile
  self.tileQuads['parquet'] = love.graphics.newQuad(2 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- parquet flooring
  self.tileQuads['kitchen'] = love.graphics.newQuad(4 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- middle of red carpet
  self.tileQuads['red'] = love.graphics.newQuad(3 * self.tileSize, 9 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
end

function GameMap:update(dt)
  if self.game then
    self.map = self.game.coordinator.map
    self.player_x = math.floor(self.game.player.x / self.tileSize)
    self.player_y = math.floor(self.game.player.y / self.tileSize)
  end
end

function GameMap:draw()
  if self.game and self.game.coordinator and self.game.coordinator.map then
    for index = 1, #self.game.coordinator.map do
      local x = (index - 1) % self.game.coordinator.max_width * self.tileSize
      local y = math.floor((index - 1) / self.game.coordinator.max_height) * self.tileSize
      love.graphics.draw(atlas, self.tileQuads[self.game.coordinator.map[index]], x, y, 0)
    end
  end
end
