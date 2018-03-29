Player = GameObject:extend()

function Player:new(area, x, y, opts)
  Player.super.new(self, area, x, y, opts)

  self.x, self.y = x, y
  self.w, self.h = 12, 12
  self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
  self.collider:setObject(self)

  self.r = -math.pi/2
  self.rv = 1.66*math.pi
  self.vx = 0
  self.vy = 0
  self.max_v = 100

  self.run_a = 100
  self.stop_a = 1000
end

function Player:destroy()
  Player.super.destroy(self)
end

function Player:update(dt)
  Player.super.update(self, dt)

  self.vx = 0
  self.vy = 0

  -- if input:down('left') then self.vx = self.vx - dt * (self.vx > 0 and self.stop_a or self.run_a) end
  -- if input:down('right') then self.vx = self.vx + dt * (self.vx < 0 and self.stop_a or self.run_a) end
  -- if input:down('up') then self.vy = self.vy - dt * (self.vy > 0 and self.stop_a or self.run_a) end
  -- if input:down('down') then self.vy = self.vy + dt * (self.vy < 0 and self.stop_a or self.run_a) end

  local left = input:down('left')
  local right = input:down('right')
  local up = input:down('up')
  local down = input:down('down')

  if left then self.vx = -100 end
  if right then self.vx = 100 end
  if up then self.vy = -100 end
  if down then self.vy = 100 end

  if (left and right) then self.vx = 0
  elseif (up and down) then self.vy = 0
  elseif (left or right) and (up or down) then
    self.vx = 0.7071 * self.vx
    self.vy = 0.7071 * self.vy
  end

  self.collider:setLinearVelocity(self.vx, self.vy)
end

function Player:draw()
  love.graphics.setColor(224, 0, 0, 255)
  love.graphics.circle('line', self.x, self.y, self.w)
  -- position B that is distance units away from position A such that position B is positioned at
  -- a specific angle in relation to position A, the pattern is something like:
  -- bx = ax + distance*math.cos(angle)
  -- by = ay + distance*math.sin(angle).
  self.r = math.atan2((love.mouse.getY() - self.y * gscale), (love.mouse.getX() - self.x * gscale))
  love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))

  love.graphics.setColor(255, 255, 255, 255)
end
