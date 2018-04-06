GameMap = Object:extend()

function GameMap:new(game)
  self.depth = 10

  self.tileSize = 32
  self.tilesDisplayWidth = 15
  self.tilesDisplayHeight = 15
  self.tileQuads = {}

  self.game = game
  self.tile_x = math.floor(self.game.player.x / self.tileSize)
  self.tile_y = math.floor(self.game.player.y / self.tileSize)

  self.mapWidth = 1000
  self.mapHeight = 1000

  self.map = {}
  for x = 1, self.mapWidth do
    self.map[x] = {}
    for y = 1, self.mapHeight do
      self.map[x][y] = math.floor(love.math.noise(x, y) * 4)
    end
  end

  -- grass
  self.tileQuads[0] = love.graphics.newQuad(0 * self.tileSize, 20 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- kitchen floor tile
  self.tileQuads[1] = love.graphics.newQuad(2 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- parquet flooring
  self.tileQuads[2] = love.graphics.newQuad(4 * self.tileSize, 0 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())
  -- middle of red carpet
  self.tileQuads[3] = love.graphics.newQuad(3 * self.tileSize, 9 * self.tileSize, self.tileSize, self.tileSize,
    atlas:getWidth(), atlas:getHeight())

  self.tilesetBatch = love.graphics.newSpriteBatch(atlas, self.tilesDisplayWidth * self.tilesDisplayHeight)

  self:updateTilesetBatch()
end

function GameMap:update(dt)
  if self.game then
    self.tile_x = math.floor(self.game.player.x / self.tileSize)
    self.tile_y = math.floor(self.game.player.y / self.tileSize)
  end

  self:updateTilesetBatch()
end

function GameMap:draw()
  love.graphics.draw(
    self.tilesetBatch,
    math.floor(-1*(self.tile_x%1)*self.tileSize),
    math.floor(-1*(self.tile_y%1)*self.tileSize),
    0,
    sx,
    sy
  )
end

function GameMap:updateTilesetBatch()
  self.tilesetBatch:clear()

  for x=0, self.tilesDisplayWidth - 1 do
    for y=0, self.tilesDisplayHeight - 1 do
      self.tilesetBatch:add(
        self.tileQuads[self.map[x+math.floor(self.tile_x)][y+math.floor(self.tile_y)]],
        x*self.tileSize/2,
        y*self.tileSize/2
      )
    end
  end
  self.tilesetBatch:flush()
end

