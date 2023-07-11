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