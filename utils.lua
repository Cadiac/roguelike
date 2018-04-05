-- Generic utility helpers
function UUID()
  local fn = function(x)
    local r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function random(min, max)
  if not max then -- if max is nil then it means only one value was passed in
    return love.math.random()*min
  else
    if min > max then min, max = max, min end
    return love.math.random()*(max - min) + min
  end
end

-- Coordinates math helpers
function distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end

function coordsInDirection(x, y, distance, angle)
  print(x)
  print(y)
  print(distance)
  print(angle)
  return x + distance*math.cos(angle), y + distance*math.sin(angle)
end

function angleTowardsCoords(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end

-- Drawing helpers
-- Rotate all graphics by r until love.graphics.pop() is called
function pushRotate(x, y, r)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.translate(-x, -y)
end

-- Scale all graphics by sx and sy and rotate by r until love.graphics.pop() is called
function pushRotateScale(x, y, r, sx, sy)
  love.graphics.push()
  love.graphics.translate(x, y)
  love.graphics.rotate(r or 0)
  love.graphics.scale(sx or 1, sy or sx or 1)
  love.graphics.translate(-x, -y)
end

-- Slow time
function slow(amount, duration)
  slow_amount = amount
  timer:tween('slow', duration, _G, {slow_amount = 1}, 'in-out-cubic')
end

-- Flash background color
function flash(duration)
  flash_frames = true
  timer:after('flash', duration, function() flash_frames = false end)
end

-- Debug prints
function printAll(...)
  local args = {...}
  for _, arg in ipairs(args) do
    print(arg)
  end
end

function printText(...)
  local args = {...}
  local str = ''
  for _, arg in ipairs(args) do
    str = str .. arg
  end
  print(str)
end

function count_all(f)
  local seen = {}
  local count_table
  count_table = function(t)
    if seen[t] then return end
    f(t)
    seen[t] = true
    for k,v in pairs(t) do
      if type(v) == "table" then
        count_table(v)
      elseif type(v) == "userdata" then
        f(v)
      end
    end
  end
  count_table(_G)
end

function type_count()
  local counts = {}
  local enumerate = function (o)
    local t = type_name(o)
    counts[t] = (counts[t] or 0) + 1
  end
  count_all(enumerate)
  return counts
end

global_type_table = nil
function type_name(o)
  if global_type_table == nil then
    global_type_table = {}
    for k,v in pairs(_G) do
      global_type_table[v] = k
    end
    global_type_table[0] = "table"
  end
  return global_type_table[getmetatable(o) or 0] or "Unknown"
end
