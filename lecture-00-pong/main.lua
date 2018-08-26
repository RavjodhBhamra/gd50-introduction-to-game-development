--[[

  Pong Game

  Author: Caio Guimaraes - @guimaraescca

  Game developed based on the class examples for the course 'CS50 - Introduction
  to Game Development'.

]]


-- Third party libraries
-- Available at https://github.com/Ulydev/push
push = require 'push'

-- Local files
Ball = require 'Ball'
Paddle = require 'Paddle'
GameState = require 'GameState'


-- Global constants
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 480
VIRTUAL_HEIGHT = 240

PADDLE_SPEED = 200
BALL_SPEED = 1000
BALL_SPEED_MUL = 1.10

COLOR = {['white'] = {1, 1, 1, 1},
         ['white_snow'] = {172/255, 190/255, 216/255, 1},
         ['dark_blue'] = {18/255, 20/255, 32/255, 1},
         ['gray'] = {223/255, 248/255, 235/255, 1},
         ['orange'] = {0/255, 166/255, 251/255, 1},
         ['blue'] = {241/255, 80/255, 37/255, 1}}


--[[
    Startup function, initialize execution of the game.
        Can set variables to be used in other functions ('love.draw', etc).
]]
function love.load(arg)

    -- Start a new random seed
    math.randomseed(os.time())

    -- Set a nearest-neighbor filter to upscale and downscale the screen,
    -- removes the blurriness from the default one.
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Create a table to store fonts with fixed sizes as immutable objects
    font = {}
    font[16] = love.graphics.newFont('PressStart2P.ttf', 8)
    font[32] = love.graphics.newFont('PressStart2P.ttf', 24)

    -- Setup a screen using a virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        vsync=true,
        resizable=false}
    )

    -- Set window title
    love.window.setTitle('Pong Game!')

    -- Start players' score count
    player1Score = 0
    player2Score = 0

    -- Start player's win and serve count (ie: Who starts with the ball)
    servingPlayer = 0
    winningPlayer = 0

    -- Create the players' paddle
    player1 = Paddle:new(10, VIRTUAL_HEIGHT / 2 - 10, 5, 20, 200)
    player2 = Paddle:new(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT / 2 - 10, 5, 20, 200)

    -- Create a ball object
    ball = Ball:new(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Create a state machine for the game
    gameState = GameState:new('menu')
end

--[[
    Updates the game state for each frame.
        dt: time elapsed since the last frame in seconds.
]]
function love.update(dt)

    -- Capture keyboard inputs for Player 1
    if love.keyboard.isDown('w') then
        player1:setDY(-PADDLE_SPEED)
    elseif love.keyboard.isDown('s') then
        player1:setDY(PADDLE_SPEED)
    else
        player1:setDY(0)
    end

    -- Capture keyboard inputs for Player 2
    if love.keyboard.isDown('up') then
        player2:setDY(-PADDLE_SPEED)
    elseif love.keyboard.isDown('down') then
        player2:setDY(PADDLE_SPEED)
    else
        player2:setDY(0)
    end

    -- Process 'SERVE' state
    if gameState:getState() == 'serve' then

        -- Direct the ball at the player who's serving
        if servingPlayer == 1 then
            ball:setDX(-BALL_SPEED)
        else
            ball:setDX(BALL_SPEED)
        end
        ball:setDY(math.random(-BALL_SPEED * 0.7, BALL_SPEED * 0.7))

    -- Process 'WIN' state
    elseif gameState:getState() == 'win' then
        player1Score = 0
        player2Score = 0

    -- Process 'PLAY' state
    elseif gameState:getState() == 'play' then
        ball:update(dt)

        -- Check colision with the left paddle
        if ball:checkColision(player1) then
            ball:setX(player1.x + player1.width)
            ball:setDX(-ball.dx * BALL_SPEED_MUL)

            -- Randomize speed on Y-axis after a colision
            if ball.dy < 0 then
                ball:setDY(math.random(-100, -10))
            else
                ball:setDY(math.random(10, 100))
            end

        -- Check colision with the right paddle
        elseif ball:checkColision(player2) then
            ball:setX(player2.x - ball.width)
            ball:setDX(-ball.dx * BALL_SPEED_MUL)

            -- Randomize speed on Y-axis after a colision
            if ball.dy < 0 then
                ball:setDY(math.random(-100, -10))
            else
                ball:setDY(math.random(10, 100))
            end
        end

        -- Check colision with the upper and lower boundaries and reflect the ball
        if ball.y <= 0 then
            ball:setY(0)
            ball:setDY(-ball.dy)
        elseif ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball:setY(VIRTUAL_HEIGHT - ball.height)
            ball:setDY(-ball.dy)
        end

        -- Check colision with the screen sides and update the score
        if ball.x <= 0 then
            -- Update player 2 score and set player 1 as server
            player2Score = player2Score + 1
            servingPlayer = 1

            -- Check to see if player 2 won the game
            if player2Score == 10 then
                winningPlayer = 2
                gameState:setState('win')
            else
                ball:resetPosition()
                gameState:setState('serve')
            end

        elseif ball.x >= VIRTUAL_WIDTH - ball.width then
            -- Update player 1 score and set player 2 as server
            player1Score = player1Score + 1
            servingPlayer = 2

            -- Check to see if player 1 won the game
            if player1Score == 10 then
                winningPlayer = 1
                gameState:setState('win')
            else
                ball:resetPosition()
                gameState:setState('serve')
            end
        end
    end

    player1:update(VIRTUAL_HEIGHT, dt)
    player2:update(VIRTUAL_HEIGHT, dt)

end

--[[
    Draw content on screen after the update for each frame.
]]
function love.draw()

    -- Use 'push' to render in the virtual resolution
    push:apply('start')

    -- Clear the screen with solid a color.
    -- An indentical function call is made before the 'love.draw()' execution
    love.graphics.clear(unpack(COLOR['dark_blue']))

    if gameState:getState() == 'menu' then
        renderText(font[32], COLOR['gray'], 'PONG!', 0, 10, VIRTUAL_WIDTH, 'center')
        renderText(font[16], COLOR['gray'], 'Press \'ENTER\' to start!', 0, 40, VIRTUAL_WIDTH, 'center')

    elseif gameState:getState() == 'serve' then
        if servingPlayer == 1 then
            renderText(font[32], COLOR['gray'], 'PONG!', 0, 10, VIRTUAL_WIDTH, 'center')
            renderText(font[16], COLOR['gray'], 'Player 2 scores! Player 1 serves', 0, 40, VIRTUAL_WIDTH, 'center')
        else
            renderText(font[32], COLOR['gray'], 'PONG!', 0, 10, VIRTUAL_WIDTH, 'center')
            renderText(font[16], COLOR['gray'], 'Player 1 scores! Player 2 serves', 0, 40, VIRTUAL_WIDTH, 'center')
        end

    elseif gameState:getState() == 'play' then
        -- Draw game score
        renderText(font[32], COLOR['orange'], tostring(player1Score) , 0, 10, VIRTUAL_WIDTH / 2 - 5, 'right')
        renderText(font[32], COLOR['blue'], tostring(player2Score), 5 + VIRTUAL_WIDTH / 2, 10, VIRTUAL_WIDTH, 'left')

    elseif gameState:getState() == 'win' then
        -- Draw winner's name on screen
        if winningPlayer == 1 then
            renderText(font[32],  COLOR['orange'], 'Player 1 won!', 0, 10, VIRTUAL_WIDTH, 'center')
            renderText(font[16], COLOR['gray'], 'You are the PONG master!', 0, 40, VIRTUAL_WIDTH, 'center')
        else
            renderText(font[32],  COLOR['blue'], 'Player 2 won!', 0, 10, VIRTUAL_WIDTH, 'center')
            renderText(font[16], COLOR['gray'], 'You are the PONG master!', 0, 40, VIRTUAL_WIDTH, 'center')
        end
    end

    -- Draw FPS text notification
    renderText(font[16], COLOR['white_snow'], 'FPS: ' .. tostring(love.timer.getFPS()), 0, 0, 100)

    -- Draw ball info
    renderText(font[16], COLOR['white_snow'], 'ball dx: ' .. tostring(ball.dx), 0, 10, 300, 'left')
    renderText(font[16], COLOR['white_snow'], 'ball dy: ' .. tostring(ball.dy), 0, 20, 300, 'left')

    -- Draw ball and paddles on screen
    love.graphics.setColor(unpack(COLOR['white']))
    ball:render()
    love.graphics.setColor(unpack(COLOR['orange']))
    player1:render()
    love.graphics.setColor(unpack(COLOR['blue']))
    player2:render()

    -- Finish rendering in the virtual resolution
    push:apply('end')
end

--[[
    Handles keyboard inputs by calling it for each frame.
]]
function love.keypressed(key)

    -- Quit the application
    if key == 'escape' then
        love.event.quit()

    -- Start game or return to menu
    elseif key == 'return' or key == 'kpenter' then

        if gameState:getState() == 'menu' or 'serve' then
            gameState:setState('play')

        elseif gameState:getState() == 'play' then
            gameState:setState('menu')
            ball:resetPosition()

        elseif gameState:getState() == 'win' then
            gameState:setState('menu')
            ball:resetPosition()
        end
    end
end

function renderText(font, rgba, text, x, y, limit, align)
    love.graphics.setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    love.graphics.setFont(font)
    love.graphics.printf(text, x, y, limit, align)
end
