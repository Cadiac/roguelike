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

function distance(x1, y1, x2, y2)
  return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end

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
