Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.score = 0
    self.dy = 0
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Paddle:update(dt)
    if self.dy < 0 then
        if (self.y + self.dy * dt) < 30 then
            self.y = 31
        else
            self.y = self.y + self.dy * dt
        end
    else
        if(self.y + self.dy * dt) > 165 then
            self.y = 165
        else
            self.y = self.y + self.dy * dt
        end
    end
end