sounds = {}

function sounds.loadSounds()
    explosionSound = love.audio.newSource("sounds/Explosion.mp3", "static")
    explosionSound:setVolume(0.7)
    fireSound = love.audio.newSource("sounds/Fire 1.mp3", "static")
    fireSound:setVolume(0.1)
    playerExpSound = love.audio.newSource("sounds/explosion-Ship.wav", "static")
    playerExpSound:setVolume(0.7)
    tataSound = love.audio.newSource("sounds/tada.mp3", "static")
    tataSound:setVolume(0.7)
  end
  
  return sounds
