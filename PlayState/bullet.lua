local love = require"love"

function Bullet (x, y, angle)
    local BULLET_SPEED = 500
    local EXPLODE_DURATION = 0.2
    return {
        x=x,
        y=y,
        angle=angle,
        radius = 5,
        xVel = BULLET_SPEED*math.cos(angle),
        yVel = BULLET_SPEED*math.sin(angle),

        exploding = 0,
        explodeTimer = 0,
        frozen = 0,
        spawnTimer = 0,
        draw = function(self)
            if self.exploding == 0 then
                love.graphics.setColor(0.5,1,0.5,1)
                love.graphics.circle("line", self.x, self.y, 5)
                love.graphics.setColor(0.7, 1, 0.9, 0.4)
                love.graphics.circle("fill", self.x, self.y, 4)
            else
                love.graphics.setColor(0.8,0.9,1,1-self.explodeTimer)
                love.graphics.circle("fill", self.x, self.y, 5+20*self.explodeTimer)
            end
        end,
        update = function(self, dt)
            self.spawnTimer = self.spawnTimer + dt
            if self.spawnTimer < 0 then
                self.exploding  = 2
            end
            if Bomb.state == 2 then
                if calculateDistance(self.x, self.y, Bomb.x, Bomb.y)<Bomb.radius then
                    self.frozen = 1
                end
            elseif self.frozen == 1 then
                self.frozen = 0
            end
            if self.exploding == 0 and self.frozen == 0 then
                self:move(dt)
            elseif self.exploding == 1 then
                self.explodeTimer = self.explodeTimer + dt
                if self.explodeTimer > EXPLODE_DURATION then
                    self.exploding = 2
                end
            end
            for key, val in pairs(enemies)do
                if calculateDistance(self.x, self.y, val.x, val.y) < self.radius + val.radius then 
                    self.exploding = 1
                    val.exploding = 1
                end
            end
            for key, val in pairs(asteroids)do
                if calculateDistance(self.x, self.y, val.x, val.y) < self.radius + val.radius then 
                    self.exploding = 1
                    val.exploding = 1
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
            if (self.x < 0)then
                self.exploding = 2
            end
            if(self.x > love.graphics.getWidth()) then
                self.exploding = 2
            end
            if(self.y<0)then
                self.exploding = 2
            end
            if(self.y > love.graphics.getHeight())then
                self.exploding = 2
            end
        end,
    }
end

return Bullet