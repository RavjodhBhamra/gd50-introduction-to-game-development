-- Available at https://github.com/kikito/middleclass/
local class = require 'middleclass'

-- Define the Paddle class
local Paddle = class('Paddle')

--[[
    Class constructor
]]
function Paddle:initialize(x, y, width, height, dy)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

--[[
    Setter methods to uptade paddle's position
]]
function Paddle:setX(y)
    self.x = x
end

function Paddle:setY(y)
    self.y = y
end

function Paddle:setDY(dy)
    self.dy = dy
end

--[[
    Update object's behavior
]]
function Paddle:update(screen_height, dt)
    -- Calculate another step into te simulation of where the paddle is gonna be next.
    -- Based on wheter velocity is positive(going down on screen) or negative (going up)
    if self.dy < 0 then
        -- Move the paddle up, until it reaches the top of the screen.
        self:setY(math.max(0, self.y + self.dy * dt))
    else
        -- Move the paddle down, until it reaches the bottom of the screen.
        self:setY(math.min(screen_height - self.height, self.y + self.dy * dt))
    end

end

--[[
    Encapsulate object's drawing
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

return Paddle
