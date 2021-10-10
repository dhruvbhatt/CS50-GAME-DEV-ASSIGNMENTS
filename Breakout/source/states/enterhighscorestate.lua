EnterHighScoreState = Class{__includes = BaseState}

local chars = {[1] = 65,[2] = 65,[3] = 65}
--table for name initially set to AAA
-- char we're currently changing
local highlightedChar = 1

function EnterHighScoreState:enter(params)
	self.highScores=params.highScores
	self.score=params.score
	self.index=params.Index
end

function EnterHighScoreState:update(dt)
	if keywaspressed('right') and highlightedChar<3 then
		highlightedChar=highlightedChar+1
		gSounds['select']:play()
	elseif keywaspressed('left') and highlightedChar>1 then
		highlightedChar=highlightedChar-1
		gSounds['select']:play()
	end

	if keywaspressed('up') then
		chars[highlightedChar]=chars[highlightedChar]+1 
		if chars[highlightedChar]>90 then--go back to A. GREATER THAN INSTEAD OF EQUAL TO SINCE CHECKED AFTER INCREMENT ABOVE
			chars[highlightedChar]=65
		end
	
	elseif keywaspressed('down') then
		
		chars[highlightedChar]=chars[highlightedChar]-1
       	if chars[highlightedChar]<65 then
            chars[highlightedChar]=90
        end
    end

	if keywaspressed('enter') or keywaspressed('return') then
        -- update scores table
      	local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])--concat all.
      	--string .char returns string of respective ascii functions
		for i=10, self.index ,-1 do
			self.highScores[i + 1] = { name = self.highScores[i].name, score = self.highScores[i].score }
		end
		self.highScores[self.index].score=self.score
		self.highScores[self.index].name=name

		local scoresStr=''--TO WRITE SCORE TO FILE
		--TO PASS NEW HIGH SCORE ALONG WITH THE LIST AND NEW RANKING
		for i=1,10 do
			scoresStr=scoresStr..self.highScores[i].name..'\n'
			scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end
        love.filesystem.write('breakout.lst', scoresStr)--TO WRITE INTO THE FILE
        gStateMachine:change('highscore', { highScores = self.highScores})
	end
end

function EnterHighScoreState:render()
	love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your score: ' .. tostring(self.score), 0, 30,VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
 	--change color for selected one
    if highlightedChar == 1 then
        love.graphics.setColor(0.404, 1, 1, 1)
    end
    --will have white opaque color unless above statement true
    love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)--setting back to normal 

    if highlightedChar == 2 then
        love.graphics.setColor(0.404, 1, 1, 1)
    end
    
    love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 6, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)

    if highlightedChar == 3 then
        love.graphics.setColor(0.404, 1, 1, 1)
    end
    
    love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1, 1, 1, 1)
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to confirm!', 0, VIRTUAL_HEIGHT - 18,VIRTUAL_WIDTH, 'center')

end