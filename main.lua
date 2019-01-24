
local wf =        require 'windfield'
local asteroids = require 'asteroids'
local graphics =  require 'graphics'
local sounds =    require 'sounds'

local world
local explosion
local thrust
local stars

local GameOverPic


function love.load()
    GameOverPic = love.graphics.newImage("graphics/GameOver.png")
    GameOver = false
    score = 0  
    sounds.loadSounds()
    
    world = asteroids.createWorld(wf)
    asteroids.createPlayer()
    for nr = 1,5 do
      asteroids.createBox()
    end
  
   
    --setup the ParticleField for explosion display
    explosion = graphics.createExplosion()
    thrust = graphics.createThrust()
    stars = graphics.createStars()
    
  end -- load()

function love.update(dt)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
 
  if not GameOver then 
    world:update(dt)
    explosion:update(dt)
    thrust:update(dt)
    stars:update(dt)
 
  asteroids.detectCollisions(graphics) 
  asteroids.addNewBlock()
  --addNewEnemy()    
  asteroids.addNewBonus()
 end
 
  asteroids.keyboardControl(graphics)
  asteroids.removeShoots()
  asteroids.checkBonusLifeSpan()
  asteroids.keepObjectsInView() 
  
end --update()

function love.draw()
    world:draw() 
    if GameOver == true then
      love.graphics.draw(GameOverPic,300,200)
    end
    love.graphics.draw(explosion,asteroids.getExplosionPos())
    love.graphics.draw(thrust,player:getX()+math.sin(player:getAngle()+math.pi)*13,player:getY()+math.cos(player:getAngle()+math.pi)*-13)
    if asteroids.bonusExists() then
      love.graphics.draw(stars,bonus:getX(),bonus:getY())
    end
    love.graphics.print("Score : "..score,10,10,0,1.5,1.5)
end  --draw()



