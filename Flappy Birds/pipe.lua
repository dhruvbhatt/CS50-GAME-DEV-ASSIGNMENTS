Pipe= Class{}

local Pipe_image = love.graphics.newImage('pipe.png')
PIPE_HEIGHT=288
Pipe_Scroll=60
Pipe_Width=70
function Pipe:init(orientation,y)
	 
	self.x= VIRTUAL_WIDTH
	self.y=y 
	self.orientation=orientation

	
end

function Pipe:update(dt)

end

function Pipe:render()
if self.orientation=='top'
	then 
	love.graphics.draw(Pipe_image, self.x,self.y+PIPE_HEIGHT ,0, 1, -1)
else
	love.graphics.draw(Pipe_image, self.x, self.y,0, 1, 1)
	--instead of that, can do it directly in one complex line of code.
    --[[love.graphics.draw(Pipe_image, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)]]
end
end 



