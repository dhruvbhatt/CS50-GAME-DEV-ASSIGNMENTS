ScoreState=Class{__includes=BaseState}

function ScoreState:enter(params)--params is random name to accept variable like pass by value in c or java
	--Value is passed like this gStateMachine:change('score',{score=self.score})
	images={['gold']=love.graphics.newImage('gold.png'),['silver']=love.graphics.newImage('silver.png'),['bronze']=love.graphics.newImage('bronze.png')}
	self.score=params.score
	if self.score>=10 and self.score<15 then
	   self.image=images['bronze']
	end
	if self.score>=15 and self.score<20 then
		self.image=images['silver']
	end
	if self.score>=20 then
	   self.image=images['gold']
end
end

function ScoreState:update(dt)
if(keywaspressed('enter') or keywaspressed('return')) then

gStateMachine:change('countdown')
end
end

function ScoreState:render()
love.graphics.setFont(flappyfont)
love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

love.graphics.setFont(mediumfont)
love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

love.graphics.printf('Press Enter to Play Again!', 0, 180, VIRTUAL_WIDTH, 'center')
if self.score>=10 then
love.graphics.draw(self.image,VIRTUAL_WIDTH/2 - 16, VIRTUAL_HEIGHT/2 - 16)
end
end
