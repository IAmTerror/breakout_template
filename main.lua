--Author :
--+-+-+-+-+-+-+-+-+-+
--|I|A|m|T|e|r|r|o|r|
--+-+-+-+-+-+-+-+-+-+

-- Inspired by : https://www.gamecodeur.fr --- https://www.gamecodeur.fr/liste-ateliers/atelier-casse-brique/


-- CONFIG -------------------------------------------------------------------------------------------------------------

-- This line is used to display traces in the console during the execution
io.stdout:setvbuf('no')

-- This line is used to debug step by step in ZeroBrane Studio
if arg[#arg] == "-debug" then require("mobdebug").start() end


-- VARIABLES ----------------------------------------------------------------------------------------------------------

local pad = {} 
pad.x = 0
pad.y = 0
pad.width = 80
pad.height = 20
pad.vx = 0
pad.vy = 0

local ball = {}
ball.x = 0
ball.y = 0
ball.radius = 10
ball.glue = false
ball.vx = 0
ball.vy = 0

local brick = {}

local level = {}


-- FUNCTIONS ----------------------------------------------------------------------------------------------------------

function initPlayground()
  ball.glue = true
  
  level = {}
  local l,c
  
  for l=1,8 do
    level[l] = {}
    for c=1,15 do
      level[l][c] = 1
    end
  end
end

function kickOff()
  ball.glue = false
  ball.vx = 400
  ball.vy = -400
end

function brickColorizer(l)
  if l < 3 then
    love.graphics.setColor(1,0,0)
  end
  if l >= 3 and l < 5 then
    love.graphics.setColor(1,165/255,0)
  end
  if l >= 5 and l < 7 then
    love.graphics.setColor(1,1,0)
  end
  if l >= 7 then
    love.graphics.setColor(0,128/255,0)
  end
end

function screenCollision()
  --- ball collision test with the right edge of the screen
  if ball.x > width then
    ball.vx = 0 - ball.vx
    ball.x = width
  end
  --- ball collision test with the left edge of the screen
  if ball.x < 0 then
    ball.vx = 0 - ball.vx
    ball.x = 0
  end
  --- ball collision test with the top edge of the screen
  if ball.y < 0 then
    ball.vy = 0 - ball.vy
    ball.y = 0
  end
  --- ball collision test with the bottom edge of the screen
  if ball.y > height then
    ball.glue = true
  end
end


-- LÖVE ---------------------------------------------------------------------------------------------------------------

function love.load()
  
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
  brick.height = 25
  brick.width = width / 15
    
  pad.y = height - (pad.height / 2)
  
  initPlayground()
  
end

function love.update(dt)
  pad.x = love.mouse.getX()
  
  if ball.glue == true then
    ball.x = pad.x
    ball.y = pad.y - pad.height / 2 - ball.radius
  else
    ball.x = ball.x + ball.vx * dt
    ball.y = ball.y + ball.vy * dt
  end
  
  -- ball collision test with a brick
  local c = math.floor(ball.x / brick.width) + 1
  local l = math.floor(ball.y / brick.height) + 1
  
  if l >= 1 and l <= #level and c >=1 and c <=15 then
    if level [l][c] == 1 then
      ball.vy = 0 - ball.vy
      level[l][c] = 0
    end
  end
  
  screenCollision()
  
  -- ball collision test of the ball with the top edge of the pad
  local posCollisionPad = pad.y - (pad.height / 2) - ball.radius
  if ball.y > posCollisionPad then
    local dist = math.abs(pad.x - ball.x)
    if dist < pad.width / 2 then
      ball.vy = 0 - ball.vy
      ball.y = posCollisionPad
    end
  end
end

function love.draw()
  love.graphics.setColor(0, 0, 102/255)
  love.graphics.rectangle("fill", pad.x -(pad.width / 2), pad.y - (pad.height / 2), pad.width, pad.height)
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", ball.x, ball.y, ball.radius)
  
  local l,c
  local bx, by = 0, 0
  for l=1,8 do
    brickColorizer(l)
    bx = 0
    for c=1,15 do
      if level[l][c] == 1 then
      
        love.graphics.rectangle("fill", bx + 1, by + 1, brick.width - 2, brick.height - 2)
      end
      bx = bx + brick.width
    end
    by = by + brick.height
  end
end


-- CONTROLS -----------------------------------------------------------------------------------------------------------

function love.mousepressed(x, y, n)
  if ball.glue == true then
    kickOff()
  end
end


function love.keypressed(key)
  if key == "space" then
    kickOff()
  end
  print(key)
end
