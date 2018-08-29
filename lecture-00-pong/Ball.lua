-- Available at https://github.com/kikito/middleclass/
local class = require 'middleclass'

-- Define the Ball class
local Ball = class('Ball')

--[[
    Class constructor
]]
function Ball:initialize(x, y, width, height)
    self.x0 = x
    self.y0 = y
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- Set speed on X-axis randomly as '+' or '-' the value of 'BALL_SPEED'.
    self.dx = math.random(2) == 1 and BALL_SPEED or -BALL_SPEED
    -- Set speed on Y-axis to be, on module, lower than on the X-axis.
    -- It creates the effect of throwing the ball at the players direction.
    self.dy = math.random(-BALL_SPEED * 0.7, BALL_SPEED * 0.7)
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
function Ball:resetPosition()
    self:setX(self.x0)
    self:setY(self.y0)

    -- Get new speed directions
    self:setDX(math.random(2) == 1 and BALL_SPEED or -BALL_SPEED)
    self:setDY(math.random(-BALL_SPEED * 0.7, BALL_SPEED * 0.7))
end

--[[
    Update object's behavior
]]
function Ball:update(dt)
    self:setX(self.x + self.dx * dt)
    self:setY(self.y + self.dy * dt)
end

--[[
    Encapsulate object's drawing
]]
function Ball:render(rgba)
    love.graphics.setColor(rgba[1], rgba[2], rgba[3], rgba[4])
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

--[[
    Check colision with a paddle object via AABB
]]
function Ball:checkColision(paddle)
    --[[
        Logical decomposition of how the 4 checks on AABB works:

        Colision formula        : Colision?
        A + B + C + D           = true
        ¬(¬(A + B + C + D))     = true
        ¬(¬(A + B) * ¬(C + D))  = true
        ¬(¬A * ¬B * ¬C * ¬D)    = true
        ¬A * ¬B * ¬C * ¬D       = false

        We can subtitute 1 big 'if' check, with an 'AND' condition (A+B+C+D), by
        inverting the logical proposition and check 4 'OR' conditions separatedly.
    ]]

    -- Check wheter a colision have NOT happened on the X-axis.
    if self.x + self.width < paddle.x or self.x > paddle.x + paddle.width then
        return false
    -- Check wheter a colision have NOT happened on the Y-axis.
    elseif self.y + self.height < paddle.y or self.y > paddle.y + paddle.height then
        return false
    -- Detect colision by exclusion.
    else
        return true
    end
end

return Ball
