ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
	self.paddle=params.paddle
	self.bricks=params.bricks
	self.health=params.health
	self.level=params.level 
	self.score=params.score
	self.ball=Ball()
	self.ball.skin=math.random(7)
	self.highScores = params.highScores
	self.recoverPoints=params.recoverPoints
end

function ServeState:update(dt)
	self.paddle:update(dt)--paddle movement
	self.ball.x=self.paddle.x+(self.paddle.width/2) - 4 --4 since ball width is 8
	self.ball.y=self.paddle.y-8
	if keywaspressed('enter') or keywaspressed('return')then
		 gStateMachine:change('play', { paddle = self.paddle, bricks = self.bricks, 
		 	health = self.health, score = self.score, ball = self.ball,level=self.level, highScores=self.highScores,RP=self.recoverPoints })
	end
	if keywaspressed('escape') then
		love.event.quit()
	end
end

function ServeState:render()
	self.paddle:render()
    self.ball:render()

    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter To Serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
