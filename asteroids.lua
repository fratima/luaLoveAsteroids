-- Asteroid Functions
 
asteroids = {}
local world = {}
local player = {}
local enemy = {}
local bonus
local boxes = {}
local shots = {}
local boxTime = 5 -- initial number of seconds before a net block is spawned
local bonusLifeSpan = 20
local lastTimeofEnemyCreation = love.timer.getTime()
local lastTimeofBonusCreation = love.timer.getTime()
local enemyExists = false
local explosionPosx
local explosionPosY
local bonusExists = false

  
  function asteroids.createWorld(wf)
    world = wf.newWorld(0, 0,true)
    world:setGravity(0, 0)
    world:addCollisionClass('Box')
    world:addCollisionClass('Shot')
    world:addCollisionClass('Player', {ignores = {'Shot'}})
    world:addCollisionClass('Enemy', {ignores = {'Box'}})
    world:addCollisionClass('Bonus', {ignores = {'Box'}})
    return world
  end
  
  function asteroids.createPlayer()
    local spaceShip={0,-10,5,10,0,0,-5,10,0,-10}  
    player =  world:newPolygonCollider(spaceShip)
    player:setX(400)
    player:setY(300)
    player:setCollisionClass('Player')
    return player
  end
  
  --the enemy should cross the screen and shoot the player
  function asteroids.createEnemy()
    if not enemyExists then
      local enemyShip={-10,0,-7,-5,7,-5,10,0,-15,0,-10,10,10,10,15,0}  
      enemy = world:newPolygonCollider(enemyShip)
      enemy:setCollisionClass('Enemy')
      local x,y = getSpawnArea(player:getX(),player:getY(), 350)
      enemy:setX(400)
      enemy:setY(400)
      enemy:applyLinearImpulse(love.math.random(-20,20),love.math.random(-20,20))
      lastTimeofEnemyCreation = love.timer.getTime()
      enemyExists = true
      return enemy
    end
  end
  
  
  function asteroids.removeEnemy()
     if enemyExists and
        enemy:getX() < 0 or enemy:getX() > love.graphics.getWidth() or 
        enemy:getY() < 0 or enemy:getY() > love.graphics.getHeight() 
        then
        enemy:destroy()
        enemyExists = false
     end
   end
   
  
  function asteroids.createBox()
    local x,y = asteroids.getSpawnArea(player:getX(),player:getY(), 350)
    local box = world:newRectangleCollider( x, y, 50, 50)
    box:setRestitution(0.9)
    box:applyAngularImpulse(love.math.random(-6000,6000))
    box:applyLinearImpulse(love.math.random(-300,300),love.math.random(-300,300))
    box:setCollisionClass('Box')
    table.insert(boxes, box)
    lastTimeofBoxCreation = love.timer.getTime()
  end
   
  function asteroids.createBonus()
     if not bonusExists then
     local x,y = asteroids.getSpawnArea(player:getX(),player:getY(),200)
     local bonus = world:newBSGRectangleCollider(x, y, 10, 10, 4)
     bonus:setCollisionClass('Bonus')
     lastTimeofBonusCreation = love.timer.getTime()
     bonusExists = true
    end
  end
  
    
   
  function asteroids.keyboardControl(graphics)
  -- KEYBOARD    
    if love.keyboard.isDown("up") then 
      player:applyLinearImpulse(math.sin(player:getAngle())*0.5,math.cos(player:getAngle())*-0.5) 
      graphics.startThrust()
      end
    if love.keyboard.isDown("right") then player:applyAngularImpulse(0.5,1) end
    if love.keyboard.isDown("left") then player:applyAngularImpulse(-0.5,1) end
    if love.keyboard.isDown("escape") then os.exit() end 
    if love.keyboard.isDown("space") then -- Shoot
      if table.getn(shots) < 1 then  -- limit number of shots
        asteroids.createShot(player:getAngle())
      end
    end
  end
   
   
   function asteroids.createShot(angle)
      local shot = world:newCircleCollider(player:getX() + math.sin(angle)*20,player:getY() + math.cos(angle)*-20 ,3)
      shot.cTime = love.timer.getTime()
      shot:setMass(1)
      shot:applyLinearImpulse(math.sin(angle)*800,math.cos(angle)*-800)
      fireSound:play()
      shot:setCollisionClass('Shot')  
      table.insert(shots,shot)
    end
    
  function asteroids.removeShoots()  
-- remove Shoots
    for i,lshot in pairs(shots) do
      if love.timer.getTime() >= lshot.cTime + 0.5 then  --limit shot life time 
        table.remove(shots,i)
        lshot:destroy() 
      end
    end 
  end
  
  function asteroids.checkBonusLifeSpan()
    if bonusExists then
      if love.timer.getTime() >= lastTimeofBonusCreation + bonusLifeSpan then  --limit shot life time 
        asteroids.removeBonus()
      end
    end
  end
  
  
  function asteroids.removeBonus()  
        bonus:destroy() 
        bonusExists = false
  end
  
  function asteroids.bonusExists()
    return bonusExists
  end
  
  
  function asteroids.addNewBlock()
   -- add new blocks after 5 seconds
   if lastTimeofBoxCreation + boxTime < love.timer.getTime() then
     asteroids.createBox()
   end
  end
   
   function asteroids.addNewEnemy()
     if lastTimeofEnemyCreation + 10 < love.timer.getTime() then
        asteroids.createEnemy()
     end
   end
    
  function asteroids.addNewBonus()
    if not bonusExits then
      if lastTimeofBonusCreation + bonusLifeSpan + 10 < love.timer.getTime() then
      asteroids.createBonus()
    end
    end
  end
  
  function asteroids.keepObjectsInView()  
   asteroids.keepInView(player)
   if bonusExists then asteroids.keepInView(bonus) end
   for _,box in pairs(boxes) do
      asteroids.keepInView(box)
   end
  end
  
  function asteroids.keepInView(object)
     if object:getX() < 0   then object:setX(800) end
     if object:getX() > 800 then object:setX(0)   end
     if object:getY() < 0   then object:setY(600) end
     if object:getY() > 600 then object:setY(0)   end
  end

  function asteroids.detectCollisions(graphics)
  -- Box trifft Spieler
    if player:enter('Box') then
      playerExpSound:play()
      GameOver = true
    end
  -- Schuss trifft Box  
    for i,box in pairs(boxes) do
      if box:enter('Shot') then
        explosionSound:play()
        explosionPosX = box:getX()
        explosionPosY = box:getY()
        graphics.startExplosion()
        table.remove(boxes,i)
        box:destroy()
        score = score + 1
        if boxTime > 1.5 then 
          boxTime = boxTime - 0.1 -- speed up new spawning of boxes number 
        end
      end
    end 
    -- Player gets Bonus
    if player:enter('Bonus') then
        score = score + 20
        asteroids.removeBonus()
        tataSound :play()
    end
  end
  
  function asteroids.getExplosionPos()
    return explosionPosX, explosionPosY
  end
  
  --spawn not too close to player
  function asteroids.getSpawnArea(x,y, radius)
    local newX
    local newY
    repeat
        newX = love.math.random(0,love.graphics.getWidth())
        newY = love.math.random(0,love.graphics.getHeight())
      	local dx, dy = math.abs(newX - x) , math.abs(newY - y)
    until ((dx * dx + dy * dy) >= radius * radius)
    --assert(math.abs(newX - x) >= radius,math.abs(newX - x) .." >= ".. radius)
    return newX, newY  
  end
  
 
return asteroids

