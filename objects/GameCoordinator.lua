GameCoordinator = Object:extend()

function GameCoordinator:new(game)
  self.timer = Timer()

  self.game = game

  self.current_level = 0
  self.max_width = 10
  self.max_height = 10
  self.tile_types = {
    {
      ['type'] = 'grass',
      ['collider'] = false
    },
    -- {
    --   ['type'] = 'parquet',
    --   ['collider'] = false
    -- },
    {
      ['type'] = 'kitchen',
      ['collider'] = true
    }
    -- {
    --   ['type'] = 'red',
    --   ['collider'] = false
    -- }
  }

  self.seed = 1234567800

  self.map = {}

  self.timer:every(2, function()
    self.game.area:addGameObject('Enemy',
      self.game.player.x + fn.sample({-1, 1}) * random(gw/2, gw),
      self.game.player.y + fn.sample({-1, 1}) * random(gh/2, gh)
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

  for index = 1, #self.map do
    if self.map[index]['collider'] then
      local x = (index - 1) % self.game.coordinator.max_width * 32
      local y = math.floor((index - 1) / self.game.coordinator.max_height) * 32

      local collider = self.game.area.world:newRectangleCollider(x, y, 32, 32)
      collider:setCollisionClass('Solid')
      collider:setType('static')
    end
  end
  print('Generated map with size', #self.map)
end
