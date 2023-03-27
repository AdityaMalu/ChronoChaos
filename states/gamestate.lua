Game = {}
local Stage = require("states/stage")
local Menu = require("states/menu")
sounds={}
sounds.bgm = love.audio.newSource("sounds/bgm.wav", "stream")
sounds.bgm:setLooping(true)
sounds.gameOver = love.audio.newSource("sounds/game_over.wav", "stream")
sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
sounds.laugh = love.audio.newSource("sounds/laugh.mp3", "static")
sounds.ticktock1 = love.audio.newSource("sounds/ticktock1.mp3", "static")
sounds.bell_clock = love.audio.newSource("sounds/bell_clock.mp3", "static")
sounds.ticktock2 = love.audio.newSource("sounds/ticktock2.mp3", "static")
sounds.timeTravel = love.audio.newSource("sounds/timeTravel.mp3", "static")

function Game:load()
    self.state = "theme"
    self.timer = 0
    Stage:load()
    Menu:load()
end

function Game:update(dt)
    if(self.state=="theme")then
        self.timer = self.timer + dt
        if(self.timer > 2)then
            self.state = "menu"
        end
    elseif self.state == "menu" then
        sounds.bgm:stop()
        Menu:update()
    elseif self.state == "quit" then
        love.event.quit()
    end
end

function Game:draw()
    Stage:draw()
    if self.state == "menu" then
        Menu:draw()
    end
end

return Game
