require("PlayState/player")
require("PlayState/player2")
require("PlayState/bomb")
local Enemy = require("PlayState/enemy")
local enemyTimer = 0
local asteroidTimer = 0
local Portal = require("PlayState/portal")
local Planet = require("PlayState/planet")
local Asteroid = require("PlayState/asteroid")

Playstate = {}

function Playstate:load()
    Player:load()
    Player2:load()
    Portal:load()
    Bomb:load()
    enemies= {}
    asteroids = {}
    planets = {}
    table.insert(enemies, Enemy(math.floor(math.random(love.graphics.getWidth())), math.floor(math.random(love.graphics.getHeight()))))
    table.insert(enemies, Enemy(math.floor(math.random(love.graphics.getWidth())), math.floor(math.random(love.graphics.getHeight()))))
    maxEnemies = 4

    table.insert(planets, Planet(500, 500, 30))
    table.insert(planets, Planet(1200, 0, 50, 1))
    table.insert(planets, Planet(1180, 700, 30, 2))
end

function Playstate:update(dt)
    maxEnemies = 4 +math.ceil(Player.score/200)
    maxAsteroids = 1 + math.ceil(Player.score/400)
    sounds.bgm:play()
    enemyTimer = enemyTimer + dt
    asteroidTimer = asteroidTimer + dt
    Player:update(dt)
    Player2:update(dt)
    if Player.ultimate == 1 then
        dt = dt*0.5
    end
    Portal:update(dt)
    Bomb:update(dt)
    for key, val in pairs(planets)do
        val:update(dt)
    end
    for key, val in pairs(enemies)do
        if Player.ultimate then
            val:update(dt)
        else
            val:update(dt)
        end
        if val.exploding == 2 then
            table.remove(enemies, key)
        end
    end
    for key, val in pairs(asteroids)do
        val:update(dt)
        if val.exploding == 2 then
            table.remove(asteroids, key)
        end
    end

    if (enemyTimer > 10)then
        enemyTimer = 0
        if(#enemies < maxEnemies)then
            table.insert(enemies, Enemy(math.floor(math.random(love.graphics.getWidth())), math.floor(math.random(love.graphics.getHeight()))))
        end
    end
    if (asteroidTimer > 3)then
        asteroidTimer = 0
        table.insert(asteroids, Asteroid(20+math.random(love.graphics.getWidth()-40), -50-math.random(200), math.pi*(5/3 - math.random(60)/6)))
        local dice = math.random(maxAsteroids)
        for i =1, dice do
            table.insert(asteroids, Asteroid(20+math.random(love.graphics.getWidth()-40), -50-math.random(500), math.pi*(5/3 - math.random(60)/6), math.random()))
        end
    end
end

function Playstate:draw()
    for key, val in pairs(planets)do
        val:draw()
    end
    Player:draw()
    Player2:draw()
    Portal:draw()
    if Player.ultimate == 1 then
        love.graphics.setColor(1, 0, 0, 1)
    end
    for key, val in pairs(enemies)do
        val:draw()
    end
    for key, val in pairs(lasers)do
        val:draw()
    end
    for key, val in pairs(asteroids)do
        val:draw()
    end
end

return Playstate