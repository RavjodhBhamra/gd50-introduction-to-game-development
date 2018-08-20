local class = require 'middleclass'

-- Define the Paddle class
local Paddle = class('Paddle')

--[[
    Class constructor
]]
function Paddle:initialize(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

--[[
    Setter methods to uptade paddle's coordinates
]]
function Paddle:setX(y)
    self.x = x
end

function Paddle:setY(y)
    self.y = y
end

return Paddle
