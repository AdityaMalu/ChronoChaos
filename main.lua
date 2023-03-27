require("globals")
require("states/gamestate")
require("states/playstate")
local GUI = require("states/gui")
anim8 = require("libraries/anim8")

function love.load()
    clickedMouse = False
    Playstate:load()
    GUI:load()
    Game:load()
end

function love.update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    Game:update(dt)
    if Game.state == "play" then
        Playstate:update(dt)
        GUI:update(dt)
        clickedMouse = False
    end
end

function love.draw()
    Game:draw()
    if Game.state == "play" then
        Playstate:draw()
        Bomb:draw()
        GUI:draw()
    end
end

function love.keypressed(key)
    if(key=='escape')then
        sounds.ticktock1:stop()
        sounds.ticktock2:stop()
        sounds.timeTravel:stop()
        sounds.bell_clock:stop()
        if(Game.state == "over")then
            love.load()
        end
        Game.state = "menu"
    end
    if(key=='z')then
        Game.state = "play"
    end
end

function love.mousepressed(x, y, mousebutton, istouch, presses)
    if mousebutton == 1 then
        clickedMouse = true
    end
end