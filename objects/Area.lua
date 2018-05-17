Area = Object:extend()

function Area:new(game)
  self.game = game
  self.game_objects = {}
  self.game_rooms = {}
end

function Area:update(dt)
  if self.world then self.world:update(dt) end

  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i]
    game_object:update(dt)
    if game_object.dead then
      game_object:destroy()
      table.remove(self.game_objects, i)
    end
  end
end

function Area:destroy()
  for i = #self.game_objects, 1, -1 do
    local game_object = self.game_objects[i]
    game_object:destroy()
    table.remove(self.game_objects, i)
  end
  self.game_objects = {}

  if self.world then
    self.world:destroy()
    self.world = nil
  end

  if self.game then
    self.game = nil
  end
end

function Area:draw()
  table.sort(self.game_objects, function(a, b)
    if a.depth == b.depth then return a.creation_time < b.creation_time
    else return a.depth < b.depth end
  end)

  for _, game_object in ipairs(self.game_objects) do
    game_object:draw()
  end

  if drawDebug and self.world then self.world:draw() end
end

function Area:addPhysicsWorld()
  self.world = Physics.newWorld(0, 0, true)
end

function Area:addGameObject(game_object_type, x, y, opts)
  local opts = opts or {}
  local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
  game_object.class = game_object_type
  table.insert(self.game_objects, game_object)
  return game_object
end

function Area:getGameObjects(filter)
  return fn.filter(self.game_objects, function(key, value)
    return filter(value)
  end)
end

function Area:queryCircleArea(x, y, radius, object_types)
  local out = {}
  for _, game_object in ipairs(self.game_objects) do
    if fn.any(object_types, game_object.class) then
      local d = distance(x, y, game_object.x, game_object.y)
      if d <= radius then
        table.insert(out, game_object)
      end
    end
  end
  return out
end

function Area:getClosestObject(x, y, radius, object_types)
  local objects = self:queryCircleArea(x, y, radius, object_types)
  table.sort(objects, function(a, b)
    local da = distance(x, y, a.x, a.y)
    local db = distance(x, y, b.x, b.y)
    return da < db
  end)
  return objects[1]
end

function Area:addLightWorld()
  self.light_world = LightWorld({
    ambient = {0, 0, 0},
    shadowBlur = 0.0,
  })
end

function Area:addRoom(room)
  local room = GameRoom(self.game, room.x, room.y, room.width, room.height)
  self.game_rooms = fn.append(self.game_rooms, room)
end
