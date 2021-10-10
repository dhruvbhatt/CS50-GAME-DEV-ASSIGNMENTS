CountdownState=Class{__includes=BaseState}
local time=0.75

function CountdownState:init()
self.count=3
self.timer=0
sounds['count']:play()
end

function CountdownState:update(dt)
self.timer=self.timer+dt
if self.timer>=0.75 then
	self.count=self.count-1
	self.timer=0

if self.count==0 then
	gStateMachine:change('play')
else
sounds['count']:play()
end
end
end
function CountdownState:render()
love.graphics.setFont(largefont)
love.graphics.printf(tostring(self.count),0, 120, VIRTUAL_WIDTH, 'center')
end


