local Laser = require("PlayState/laser2")

local img = love.graphics.newImage("assets/normal.png")
-- local img = love.graphics.newImage("assets/ship1.png")
local IMG_WIDTH = img:getWidth()
local IMG_HEIGHT = img:getHeight()
local EXPLODE_DUR = 1

function Enemy(x, y)
    local SPEEDX = math.random(20)
    local SPEEDY = math.random(20)
    local SHIP_SIZE = 40
    lasers = {}
    return{
        x=x,
        y=y,
        radius = SHIP_SIZE / 2,
        xVel = SPEEDX,
        yVel = SPEEDY,
        laserTimer = 0,
        lasers=lasers,
        exploding = 0,
        explodeTimer = 0,
        frozen = 0,
        draw = function(self)
            if self.exploding == 0 then 
                love.graphics.setColor(1,1,1,1)
                if Player.ultimate == 1 then
                    love.graphics.setColor(1, 0.5, 0.5, 1)
                end
                if self.frozen == 1 then
                    love.graphics.setColor(Bomb.timer%1, 1, (Bomb.timer*2)%1)
                end
                love.graphics.draw(img, self.x, self.y, self.angle, 1, 1, IMG_WIDTH/2, IMG_HEIGHT/2)
                for key, val in pairs(self.lasers)do
                    val:draw()
                end
            elseif self.exploding == 1 then
                love.graphics.setColor(1,self.explodeTimer, 0, 1/(0.1+ self.explodeTimer))
                love.graphics.circle("fill", self.x, self.y, 10 + 20*self.explodeTimer)
            end
        end,
        update = function(self, dt)
            if self.exploding == 0 then
                if Bomb.state == 2 then
                    if calculateDistance(self.x, self.y, Bomb.x, Bomb.y)<self.radius + Bomb.radius then
                        self.frozen = 1
                    end
                elseif self.frozen == 1 then
                    self.frozen = 0
                end
                if self.frozen == 0 then
                    self:move(dt)
                    self:shoot(dt)
                end
                for key, val in pairs(self.lasers)do
                    if val.exploding == 2 then
                        table.remove(self.lasers, key)
                        Player.score = Player.score + 10
                    end
                    val:update(dt)
                end
            elseif self.exploding == 1 then
                self.explodeTimer = self.explodeTimer + dt
                if self.explodeTimer > EXPLODE_DUR then
                    self.exploding = 2
                end
            end
        end,
        move = function(self, dt)
            if Player.ultimate == 1 then
                self.x = self.x - self.xVel*dt
                self.y = self.y - self.yVel*dt
            else
                self.x = self.x + self.xVel*dt
                self.y = self.y + self.yVel*dt
            end
            if (self.x + self.radius < 0)then
                self.x = love.graphics.getWidth() + self.radius
            end
            if(self.x - self.radius > love.graphics.getWidth()) then
                self.x=0-self.radius
            end
            if(self.y+self.radius<0)then
                self.y = love.graphics.getHeight()+self.radius
            end
            if(self.y - self.radius > love.graphics.getHeight())then
                self.y = -self.radius
            end
        end,
        shoot = function(self, dt)
            self.laserTimer = self.laserTimer + dt
            if self.laserTimer > 5 then
                self.laserTimer = 0
                local rand = math.random()
                if rand>0.5 then
                    table.insert(self.lasers, Laser(self.x, self.y, math.atan2(Player2.y - self.y, Player2.x - self.x)))
                else
                    table.insert(self.lasers, Laser(self.x, self.y, math.atan2(Player.y - self.y, Player.x - self.x)))
                end
            end
        end
    }
end

return Enemy