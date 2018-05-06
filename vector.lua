-- Taken from https://gamedev.stackexchange.com/a/111104
local vector = {}

local function getVec2(x_,y_)
  vec2={}
  vec2.x=x_
  vec2.y=y_

  function vec2:dist() --set relative position
    return math.sqrt(vec2.x*vec2.x + vec2.y*vec2.y)
  end

  function vec2:sqrdist() --set relative position
    return vec2.x*vec2.x + vec2.y*vec2.y
  end

  function vec2.mulf(v,f  )
    return getVec2(v.x*f , v.y*f)
  end

  function vec2.minus(v1 ,v2  )
    return getVec2(v1.x-v2.x , v1.y-v2.y)
  end

  --cross product v × w to be vx wy − vy wx
  function vec2.cross(v1,v2  )
    return v1.x*v2.y - v1.y*v2.x
  end
  function vec2.dot(v1,v2  )
    return v1.x*v2.x + v1.y*v2.y
  end
  function vec2.add(v1,v2  )
    return getVec2(v1.x+v2.x , v1.y+v2.y)
  end

  function vec2.normalize(v1)
    local d = v1:dist()
    if d> 0 then
      return getVec2(v1.x/d,v1.y/d)
    else
      return getVec2(0,0)
    end
  end

  function vec2.normal(v1)
    return getVec2(-v1.y ,v1.x)
  end

  function vec2.left(v1)
    return getVec2(-v1.y ,v1.x)
  end

  function vec2.right(v1)
    return getVec2(v1.y ,-v1.x)
  end
  return vec2
end

local function vec2findIntersect(p,p1,q,q1)
  --https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect

  local r = vec2.minus(p1 ,p  )
  local s = vec2.minus(q1 ,q  )

  --t = (q − p) × s / (r × s)
  --u = (q − p) × r / (r × s)

  local q_p = vec2.minus(q,p)
  local q_pdots = vec2.cross(q_p,s)
  local q_pdotr = vec2.cross(q_p,r)
  local rdots = vec2.cross(r,s)

  --If r × s = 0
  if rdots == 0 then
    return false,false,nil
  end

  local t = q_pdots / rdots
  local u = q_pdotr / rdots

  --if 0 ≤ t ≤ 1 and 0 ≤ u ≤ 1, the two line segments meet at the point p + t r = q + u s.
  if ((t>= 0 ) and (t<=1) and (u>= 0 ) and (u<= 1 )) then
    --p + t * r
    local ret = vec2.mulf(r,t)
    ret = vec2.add(p,ret  )
    return ret.x,ret.y,ret
  end
  return false,false,nil
end

function vector.findIntersect(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y)
  local p = getVec2(l1p1x,l1p1y)
  local p1 = getVec2(l1p2x,l1p2y)
  local q = getVec2(l2p1x,l2p1y)
  local q1 = getVec2(l2p2x,l2p2y)

  return vec2findIntersect(p,p1,q,q1)
end

return vector
