Portal = {}

function Portal:load()
    local PORTAL_CD = 3
    self.entranceX = 100
    self.entranceY = 500
    self.exitX = 700
    self.exitY = 350
    self.width = 20
    self.height = 100

    self.state = -1
    self.timer = 0

    self.spriteSheet = love.graphics.newImage("assets/greenPortal.png")
    self.grid = anim8.newGrid(64, 64, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-8', 1), 0.2)
end

function Portal:update(dt)
    self.animation:update(dt)
    if self.state == -1 or self.state == 2 then
        self.timer = self.timer + dt
    end
    if self.timer > 5 then
        if self.state == -1 then
            self.timer = 0
            self.state = 0
        elseif self.state == 2 then
            self.timer = 0
            self.state = -1
        end
    end
    if clickedMouse and self.state > -1 then
        if self.state == 0 then
            self.timer = 0
            self.state = 1
            self.entranceX = mouseX
            self.entranceY = mouseY
        elseif self.state == 1 then
            self.state = 2
            self.timer = 0
            self.exitX = mouseX
            self.exitY = mouseY
        end
    end
    if self.state == 1 and self.timer < 5 then
        self.timer = self.timer + dt
    end
    if self.state ==2 then
        if Player2.x > self.entranceX and Player2.x < self.entranceX + self.width then
            if Player2.y > self.entranceY and Player2.y < self.entranceY + self.height then
                Player2:teleport(self.exitX, self.exitY)
            end
        end
    end
end

function Portal:draw()
    if(self.state >= 0.5)then
        if self.timer < 0.5 and self.state==1 then
            self.animation:draw(self.spriteSheet, self.entranceX-2*self.width, self.entranceY-self.height/2, 0, 4*self.timer, 6*self.timer)
        else
        --love.graphics.rectangle("line", self.entranceX, self.entranceY, self.width, self.height)
        self.animation:draw(self.spriteSheet, self.entranceX-2*self.width, self.entranceY-self.height/2, 0, 2, 3)
        end   
    end
    if(self.state==2)then
        --love.graphics.rectangle("line", self.exitX, self.exitY, self.width, self.height)
        if self.timer < 0.5 then
            self.animation:draw(self.spriteSheet, self.exitX-2*self.width, self.exitY-self.height/2, 0, 4*self.timer, 6*self.timer)
        else
        --love.graphics.rectangle("line", self.entranceX, self.entranceY, self.width, self.height)
        self.animation:draw(self.spriteSheet, self.exitX-2*self.width, self.exitY-self.height/2, 0, 2, 3)
        end
    end
end

return Portal