class = require 'middleclass'

local GameState = class('GameState')

function GameState:initialize(initialState)
    self.state = initialState
end

function GameState:setState(newState)
    self.state = newState
end

function GameState:getState()
    return self.state
end

return GameState
