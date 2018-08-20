local class = require 'middleclass'

-- Define the Ball class
local Ball = class('Ball')

--[[
    Class constructor
]]
function Ball:initialize(screen_width, screen_height, width, height)

    -- Generate a new seed to work with the pseudo number generator
    math.randomseed(os.time())

    -- Randomize the ball's position os screen
    self.x = math.random(150, screen_width - 150)
    self.y = math.random(50, screen_height - 30)
    self.width = width
    self.height = height
end

--[[
    Update Ball's coordinates
]]
function Ball:updatePos(x, y)
    self.x = x
    self.y = y
end

return Ball
