Ball = Class{}

function Ball:init(x, y, radius)--create ball's constructor
    self.x = x
    self.y = y
    self.radius = radius

    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

function Ball:render()
    love.graphics.circle("fill", self.x, self.y, self.radius, 1000)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:resetLocation()
    self.x = 159
    self.y = 105
end

function Ball:resetSetup()
    self.dy = math.random(2) == 1 and -100 or 100
    self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

function  Ball:hostControl(host)
    self.dy = math.random(2) == 1 and -100 or 100
    if host == 1 then
        self.dx = -math.random(80, 100)
    else
        self.dx = math.random(80, 100)
    end
    
end

function Ball:isCollide(paddle)
    if ((self.x - self.radius) > (paddle.x + paddle.width) or (self.x + self.radius < paddle.x)) then
        return false
    end

    if ((self.y + self.radius < paddle.y) or (self.y - self.radius > paddle.y + paddle.height)) then
        return false
    end

    return true
end