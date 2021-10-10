PlayState = Class{__includes = BaseState}
local speed=50
local PadInc=400

function PlayState:enter(params)
	self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.balls = { params.ball }
    self.level= params.level
	-- give ball random starting velocity
    self.balls[1].dx = math.random(-200, 200)
    self.balls[1].dy = math.random(-50, -60)
	self.paused=false--initially set to false, set to true when p is pressed
	self.highScores = params.highScores
	self.RP=params.RP
	self.spawnT=math.random(3,13)
	self.keyTimer=self.spawnT+math.random(2,12)
	renderPUP=false
	renderKEY=false
	self.time=0
	key=false
end

function PlayState:update(dt)
	--location of update powerup 2 balls changed so it pauses 
	if self:collidePUP() then
		renderPUP=false
		local newBall1=Ball()
		newBall1.dx = math.random(-200, 200)
    	newBall1.dy = math.random(-50, -60)
    	newBall1.skin=self.balls[1].skin
    	newBall1.x=self.balls[1].x
    	newBall1.y=self.balls[1].y
    	table.insert(self.balls,newBall1)
    	local newBall2=Ball()
		newBall2.dx = math.random(-200, 200)
    	newBall2.dy = math.random(-50, -60)
    	newBall2.skin=self.balls[1].skin
    	newBall2.x=self.balls[1].x
    	newBall2.y=self.balls[1].y
    	table.insert(self.balls,newBall2)

    end
    if self:collideKEY() then
    	key=true
    	renderKEY=false
    end

	if self.paused then --checking this first before space, since it can alredy be stuck in pause and we cant let the paddle move at that time
		if keywaspressed('space')then
			self.paused=false
			gSounds['pause']:play()
		else
			return
		end
		elseif keywaspressed('space')then
			self.paused=true
			gSounds['pause']:play()
			return
		end

	self.time=self.time+dt
	if self.time>self.spawnT then
		renderPUP=true
		self.powerupX=math.random(5,VIRTUAL_WIDTH-21)--5 offset from edge and 16 is width
		self.powerupY=math.random(0,VIRTUAL_HEIGHT/3)
		--incrementing speed
		self.spawnT=self.spawnT+math.random(40,70)
	end

	if self.time>self.keyTimer then
		if not self.checkKEY then
			renderKEY=true
			self.KeyX=math.random(5,VIRTUAL_WIDTH-21)--5 offset from edge and 16 is width
			self.KeyY=math.random(0,VIRTUAL_HEIGHT/3)
			--incrementing speed
			self.keyTimer=self.keyTimer+math.random(40,70)
		end
	end

	if renderPUP then
	self.powerupY=self.powerupY+ speed*dt
	end

	if renderKEY then
	self.KeyY=self.KeyY+ speed*dt
	end

	if self.score > PadInc then
		if not (self.paddle.size>3) then 
			self.paddle.size=self.paddle.size+1
			self.paddle.width=self.paddle.width+32
			PadInc=PadInc*3
		end
	end

	self.paddle:update(dt)

	for k,ball in pairs(self.balls) do
		ball:update(dt)
	end
	
	for k,ball in pairs(self.balls) do
	    
		if ball:collides(self.paddle) then
			ball.y=self.paddle.y-8 --incase it goes below/inside the paddle, 8 is height of ball
			ball.dy=-ball.dy
			gSounds['paddle-hit']:play()

			if ball.x<self.paddle.x+self.paddle.width/2 and self.paddle.dx<0 then -- make sure paddle moving from right to left
				ball.dx= -50-(8*(self.paddle.x+self.paddle.width/2-ball.x))
				--50 and 8 was obtained from hit and trial as found suitable for game, and multiplied by the Fn since further the ball is from the center
				--sharper the increase in velocity
			
			elseif ball.x>self.paddle.x+self.paddle.width/2 and self.paddle.dx>0 then --make sure paddle moving from left to right
					ball.dx=50+8*(ball.x-self.paddle.x-self.paddle.width/2)--since ball.x is more instead of negating, just rewrite/order
			end
		end
	end

	for k,ball in pairs(self.balls) do
		for k,brick in pairs(self.bricks) do
			--object is passed in below functions and could be named anything
			if brick.inPlay and ball:collides(brick) then
				if not brick.special then
					brick:hit()--trigger it to stop the brick from rendering since flag set to false
					self.score=self.score+(brick.tier*200+brick.color*25)
				else
					if key then
						brick:hit()--trigger it to stop the brick from rendering since flag set to false
						self.score=self.score+500
						self.checkKEY=true
					end
				end
			

				
				if self.score > self.RP then
	                -- can't go above 3 health
	                self.health = math.min(3, self.health + 1)

	                -- multiply recover points by 2
	                self.RP = math.min(100000, self.RP * 2)

	                -- play recover sound effect
	                gSounds['recover']:play()
	                
	                if not (self.paddle.size>3) then 
						self.paddle.size=self.paddle.size+1
						self.paddle.width=self.paddle.width+32
					end
	            end

				--to check if all bricks have been hit
				if self:checkVictory() then
					gStateMachine:change('victory', 
				{
	                   	level = self.level,
	                    paddle = self.paddle,
	                    health = self.health,
	                    score = self.score,
	                    ball = self.balls[1],
	                    highScores=self.highScores, 
	                    RP=self.RP
	            })
				end
				
				--left edge of ball not in contact
				if ball.x+2<brick.x and ball.dx >0 then --2 is a constant to counter problem during edge detection and fix corners
					ball.dx=-ball.dx
					ball.x=brick.x-8
				
				--right edge of ball not in contac
				elseif ball.x+6>brick.x+32 and ball.dx<0 then --Since 2 offset is constant, and 8 is width. 6 will be from x position of ball.
					ball.dx=-ball.dx
					ball.x= brick.x+32
				
				--top edge of ball not in contact
				elseif ball.y<brick.y then
					ball.dy=-ball.dy
					ball.y=brick.y-8
				
				--IF NO SIDE OR TOP COLLISION, THEN OBVIOUSLY BOTTOM COLLISION TOOK PLACE. I.E. bottom edge of ball not in contact
				else
					ball.dy=-ball.dy
					ball.y=brick.y+16--height of brick
				end
				
				
				-- slightly scale the y velocity to speed up the game, capping at +- 150
	            if math.abs(ball.dy) < 150 then
	            	ball.dy = ball.dy * 1.02
	        	end
	            -- only allows colliding with one brick, for corners
	            break--important otherwise can hit two brick at once
			end
		end
	end

	for k,ball in pairs(self.balls) do
		if ball.y>=VIRTUAL_HEIGHT then
			table.remove(self.balls,k) 
			if #self.balls==0 then
				self.health=self.health-1
				gSounds['hurt']:play()
				renderPUP=false

				if self.paddle.size>1 then 
					self.paddle.size=self.paddle.size-1
					self.paddle.width=self.paddle.width-32
				end

				if self.health==0 then
					gStateMachine:change('gameover',{score=self.score,highScores=self.highScores })
				else
					gStateMachine:change('serve',{ paddle = self.paddle, bricks = self.bricks, health = self.health, score = self.score,
						level = self.level,highScores=self.highScores, recoverPoints=self.RP, key=false  })
				end
			end
		end
	end

	--TO RENDER PARTICLE FUNCTION
	for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

	if keywaspressed('escape')then
		love.event.quit()
	end
