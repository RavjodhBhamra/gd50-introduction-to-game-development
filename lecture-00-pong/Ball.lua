local class = require 'middleclass'

-- Define the Ball class
local Ball = class('Ball')

local BALL_SPEED = 100

--[[
    Class constructor
]]
function Ball:initialize(screen_width, screen_height, width, height)

    -- Create ball stopped at the center of the screen
    self.x0 = screen_width / 2 - width / 2
    self.y0 = screen_height / 2 - height / 2
    self.x = self.x0
    self.y = self.y0
    self.dx = 0
    self.dy = 0

    self.width = width
    self.height = height
end

--[[
    Setter methods to uptade ball's position
]]
function Ball:setX(x)
    self.x = x
end

function Ball:setY(y)
    self.y = y
end

function Ball:setDX(dx)
    self.dx = dx
end

function Ball:setDY(dy)
    self.dy = dy
end

--[[
    Set ball to its initial position
]]
function Ball:resetBall()
    self:setX(self.x0)
    self:setY(self.y0)

    -- Get new speed directions
    self:setRandomSpeed()
end

--[[
    Attribute to the ball speed random speed directions
]]
function Ball:setRandomSpeed()
    -- Set speed on X-axis randomly as '+' or '-' the value of 'BALL_SPEED'.
    self:setDX(math.random(2) == 1 and BALL_SPEED or -BALL_SPEED)

    -- Set speed on Y-axis to be, on module, lower than on the X-axis.
    --   This creates the effect of throwing the ball at the players direction.
    self:setDY(math.random(-BALL_SPEED * 0.7, BALL_SPEED * 0.7))
end

return Ball
