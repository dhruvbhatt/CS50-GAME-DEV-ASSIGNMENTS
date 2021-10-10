PipePair= Class{}


function PipePair:init(y)
self.x=VIRTUAL_WIDTH
self.y=y
self.scored=false
self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random(80,150))
    }

--printing from bottom to up
self.remove=false
end

function PipePair:update(dt)
	if self.x>-Pipe_Width
    then
    self.x=self.x-Pipe_Scroll * dt
    self.pipes['upper'].x=self.x
    self.pipes['lower'].x=self.x
else
	self.remove=true
end
end

function PipePair:render()
for k, pipe in pairs(self.pipes) 
	do 
	pipe:render()
end
end



