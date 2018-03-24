Object = require 'libraries/classic/classic'

Circle = require 'objects/Circle'
HyperCircle = require 'objects/HyperCircle'

function love.load()
  image = love.graphics.newImage('resources/sprites/ball.png')
  circle = HyperCircle(400, 300, 50, 5, 300)
end

function love.update(dt)
  circle:update(dt)
end

function love.draw()
  love.graphics.draw(image, love.math.random(0, 800), love.math.random(0, 600))
  circle:draw()
end
