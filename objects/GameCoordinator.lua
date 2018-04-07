GameCoordinator = Object:extend()

function GameCoordinator:new(game)
  self.timer = Timer()

  self.game = game

  self.current_level = 0
  self.max_width = 10
  self.max_height = 10
  self.tile_types = {'grass', 'parquet', 'kitchen', 'red'}
  self.seed = 1234567890

  self.map = {}

  self.timer:every(1, function()
    self.game.area:addGameObject('Enemy',
      self.game.player.x + fn.sample({-1, 1}) * random(gw, gw * 2),
      self.game.player.y + fn.sample({-1, 1}) * random(gh, gh * 2)
    )
  end)
end

function GameCoordinator:update(dt)
  self.timer:update(dt)
end

function GameCoordinator:destroy()
end

function GameCoordinator:generateMap()
  print('Generating map with seed', self.seed)
  self.map = fn.chain(fn.range(1, self.max_width * self.max_height))
    :map(function(_k, _v) return fn.sample(self.tile_types, 1, self.seed + _k) end)
    :value()
  print('Generated map with size', #self.map)
end
