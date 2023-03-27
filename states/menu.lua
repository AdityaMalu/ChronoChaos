Menu = {}
local Button = require("../libraries/button")
function Menu:load()
    self.buttons={
        Start = Button("PLAY", "play", love.graphics.getWidth()/2, 400, 200, 50), 
        Help = Button("HELP", 'help', love.graphics.getWidth()/2, 500, 200, 50), 
        Quit = Button("QUIT", 'quit', love.graphics.getWidth()/2, 600, 200, 50) 
    }
end

function Menu:update(dt)
    mouseX, mouseY = love.mouse.getPosition()
    for key, value in pairs(self.buttons)do
        if(value:hoverMouse(mouseX, mouseY))then
            value.hot = true
            if(clickedMouse)then
                clickedMouse = false
                Game.state = value.toState
            end
        else
            value.hot = false
        end
    end
end

function Menu:draw()
    for key, value in pairs(self.buttons)do
        value:draw()
    end
end

return Menu