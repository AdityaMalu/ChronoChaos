local Bullet = require("PlayState/bullet")
Player2 = {}

function Player2:load()
    local SHIP_SIZE = 30
    self.MAX_BULLETS = 5
    self.img = love.graphics.newImage("assets/whitewing.png")
    self.x = love.graphics.getWidth()/2 + 100
    self.y = love.graphics.getHeight()/2
    self.radius = SHIP_SIZE/2
    self.angle = 0
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
    self.firing = 0
    self.fireTimer = 0

    self.bullets = {}
end

function Player2:update(dt)
    if self.thrusting then
        self.flames:update(dt)
    end
    if self.health.current <= 0 then
        Game.state = "over"
    end
    local friction = 10
    local rotation = 2*math.pi*dt
    if Player.ultimate == 1 then
        self:move(0.5*dt)
    else
        self:move(dt)
    end
    self.score = self.score + 0.1*dt
    for key, val in pairs(self.bullets) do
        val:update(dt)
        if val.exploding == 2 then
            table.remove(self.bullets, key)
        end
    end
end

function Player2:move(dt)
    local friction = 0.7
    self.rotation = 2*math.pi*dt
    if(love.keyboard.isDown("left"))then
        self.angle=self.angle+self.rotation
    end
    if(love.keyboard.isDown("right"))then
        self.angle=self.angle-self.rotation
    end
    if(love.keyboard.isDown("down"))then
        self:shoot(dt)
    end
    if(love.keyboard.isDown("up"))then
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

    --have to multiply by dt here
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

function Player2:takeDamage(d)
    d=d or 10
    self.health.current = self.health.current - d
    sounds.blip:play()
end

function Player2:teleport(x, y)
    self.x  = x
    self.y = y
end

function Player2:draw()
    for key, val in pairs(self.bullets) do
        val:draw()
    end
    love.graphics.setColor(1,1,1,1)
    if self.thrusting then
        self.flames:draw(self.spriteSheet, self.x, self.y,  5/2*math.pi  - self.angle, 1, 1, 1.8*self.radius, -0.7*self.radius)
    end
    love.graphics.draw(self.img, self.x, self.y, 2*math.pi - self.angle, 1, 1, 2*self.radius, 2*self.radius)
end

function Player2:shoot(dt)
    if #self.bullets < 5 and self.firing == 0 then
        table.insert(self.bullets, Bullet(self.x, self.y, -self.angle))
        self.firing = 1
    end
    if self.firing == 1 then
        self.fireTimer = self.fireTimer + dt
        if(self.fireTimer > 0.1)then
            self.fireTimer = 0
            self.firing = 0
        end
    end
end

return Player2