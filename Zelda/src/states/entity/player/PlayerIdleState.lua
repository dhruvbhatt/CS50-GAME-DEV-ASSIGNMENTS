--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') and not potcarry then
        self.entity:changeState('swing-sword')
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') and potcarry then
        startx=self.entity.x
        starty=self.entity.y
        pot_direction=self.entity.direction
        throw=true
        potcarry=false
        self.entity:changeState('idle')
    end
end