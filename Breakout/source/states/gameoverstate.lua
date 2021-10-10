GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
self.score=params.score	
self.highScores = params.highScores
end

function GameOverState:update(dt)
    if keywaspressed('enter') or keywaspressed('return') then

    for i=10,1,-1 do
    	if self.score>self.highScores[i].score then
    		highscoreIndex=i
    		highscore=true --flag to check if a highscore was made
    	end
    end

    if highscore then
    	gStateMachine:change('enterscore',{Index=highscoreIndex, score=self.score,highScores=self.highScores})
    else
		gStateMachine:change('start',{highScores=self.highScores})
    end
	
	end
	if keywaspressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
love.graphics.setFont(gFonts['large'])
love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
love.graphics.setFont(gFonts['medium'])
love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,VIRTUAL_WIDTH, 'center')
end