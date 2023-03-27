function Asteroid (x, y, angle, timeOffset)
    local ASTEROID_VELOCITY = 500
    local LIFETIME = 15
    local EXPLODE_DUR = 1
    local DAMAGE = 30
    local SPAWNTIME = 2
    local img = love.graphics.newImage("assets/asteroid.png")
    local height = img:getHeight()
    local width = img:getWidth()
    return{
        x=x,
        y=y,
        virtualX = x,
        virtualY = y,
        angle = angle,
        timeOffset = timeOffset or 0,
        xVel = ASTEROID_VELOCITY*math.cos(angle) + 2*ASTEROID_VELOCITY/5*math.random(),
        yVel = ASTEROID_VELOCITY*math.sin(angle) + 2*ASTEROID_VELOCITY/5*math.random(),
        exploding  = -1,
        explodeTimer = 0,
        movingTimer = 0,
        frozen = 0,
        radius = 30,
        draw = function(self)
            love.graphics.setColor(1,1,1,0.3)
            love.graphics.draw(img, self.virtualX, self.virtualY, 0, 0.5, 0.5, height/2, width/2)
            if self.exploding == 0 then
                love.graphics.setColor(1,1,1,1)
                --love.graphics.circle("line", self.x, self.y, self.radius)
                love.graphics.draw(img, self.x, self.y, self.angle, 0.5, 0.5, height/2, width/2)
            elseif self.exploding == 1 then
                love.graphics.setColor(1,self.explodeTimer, 0, 1/(0.1+ self.explodeTimer))
                love.graphics.circle("fill", self.x, self.y, 10 + 20*self.explodeTimer)
            end
        end,
        update = function(self, dt)
            self.movingTimer = self.movingTimer + dt
            if Bomb.state == 2 then
                if calculateDistance(self.x, self.y, Bomb.x, Bomb.y)< self.radius + Bomb.radius then
                    self.frozen = 1
                end
            elseif self.frozen == 1 then
                self.frozen = 0
            end
            if self.exploding == 0 and self.frozen == 0 then
                if Player.ultimate == 0 then
                    self:hurtPlayer(dt)
                    self.x=self.x + self.xVel*dt
                    self.y=self.y + self.yVel*dt
                else
                    self.x=self.x - self.xVel*dt
                    self.y=self.y - self.yVel*dt    
                end
            elseif self.exploding == -1 then
                if self.movingTimer > SPAWNTIME + self.timeOffset  then
                    self.exploding = 0
                    self.movingTimer = 0
                end
            elseif self.exploding == 1 then
                self.explodeTimer = self.explodeTimer + dt
                if self.explodeTimer > EXPLODE_DUR then
                    self.exploding = 2
                end
            end
            if self.movingTimer > LIFETIME then
                self.exploding = 2
            end
            self.virtualX = self.virtualX + self.xVel*2*dt
            self.virtualY = self.virtualY + self.yVel*2*dt
        end,
        hurtPlayer = function(self, dt)
            if calculateDistance(self.x, self.y, Player.x, Player.y)< Player.radius + self.radius then
                self.exploding = 1
                Player:takeDamage(self.damage)
            end
            if calculateDistance(self.x, self.y, Player2.x, Player2.y)< Player2.radius + self.radius then
                self.exploding = 1
                Player2:takeDamage(self.damage)
            end
        end
    }
end

return Asteroid