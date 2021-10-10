Bird=Class{}
local gravity=20
--if creating your own game, find using trial and error whatever feels right
function Bird:init()
self.image=love.graphics.newImage('bird.png')
self.width=self.image:getWidth()
self.height=self.image:getHeight()
self.x=(VIRTUAL_WIDTH/2 - self.width/2)
self.y=VIRTUAL_HEIGHT/2-self.height/2
self.dy=0
 self.images=love.graphics.newImage('pause.png')

end

function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x+2<=pipe.x+Pipe_Width 
        then
if self.y > 288
            then
            return true
    end
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT 
        then

            return true
        end
        
        
end
end
--another way to do it
--[[another way to do it function Bird:jump()
	self.dy=-5
end]]

function Bird:update(dt)
self.dy=self.dy+gravity*dt
if keywaspressed('space')
    	then
        love.graphics.draw(self.images, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    	self.dy=-5
        sounds['jump']:play()
    end
    --v = v+ gt formulae
    --now impart this to actual Bird location
self.y=self.y+self.dy
end

function Bird:render()
love.graphics.draw(self.image, self.x, self.y)
end

