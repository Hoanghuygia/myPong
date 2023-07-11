push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

PADDLE_SPEED = 200



function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Huy's Pong Game")

    math.randomseed(os.time())

    -- smallFont = love.graphics.newFont('font.tft', 8)
    -- mediumFont = love.graphics.newFont('font.tft', 16)
    -- BigFont = love.graphics.newFont('font.tft', 32)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1 = Paddle(12, 97, 3, 15)
    player2 = Paddle(VIRTUAL_WIDTH - 14, 97, 3, 15)
    ball = Ball(159, 105, 2)

end

function love.update()

end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    --draw the field
    drawFiled()

    -- love.graphics.printf('Hello Pong', 0, 120, WINDOW_WIDTH, 'center')

    player1:render()
    player2:render()
    ball:render()

    push:apply('end')

end

function drawFiled()
     --the first two width
    love.graphics.rectangle('fill', 0, 30, 1, 150)
    love.graphics.rectangle('fill', 319, 30, 1, 150)

    --the two height
    love.graphics.rectangle('fill', 0, 30, 320, 1)
    love.graphics.rectangle('fill', 0, 179, 320, 1)

    --draw the middle lưới
    for initial_value = 35, 243, 5 do
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, initial_value, 1, 2)
    end

    love.graphics.rectangle('fill', 10, 30, 1, 65)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 30, 1, 65)
    love.graphics.rectangle('fill', 10, 115, 1, 65)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 115, 1, 65)
    love.graphics.rectangle('fill', 10, 105, 1, 1)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 105, 1, 1)
end




