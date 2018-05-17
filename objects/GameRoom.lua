GameRoom = Object:extend()

function GameRoom:new(game, x, y, width, height)
  self.game = game

  self.x = x
  self.y = y
  self.width = width
  self.height = height

  self.active = false
  self.completed = false

  self.spawns = {}
  self.doors = {}
end

function GameRoom:destroy()
  self.game = nil
  self.spawns = nil
  self.doors = nil
end

function GameRoom:setActive()
  self.active = true
end

function GameRoom:setCompleted()
  self.completed = true
end

function GameRoom:spawnEnemies()
  for _key, spawn in pairs(self.spawns) do
    self.game.coordinator.spawnEnemies(spawn.x, spawn.y, spawn.type)
  end
end

function GameRoom:isInsideRoom(x, y)
  return
    (x >= self.x and x <= self.x + self.width) and
    (y >= self.y and y <= self.y + self.height)
end
