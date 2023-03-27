Planet = function(x, y, radius, type)
    local GRAVITY = 50;
    local img = love.graphics.newImage("assets/planet.png")
    local width = img:getWidth()
    local height = img:getHeight()
    return{
        type = type or 0,
        radius = radius or 10,
        field = 5*radius,
        x = x,
        y = y,
        normalAngle = 0,
        draw = function(self)
            love.graphics.setColor(0.65, 0.45, 0.18)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(0.8, 0.9, 1.0)
            if type == 0 then
                love.graphics.setColor(1,1,1,1)
            elseif type == 1 then
                love.graphics.setColor(1,0,0,1)
            elseif type == 2 then
                love.graphics.setColor(0,0.4,0.3,1)
            end
            love.graphics.draw(img, self.x, self.y, 0, 0.1, 0.1, height/2, width/2)
        end,
        update = function(self, dt)
            self.normalAngle = math.atan2(self.x - Player.x, Player.y - self.y)
            local dist = calculateDistance(self.x, self.y, Player.x, Player.y)
            if dist < self.field then
                Player.x = Player.x + GRAVITY*math.cos(self.normalAngle)/(dist-1)
                Player.y = Player.y + GRAVITY*math.sin(self.normalAngle)/(dist-1)
            end
            self.normalAngle = math.atan2(self.x - Player2.x, Player2.y - self.y)
            local dist = calculateDistance(self.x, self.y, Player2.x, Player2.y)
            if dist < self.field then
                Player2.x = Player2.x + GRAVITY*math.cos(self.normalAngle)/(dist-1)
                Player2.y = Player2.y + GRAVITY*math.sin(self.normalAngle)/(dist-1)
            end
        end
    }
end

return Planet