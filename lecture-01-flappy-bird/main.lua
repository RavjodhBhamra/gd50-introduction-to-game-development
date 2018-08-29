--[[

    GD50 - Introduction to Game Development

    Flappy Bird

    Author: Caio Guimaraes (@guimaraescca)

    Game developed based on the class implementation examples in the course.

]]

-- Third party libraries
push = require 'push'

-- Define global constants
WINDOW_WIDTH = 1024
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Load background images
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')


--[[
    Function called at the beggining of LOVE execution.
]]
function love.load()
    -- Remove blurriness
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set window's title
    love.window.setTitle('Flappy Bird')

    -- Setup the game window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen=false,
        vsync=true,
        resizable=true})
end

--[[
    LOVE windows resize callback
]]
function love.resize(width, height)
    push:resize(width, height)
end


--[[
    LOVE render function
]]
function love.draw()
    -- Start rendering the screen to a virtual resolution
    push:start()

    -- Take our drawable image objects and render it on screen
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end


--[[
    LOVE callback to handle key pressed inputs
]]
function love.keypressed(key)
    -- Quit application
    if key == 'escape' then
        love.event.quit()
    end
end
