GUI = {}

function GUI:load()
    self.font = love.graphics.newFont(30)

    self.clockSpriteSheet = love.graphics.newImage("assets/hourglass.png")
    self.grid = anim8.newGrid(64, 64, self.clockSpriteSheet:getWidth(), self.clockSpriteSheet:getHeight())
    self.animations = {}
    self.animations.hourglass = anim8.newAnimation(self.grid(1, '1-4'), 0.2)

    self.cosmetics = {}
    self.cosmetics.timeBomb = {skin = love.graphics.newImage("assets/bomb.png"), height = 0, width = 0}
    self.cosmetics.portal = {skin = love.graphics.newImage("assets/por.png"), height = 0, width = 0}
    for key, val in pairs(self.cosmetics) do
        val.height = val.skin:getHeight()
        val.width = val.skin:getWidth()
    end
    self.BombTimer = 0
end

function GUI:update(dt)
    self.animations.hourglass:update(dt)
    if Bomb.state == 0 then
        self.BombTimer = self.BombTimer + dt
        if self.BombTimer > 10 then
            self.BombTimer = 0
        end
    end
end

function GUI:draw()
    self:healthBar()
    self:drawScore()
    self:ultimateAbility()
    self:timeBomb()
    self:portal()
end

function GUI:healthBar()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", 1000-5, 50, Player.health.max*2.5 + 10, 30)
    love.graphics.setColor(0.5,1,0.5,1)
    love.graphics.rectangle("fill", 1000, 50 + 5, Player.health.current*2.5 , 20)
    love.graphics.setColor(1,1,1,1)
    --love.graphics.print(Player.timeGlass, 900, 40)
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("fill", 50-5, 50, Player2.health.max*2.5 + 10, 30)
    love.graphics.setColor(0.5,1,0.5,1)
    love.graphics.rectangle("fill", 50, 50 + 5, Player2.health.current*2.5 , 20)
    love.graphics.setColor(1,1,1,1)
end

function GUI:drawScore()
    love.graphics.setFont(self.font)
    local TEXT_MASK_OFFSET = 2
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print("SCORE : "..math.ceil(Player.score), 600, 50-TEXT_MASK_OFFSET)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("SCORE : "..math.ceil(Player.score), 600, 50)
end

function GUI:ultimateAbility()
    if(Player.ultimate == 0)then
        love.graphics.setColor(0.1, 1, 0.1, 0.6)
    else
        love.graphics.setColor(1, 1, 1, 0.5)
    end
    love.graphics.circle("fill", 100+64, 550+64, 70)
    self.animations.hourglass:draw(self.clockSpriteSheet, 100, 550, nil, 2, 2)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("line", 100+64, 550+64, 71)
    love.graphics.setColor(1, 1, 1, 1)
end

function GUI:timeBomb()
    local x = 70
    local y = 440
    if(Bomb.state == 0)then
        love.graphics.setColor(0.1, 1, 0.1, 0.6)
    else
        love.graphics.setColor(1,1,1,0.5)
    end
    love.graphics.circle("fill", x, y, 50)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("line", x, y, 51)
    love.graphics.draw(self.cosmetics.timeBomb.skin, x, y, 0, 0.1, 0.1,self.cosmetics.timeBomb.height/2, self.cosmetics.timeBomb.width/2)
    love.graphics.setColor(1, 1, 1, 1)
end

function GUI:portal()
    local x = 1150
    local y = 600
    if(Portal.state == 0)then
        love.graphics.setColor(0.1, 1, 0.1, 0.6)
    else
        love.graphics.setColor(1,1,1,0.5)
    end
    love.graphics.circle("fill", x, y, 50)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("line", x, y, 51)
    love.graphics.draw(self.cosmetics.portal.skin, x, y, 0, 0.05, 0.05,self.cosmetics.portal.height/2, self.cosmetics.portal.width/2)
    love.graphics.setColor(1, 1, 1, 1)
end

return GUI