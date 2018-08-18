--[[

  Pong game

]]

-- Third party libraries
-- Available at https://github.com/Ulydev/push
push = require 'push'

-- Constants for window size
WINDOW_WIDTH = 1200
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 600
VIRTUAL_HEIGHT = 480


--[[
    Startup function, initialize execution of the game.
        Can set variables to be used in other functions (ie: love.draw).
]]
function love.load(arg)
    -- Configure a virtual resolution for the game independent from the running
    -- machine's resolution.
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
                        fullscreen=false,
                        vsync=true,
                        resizable=true}
    )

    -- Set a nearest-neighbor filter to upscale and downscale the screen,
    -- removes the blurriness from the default filter.
    love.graphics.setDefaultFilter('nearest', 'nearest')
end

--[[
    Updates the game state, called each frame.
        dt: time elapsed since the last frame in seconds
]]
function love.update(dt)

end

--[[
    Draw content on screen after the update for each frame.
]]
function love.draw()
    -- Text box goes in x from '0' to 'WINDOW_WIDTH', center aligned;
    -- in y we subtract half the size (12/2) of the default font to center.
    love.graphics.printf('PONG!', 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, 'center')

end

--[[
    Handles keyboard inputs by calling it for each frame.
]]
function love.keypressed(key)
    if key == 'escape' then
        -- Quit the application
        love.event.quit()
    end
end
