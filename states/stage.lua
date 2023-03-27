Stage = {}

function Stage:load()
    self.bgrimg = love.graphics.newImage("assets/bgr1.png")
    self.darkScreen = love.graphics.newImage("assets/blackScreen.png")
    self.title = love.graphics.newImage("assets/title.png")
    self.instructions = love.graphics.newImage("assets/instructions.png")
    self.over = love.graphics.newImage("assets/over.png")
end

function Stage:update(dt)
    
end

function Stage:draw()
    if Game.state == "play"then
        love.graphics.setColor(0.6, 0.6, 0.6, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    if Player.ultimate == 1 and Game.state=="play" then
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
    end
    love.graphics.draw(self.bgrimg, 0, 0)
    if Game.state == "theme" then
        love.graphics.setColor(1,1,1,(1/(1+Game.timer)))
        love.graphics.draw(self.darkScreen, 0, 0)
        love.graphics.setColor(1,1,1,0.3*Game.timer)
        love.graphics.draw(self.title, 0, 0)
        love.graphics.setColor(1,1,1,1)
    elseif Game.state == "menu" then
        love.graphics.draw(self.title, 0, 0)
    elseif Game.state == "help" then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(self.instructions, 0, 0)
    elseif Game.state == "over" then
        sounds.bgm:stop()
        sounds.gameOver:play()
        local font = love.graphics.newFont(40)
        love.graphics.setColor(1,1,1,0.7)
        love.graphics.draw(self.over, 0, 0)
        love.graphics.setFont(font)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print("SCORE : "..math.ceil(Player.score), 490, 300)
    end
    
end

return Stage