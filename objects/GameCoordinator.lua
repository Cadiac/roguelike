GameCoordinator = Object:extend()

function GameCoordinator:new(game, player_class)
  self.timer = Timer()

  self.game = game

  self.current_level = 0

  self.seed = 1234567800

  self.player = nil
  self.map = GameMap(self.game, self)

  self.timer:every(2, function()
    self.game.area:addGameObject('Enemy',
      self.player.x + fn.sample({-1, 1}) * random(gw/10, gw),
      self.player.y + fn.sample({-1, 1}) * random(gh/10, gh)
    )
  end)
end

function GameCoordinator:update(dt)
  self.timer:update(dt)
  self.map:update(dt)
end

function GameCoordinator:destroy()
end

function GameCoordinator:spawnPlayer(x, y)
  print('Spawning player at ', x, y)
  self.player = self.game.area:addGameObject(self.game.player_class, x, y)
  camera:lookAt(self.player.x, self.player.y)
end
