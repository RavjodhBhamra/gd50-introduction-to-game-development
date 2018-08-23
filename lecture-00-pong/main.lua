--[[

  Pong game

]]


-- Third party libraries
-- Available at https://github.com/Ulydev/push
push = require 'push'

-- Local files
Ball = require 'Ball'
Paddle = require 'Paddle'
GameState = require 'GameState'

-- Constants for window size
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 480
VIRTUAL_HEIGHT = 240

PADDLE_SPEED = 200


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
    font[16] = love.graphics.newFont('PixelOperatorSC.ttf', 16)
    font[32] = love.graphics.newFont('PixelOperatorSC.ttf', 32)

    -- Setup a screen using a virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        vsync=true,
        resizable=false}
    )

    -- Start players' score count
    player1Score = 0
    player2Score = 0

    -- Create the players' paddle
    player1 = Paddle:new(10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    player2 = Paddle:new(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT / 2 - 10, 5, 20)

    -- Create a ball object
    ball = Ball:new(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 4, 4)
    ball:setRandomSpeed()

    -- Create a state machine for the game
    gameState = GameState:new('menu')

end

--[[
    Updates the game state for each frame.
        dt: time elapsed since the last frame in seconds.
]]
function love.update(dt)

    -- Check game state and update it
    current_state = gameState:getState()

    if current_state == 'menu' then

        -- Reset ball's position and set a random speed direction to it.


    elseif current_state == 'play' then

        -- Update ball's position on screen
        ball:setX(ball.x + ball.dx * dt)
        ball:setY(ball.y + ball.dy * dt)

        -- Capture keyboard inputs for Player 1
        if love.keyboard.isDown('w') then
            -- Move the paddle up, until it reaches the top of the screen.
            player1:setY(math.max(0, player1.y - PADDLE_SPEED * dt))

        elseif love.keyboard.isDown('s') then
            -- Move the paddle down, until it reaches the bottom of the screen.
            player1:setY(math.min(VIRTUAL_HEIGHT - player1.height, player1.y + PADDLE_SPEED * dt))
        end

        -- Capture keyboard inputs for Player 2
        if love.keyboard.isDown('up') then
            -- Move the paddle up, until it reaches the top of the screen.
            player2:setY(math.max(0, player2.y - PADDLE_SPEED * dt))

        elseif love.keyboard.isDown('down') then
            -- Move the paddle down, until it reaches the bottom of the screen.
            player2:setY(math.min(VIRTUAL_HEIGHT - player2.height, player2.y + PADDLE_SPEED * dt))
        end
    end
end

--[[
    Draw content on screen after the update for each frame.
]]
function love.draw()

    -- Use 'push' to render in the virtual resolution
    push:apply('start')

    -- Clear the screen with solid a color.
    -- An indentical function call is made before the 'love.draw()' execution
    love.graphics.clear(.15, .17, .19, 1)

    -- Text box goes in x from '0' to 'WINDOW_WIDTH', center aligned;
    -- in y we subtract half the size (12/2) of the default font to center.
    love.graphics.setFont(font[32])
    love.graphics.printf('PONG!', 0, 0, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(font[16])
    love.graphics.printf('Player 1: ' .. tostring(player1Score) ..
        ' Player 2: ' .. tostring(player2Score), 0, 30, VIRTUAL_WIDTH, 'center')

    -- Draw the paddles
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)

    -- Draw the ball on screen
    love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)

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
    elseif key == 'return' then

        if gameState:getState() == 'menu' then
            gameState:setState('play')

        elseif gameState:getState() == ('play' or 'win') then
            gameState:setState('menu')
            ball:resetPosition()

        end
    end
end
