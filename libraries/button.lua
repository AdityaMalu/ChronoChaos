function Button(text, toState, x, y, width, height, font)
    local yOffset = 10
    return{
        text=text,
        x=x or love.graphics.getWidth()/2,
        y=y or love.graphics.getHeight()/2,
        width = width or 100,
        height = height or 40,
        color={0.4, 0.4, 0.7 ,1},
        font = font or 15,
        margin = 10,
        toState = toState,
        hot = false,
        setButtonColor = function(self, r, g, b)
            self.color={r,g,b,1}
        end,
        draw = function(self)
            love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.color[4])
            if(self.hot)then
                love.graphics.setColor(0.7, 1.0, 0.6, 0.8)
            end
            love.graphics.rectangle("fill", self.x-self.width/2, self.y-self.height/2, self.width, self.height)
            love.graphics.setColor(1,1,1,1)
            font = love.graphics.newFont(self.font)
            love.graphics.setFont(font)
            love.graphics.printf(text, self.x - self.width/2, self.y - self.margin, self.width, "center")
        end,
        onClick = function(self)
            Game.state = self.toState
        end,
        hoverMouse = function(self, mouse_x, mouse_y)
            if(mouse_x < self.x + self.width and mouse_x > self.x - self.width)then
                if(mouse_y < self.y + self.height and mouse_y > self.y  - self.height)then
                    return true
                else 
                    return false
                end
            else
                return false
            end
        end
    }
end

return Button