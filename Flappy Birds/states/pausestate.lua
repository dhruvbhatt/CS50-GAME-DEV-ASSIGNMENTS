PauseState = Class{__includes = BaseState}

function PauseState:init()
	self.image=love.graphics.newImage('pause.png')
	scrolling=false
	bird.dy=0
end

function PauseState:update(dt)
	if keywaspressed('P') or keywaspressed('p') then
	Pipe_Scroll=60
	sounds['music']:play()
    gStateMachine:change('play')
end
end

function PauseState:render()
PlayState:render()
love.graphics.draw(self.image,VIRTUAL_WIDTH/2-64,VIRTUAL_HEIGHT/2-64)
end