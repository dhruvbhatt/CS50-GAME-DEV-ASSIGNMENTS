PotPickUpState = Class{__includes = BaseState}
 
function PotPickUpState:init(player,room)
 	self.player = player
	self.room=room
  
   self.player.offsetY = 5
   self.player.offsetX = 0
   
  local direction = self.player.direction
    
    --later for colision if required

    -- local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    -- if direction == 'left' then
    --     hitboxWidth = 8
    --     hitboxHeight = 16
    --     hitboxX = self.player.x - hitboxWidth
    --     hitboxY = self.player.y + 2
    -- elseif direction == 'right' then
    --     hitboxWidth = 8
    --     hitboxHeight = 16
    --     hitboxX = self.player.x + self.player.width
    --     hitboxY = self.player.y + 2
    -- elseif direction == 'up' then
    --     hitboxWidth = 16
    --     hitboxHeight = 8
    --     hitboxX = self.player.x
    --     hitboxY = self.player.y - hitboxHeight
    -- else
    --     hitboxWidth = 16
    --     hitboxHeight = 8
    --     hitboxX = self.player.x
    --     hitboxY = self.player.y + self.player.height
    -- end

    -- self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('pot-' .. self.player.direction)
    --'..' is catenation operator
end

function PotPickUpState:enter(params)
	
    --self.player.currentAnimation:refresh()
end

function PotPickUpState:update(dt)
    -- check if hitbox collides with any entities in the scene
	
	  if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')


    end
end


function PotPickUpState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
    
  
    --debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHitbox.x, self.swordHitbox.y, self.swordHitbox.width, self.swordHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end