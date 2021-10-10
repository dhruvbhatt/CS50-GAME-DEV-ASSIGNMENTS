StartState = Class{__includes = BaseState}
local highlighted=1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
	if keywaspressed('up')or keywaspressed('down') then
	    gSounds['paddle-hit']:play()
		if highlighted==1 then
           highlighted=2
        else
       	highlighted=1
        end
    end

    if keywaspressed('enter') or keywaspressed('return')then
        gSounds['confirm']:play()
        
        if highlighted==1 then
            gStateMachine:change('paddle',{ highScores=self.highScores })
        else
         gStateMachine:change('highscore', { highScores = self.highScores})
        end
    end

	
	if keywaspressed('escape')then
	love.event.quit() 
	end
end

function StartState:render()

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    
    if highlighted == 1 then
        love.graphics.setColor(0.4039, 1, 1, 1)
    end
    
    love.graphics.printf("START", 0, VIRTUAL_HEIGHT/2 +70, VIRTUAL_WIDTH, 'center')
    --RESET THE COLOR AFTER USE
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
       love.graphics.setColor(0.4039, 1, 1, 1)
    end
    
    love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT/2+90,VIRTUAL_WIDTH, 'center')

    --RESET THE COLOR AFTER USE
    love.graphics.setColor(1, 1, 1, 1)
end