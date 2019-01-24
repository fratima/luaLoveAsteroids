	
  graphics = {}
  local explosion
  local thrust
  local stars
  
  function graphics.createExplosion()
    local img = love.graphics.newImage('graphics/dot.png')
    explosion = love.graphics.newParticleSystem(img, 320)
    explosion:setParticleLifetime(0.5, 1) -- Particles live at least 2s and at most 5s.
    explosion:setLinearAcceleration(-300, -300, 300, 300) -- Randomized movement towards the bottom of the screen.
    explosion:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
    explosion:setSpin(20, 50)
    return explosion
  end
  
  function graphics.startExplosion()
    explosion:emit(320)
  end
  
  function graphics.createThrust()
    local img = love.graphics.newImage('graphics/thrust.bmp')
    thrust = love.graphics.newParticleSystem(img, 30)
    thrust:setParticleLifetime(0.2, 0.8) -- Particles live at least 2s and at most 5s.
    thrust:setLinearAcceleration(-40, -40, 40, 40) -- Randomized movement towards the bottom of the screen.
    thrust:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
    thrust:setSpin(20, 50)
    return thrust
  end
  
  function graphics.startThrust()
    thrust:emit(30)
  end
  
  
  function graphics.createStars()
    local img = love.graphics.newImage('graphics/star.png')
    stars = love.graphics.newParticleSystem(img, 30)
    stars:setParticleLifetime(0.2, 1) -- Particles live at least 2s and at most 5s.
    stars:setEmissionRate(15)
	  stars:setSizeVariation(1)  
    stars:setLinearAcceleration(-70, -70, 70, 70) -- Randomized movement towards the bottom of the screen.
    stars:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
    stars:setSpin(20, 30)
    return stars
  end
  
  return graphics
  
  