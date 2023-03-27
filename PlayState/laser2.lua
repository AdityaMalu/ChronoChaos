function Laser2(x, y, angle)
    local LASER2_SPEED = 400
    local LASER2_DAMAGE = 5
    local EXPLODE_DURATION = 0.7
    local img = love.graphics.newImage("assets/snowflake.png")
    local snowwidth = img:getWidth()
    local snowheight = img:getHeight()
    return {
        x=x,
        y=y,
        angle=angle,
        xVel = LASER2_SPEED*math.cos(angle),
        yVel = LASER2_SPEED*math.sin(angle),
        damage = LASER2_DAMAGE, 

        exploding = 0, 
        explodeTimer = 0,
        frozen  = 0,
        spawnTimer = 0,
        draw = function(self)
            if self.exploding == 0 then
                love.graphics.setColor(1,1,1,1)
                love.graphics.circle("line", self.x, self.y, 8)
                love.graphics.setColor(0.7, 0.85, 1, 0.8)
                love.graphics.circle("fill", self.x, self.y, 7)
                --love.graphics.draw(img, self.x-snowwidth/2, self.y-snowheight/2)
            else
                love.graphics.setColor(0.8,0.9,1,1-self.explodeTimer)
                love.graphics.circle("fill", self.x, self.y, 5+20*self.explodeTimer)
            end
        end,
        update = function(self, dt)
            if Player.ultimate == 0 then
                self.spawnTimer = self.spawnTimer + dt
            else 
                self.spawnTimer = self.spawnTimer - dt
                if self.spawnTimer < 0 then
                    self.exploding = 2
                end
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
                self:hurtPlayer(dt)
            elseif self.exploding == 1 then
                self.explodeTimer = self.explodeTimer + dt
                if self.explodeTimer > EXPLODE_DURATION then
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
        hurtPlayer = function(self, dt)
            if calculateDistance(self.x, self.y, Player.x, Player.y)<Player.radius then
                self.exploding = 1
                Player.slow = true
                Player:takeDamage(self.damage)
            end
            if calculateDistance(self.x, self.y, Player2.x, Player2.y)<Player2.radius then
                self.exploding = 1
                Player2.slow = true
                Player2:takeDamage(self.damage)
            end
        end
    }
end

return Laser2