end

function PlayState:checkVictory()
	for k,brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end
	return true--since nothing was returned in all iterations
end

function PlayState:render()
	for k,brick in pairs(self.bricks)do
		--object is passed in below functions and could be named anything
		brick:render()
	end
	
	 for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end
	
    
	self.paddle:render()
	
		--object is passed in below functions and could be named anything
	for k,ball in pairs(self.balls) do
		
        ball:render()
    end
	
	
	renderScore(self.score)
    renderHealth(self.health)
    if renderPUP then
     	love.graphics.draw(gTextures['main'], gFrames['powerup'][1],self.powerupX,self.powerupY)
	end
	
	if renderKEY then 
	love.graphics.draw(gTextures['main'], gFrames['powerup'][2],self.KeyX,self.KeyY)
	end

	if self.paused then
		love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end
function PlayState:collidePUP()
	if renderPUP then
	
		if self.powerupX<=self.paddle.x+self.paddle.width and self.powerupX+16>=self.paddle.x then
			if self.powerupY+16>=self.paddle.y and self.powerupY<=self.paddle.y+self.paddle.height then
				gSounds['recover']:play()
				return true
			end
		end 
	end
	
	return false
	
end

function PlayState:collideKEY()
	if renderKEY then
	
		if self.KeyX<=self.paddle.x+self.paddle.width and self.KeyX+16>=self.paddle.x then
			if self.KeyY+16>=self.paddle.y and self.KeyY<=self.paddle.y+self.paddle.height then
				gSounds['recover']:play()
				return true
			end
		end 
	end
	
	return false
	
end
