GameCoordinator = Object:extend()

function GameCoordinator:new(game)
  self.current_level = 0
  self.max_width = 10
  self.max_height = 10
  self.tile_types = {'grass', 'parquet', 'kitchen', 'red'}
  self.seed = 'futucamp'

  -- self.map = {}
end

function GameCoordinator:update(dt)
end

function GameCoordinator:destroy()
end

function GameCoordinator:generate()
  -- map = fn.sample(tile_types, self.max_width * self.max_height, self.seed)
end
