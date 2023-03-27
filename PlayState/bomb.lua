Bomb = {}

local img = {}
img['blueclock'] = {skin=love.graphics.newImage("assets/blue_clock.png"), height = 0, width = 0}
img['clock'] = {skin=love.graphics.newImage("assets/clock.png"), height = 0, width = 0}
for key, val in pairs(img)do
    val.height = val.skin:getHeight()
    val.width = val.skin:getWidth()
end

function Bomb:load()
    local Bomb_CD = 3
    self.x = 0
    self.y = 0
    self.radius = 90

    self.state = -1
    self.timer = 0
end

function Bomb:update(dt)
    self.timer = self.timer + dt
    if self.state == -1 then 
        if self.timer > 2 then
            self.timer = 0
            self.state = 0
        end
    elseif self.state == 0 then
        if(love.keyboard.isDown("q"))then
            self.state = 1
            self.timer = 0
            self.x = Player.x
            self.y = Player.y
        end
    elseif self.state == 1 then
        if self.timer > 3 then
            self.timer = 0
            self.state = 2
        end
    elseif self.state == 2 then
        if self.timer > 5 then 
            self.timer = 0
            self.state = -1
        end
    end
end

function Bomb:draw()
    if(self.state >= 1)then
        sounds.ticktock1:play()
        local param = self.timer%1
        love.graphics.setColor(1,1,1,1)
        love.graphics.circle("line", self.x, self.y, 40*(self.timer%1))
        love.graphics.setColor(0.7, 0.5+2*param, param, 0.2+param/2)
        love.graphics.draw(img["clock"].skin , self.x, self.y, 3*param, 0.1, 0.1, img["clock"].height/2, img["clock"].width/2)
    end
    if(self.state==2)then
        sounds.ticktock1:stop()
        sounds.bell_clock:play()
        local param = self.timer%1
        love.graphics.setColor(0.7, 0.5+2*param, param, 0.2+param/2)
        love.graphics.draw(img["clock"].skin , self.x, self.y, -3*param, 0.1, 0.1, img["clock"].height/2, img["clock"].width/2)
        love.graphics.setColor(param, 2*param, 1, 0.2+param/2)
        love.graphics.draw(img["blueclock"].skin , self.x, self.y, 3*param, 0.2, 0.2, img["blueclock"].height/2, img["blueclock"].width/2)
        love.graphics.setColor(0.7, 1, param, 0.2+self.timer%2)
        love.graphics.circle("line", self.x, self.y, self.radius*(0.3+self.timer)%2)
    else
        sounds.bell_clock:stop()
    end
end

return Bomb