Player = {}

function Player:load()
    local SHIP_SIZE = 30
    self.img = love.graphics.newImage("assets/ship1.png")
    self.x = love.graphics.getWidth()/2 -100
    self.y = love.graphics.getHeight()/2
    self.radius = SHIP_SIZE/2
    self.angle = math.pi
    self.xVel = 0
    self.yVel = 0
    self.speed = 10
    self.thrusting = false
    self.thrust = {
        x=0,
        y=0,
        speed = 1
    }

    self.health = {
        max = 100, 
        current = 100
    }
    self.score = 0
    self.spriteSheet = love.graphics.newImage("assets/burning_flame.png")
    self.grid = anim8.newGrid(48, 64, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.flames = anim8.newAnimation(self.grid('1-8', 1), 0.2)

    self.ultimate = 0
    self.ultimateTimer = 0
    self.timePositions = {}
    self.timeGlass = 0
end

function Player:update(dt)
    if self.thrusting then
        self.flames:update(dt)
    end
    if self.health.current <= 0 then
        Game.state = "over"
    end
    local friction = 10
    local rotation = 2*math.pi*dt
    self:move(dt)
    self.score = self.score + 0.1*dt

    if self.ultimate == -1 then
        self.ultimateTimer = self.ultimateTimer + dt
        if self.ultimateTimer > 5 then
            self.ultimate = 0
            self.ultimateTimer = 0
        end
    end
    if self.ultimate == 1 then
        self.ultimateTimer = self.ultimateTimer + dt
        self.timeGlass = self.timeGlass + dt
        if self.ultimateTimer > 5 then
            self.ultimateTimer = 0
            self.timeGlass = 0
            self.ultimate = -1
            sounds.ticktock2:stop()
        end
        if self.timeGlass>0.15 then
            self.timeGlass = 0
            table.remove(self.timePositions, 1)
            table.insert(self.timePositions, {x= self.x, y=self.y, angle=self.angle})
        end
    end
end

function Player:activateUltimate()
    if self.ultimate == 0 then
        sounds.timeTravel:play()
        sounds.ticktock2:play()
        self.timePositions = {}
        for i=1, 5 do
            table.insert(self.timePositions, {x= self.x, y=self.y, angle=self.angle})
        end
    end
end

function Player:move(dt)
    local friction = 0.7
    self.rotation = 2*math.pi*dt
    if(love.keyboard.isDown("a"))then
        self.angle=self.angle+self.rotation
    end
    if(love.keyboard.isDown("d"))then
        self.angle=self.angle-self.rotation
    end
    if(love.keyboard.isDown("s"))then
        if self.ultimate == 0 then
            self:activateUltimate()
            self.ultimate = 1
        end
    end
    if(love.keyboard.isDown("w"))then
        self.thrusting=true
    else
        self.thrusting = false
    end
    if self.thrusting and self.xVel + self.yVel < 50 then
        self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle)* dt
        self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle)*dt
    elseif (self.thrust.x ~= 0 or self.thrust.y ~=0) then
        self.thrust.x = self.thrust.x - friction*self.thrust.x*dt
        self.thrust.y = self.thrust.y - friction*self.thrust.y*dt
    end
    self.x = self.x+self.thrust.x
    self.y=self.y+self.thrust.y

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
end

function Player:takeDamage(d)
    d=d or 10
    self.health.current = self.health.current - d
    sounds.blip:play()
end

function Player:teleport(x, y)
    self.x  = x
    self.y = y
end

function Player:draw()
    love.graphics.setColor(1,1,1,1)
    if self.thrusting then
        self.flames:draw(self.spriteSheet, self.x, self.y,  5/2*math.pi  - self.angle, 1, 1, 1.8*self.radius, -0.7*self.radius)
        --self.flames:draw(self.spriteSheet, self.x, self.y,  self.angle-math.pi/2)
    end
    love.graphics.draw(self.img, self.x, self.y, 2*math.pi - self.angle, 1, 1, 2*self.radius, 2*self.radius)
    if self.ultimate == 1 then
        for key, val in pairs(self.timePositions)do
            love.graphics.setColor(1,1,1,0.1*key)
           -- love.graphics.print((val.x or -1)..' '..(val.y or -1), 900, 400+key*20)
            love.graphics.draw(self.img, val.x, val.y, 2*math.pi - val.angle, 1, 1, 2*self.radius, 2*self.radius)
            love.graphics.setColor(1,1,1,1)
        end
    end
end

return Player