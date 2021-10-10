VictoryState= Class{__includes = BaseState}

function VictoryState:enter(params)
	self.paddle = params.paddle
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level= params.level
    self.highScores = params.highScores
    self.RP=params.RP
end

function VictoryState:update(dt)
	self.paddle:update(dt)
	
    -- have the ball track the player 
    self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y - 8

    -- go to play screen if the player presses Enter
    if keywaspressed('enter') or keywaspressed('return') then
        gStateMachine:change('serve', {
            level = self.level + 1,
            bricks = LevelMaker.createMaps(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores=self.highScores,
            recoverPoints=self.RP 
        })
    end
end

function VictoryState:render()
 	self.paddle:render()
    self.ball:render()


    renderHealth(self.health)
    renderScore(self.score)

    -- level complete text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " complete!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    -- instructions text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH, 'center')
	-- body
end