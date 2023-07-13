push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 180

PADDLE_SPEED = 200

playerServe = 1



function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Huy's Pong Game")

    math.randomseed(os.time())

    superSmallFont = love.graphics.newFont('font.ttf', 7)
    smallFont = love.graphics.newFont('font.ttf', 10)
    mediumFont = love.graphics.newFont('font.ttf', 16)
    bigFont = love.graphics.newFont('font.ttf', 32)

    gameState = 'startState'

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['victory_sound'] = love.audio.newSource('sounds/victorySound.wav', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1 = Paddle(12, 97, 3, 15)
    player2 = Paddle(VIRTUAL_WIDTH - 14, 97, 3, 15)
    ball = Ball(159, 105, 2)

    

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then--tại sao khi để enter thì nó không được mà để return thì nó lại okla ?
        if gameState == 'playState' then
            gameState = 'serveState'
        elseif gameState == 'serveState' then
            gameState = 'startState'
        elseif gameState == 'winState' then
            gameState = 'startState'
            player1.score = 0
            player2.score = 0
        else
            gameState = 'playState'
        end
    end
end

function love.update(dt)

    if gameState == 'serveState' then
        ball:update(dt)
        --reflect for the two width
        if (ball.y + ball.dy * dt) < 31 or (ball.y + ball.dy * dt) > 178 then
            sounds['wall_hit']:play()
            ball.dy = -ball.dy
        end

        --the case that the ball is outside the height border
        if ball.x < 0 or ball.x > 320 then
            sounds['score']:play()
            if playerServe == 1 then
                player1.score = player1.score + 1
                playerServe = 2
            else
                player2.score = player2.score + 1
                playerServe = 1

            end
            gameState = 'playState'
            ball:resetLocation()
            ball:hostControl(playerServe)
            
        end

        --winer state
        if player1.score == 9 or player2.score == 9 then
            gameState = 'winState'
            sounds['victory_sound']:play()
        end

        --reflect for the paddle
        if ball:isCollide(player1) then
            sounds['paddle_hit']:play()
            playerServe = 1
            ball.dx = -ball.dx * 1.1
            if ball.dy > 0 then
                ball.dy = math.random(10,150)
            else 
                ball.dy = -math.random(10, 150)
            end
        end

        if ball:isCollide(player2) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx * 1.1
            playerServe = 2
            if ball.dy > 0 then
                ball.dy = math.random(10,150)
            else 
                ball.dy = -math.random(10, 150)
            end
        end
    elseif gameState == 'playState' then
        if player1.dy ~= 0 or player2.dy ~= 0 then --add function that when paddle moves, it automatically transfer into play state
            gameState = 'serveState'
        end
    else 
        ball:resetLocation()
        ball:resetSetup()
    end
        
    --velocity for player1
    if love.keyboard.isDown('w') then 
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    --velocity for player2
    if love.keyboard.isDown('up') then 
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)
    
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    --draw the field
    drawFiled()
    displayScore()

    love.graphics.setFont(smallFont)
    love.graphics.print('State: '..gameState, 10, 10)

    player1:render()
    player2:render()
    ball:render()

    if gameState == 'winState' then
        displayWinScreen()
    end

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

    -- love.graphics.rectangle('fill', 10, 30, 1, 65)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 30, 1, 65)
    -- love.graphics.rectangle('fill', 10, 115, 1, 65)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 115, 1, 65)
    -- --draw two dot
    -- love.graphics.rectangle('fill', 10, 105, 1, 1)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, 105, 1, 1)
end

function displayScore()
    love.graphics.setFont(bigFont)
    love.graphics.print(tostring(player1.score), VIRTUAL_WIDTH / 2 - 30, 2)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 7, 15, 10, 2)
    love.graphics.print(tostring(player2.score), VIRTUAL_WIDTH / 2 + 10, 2)
    
end

function displayWinScreen()
    local x = 85
    local y = 70
    local width = 150
    local height = 80
    love.graphics.setColor(117/255, 117/255, 117/255)  
    love.graphics.rectangle("fill", x, y, width, height) 

    love.graphics.setColor(255/255, 255/255, 180/255) 

    love.graphics.setFont(mediumFont)
    local text2 = 'Congratulation!!!'

    local text2X = x + (width - mediumFont:getWidth(text2)) / 2 -- Tính toán vị trí X cho chữ
    local text2Y = y + (height - mediumFont:getHeight()) / 2 - 15 -- Tính toán vị trí Y cho chữ

    love.graphics.print(text2, text2X, text2Y)

    love.graphics.setFont(smallFont)
    local text = 'Player '..playerServe..' win'
    local textX = x + (width - smallFont:getWidth(text)) / 2 -- Tính toán vị trí X cho chữ
    local textY = y + (height - smallFont:getHeight()) / 2

    love.graphics.print(text, textX, textY)

    love.graphics.setFont(superSmallFont)
    local text3 = 'Enter to continue'
    local text3X = x + (width - superSmallFont:getWidth(text3)) / 2
    local text3Y = y + (height - superSmallFont:getHeight()) / 2 + 10

    love.graphics.print(text3, text3X, text3Y)

end




