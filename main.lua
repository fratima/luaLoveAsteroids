wf = require 'windfield'
require 'asteroids'
require 'graphics'
require 'sounds'

function love.load()
    GameOverPic = love.graphics.newImage("graphics/GameOver.png")
    GameOver = false
    score = 0
    boxTime = 5 -- initial number of seconds before a net block is spawned
    bonusLifeSpan = 20
    boxes = {}
    shots = {}
    
    loadSounds()
    
    createWorld()
    createPlayer()
    for nr = 1,5 do
      createBox()
    end
    -- although no enemy was created yet the timer is set because I don't want to start with enemies
    lastTimeofEnemyCreation = love.timer.getTime()
    enemyExists = false
    lastTimeofBonusCreation = love.timer.getTime()
    bonusExists = false
    
    --setup the ParticleField for explosion display
    createExplosion()
    explosionPosX = 0
    explosionPosY = 0
    createThrust()
    createStars()
    
    
  end -- load()

function love.update(dt)
  if not GameOver then 
    world:update(dt)
    explosion:update(dt)
    thrust:update(dt)
    stars:update(dt)
 
   detectCollisions() 
  addNewBlock()
  --addNewEnemy()    
  addNewBonus()
 end
 
  keyboardControl()
  removeShoots()
  removeBonus()
  keepObjectsInView() 
  
end --update()

function love.draw()
    world:draw() 
    if GameOver == true then
      love.graphics.draw(GameOverPic,300,200)
    end
    love.graphics.draw(explosion,explosionPosX,explosionPosY)
    love.graphics.draw(thrust,player:getX()+math.sin(player:getAngle()+math.pi)*13,player:getY()+math.cos(player:getAngle()+math.pi)*-13)
    if bonusExists then
      love.graphics.draw(stars,bonus:getX(),bonus:getY())
    end
    love.graphics.print("Score : "..score,10,10,0,1.5,1.5)
end  --draw()



