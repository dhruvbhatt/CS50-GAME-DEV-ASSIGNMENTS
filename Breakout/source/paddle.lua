Paddle=Class{}

function Paddle:init(skin)
	self.x=VIRTUAL_WIDTH/2-32 --DEFAULT SIZE IS 32 WHICH IS THE SECOND PADDLE, THUS IN THE MIDDLE 
	self.y=VIRTUAL_HEIGHT-32 --Since 16 is height and you want it a bit above BOTTOM SCREEN
	self.dx=0
	--initial dimension
	self.width=64
	self.height=16
	self.skin=skin--to change color
	self.size=2--since 1 is too small to begin with
end

function Paddle:update(dt)
	if love.keyboard.isDown('left') then
		self.dx=-PADDLE_SPEED
	elseif love.keyboard.isDown('right') then
		self.dx=PADDLE_SPEED
	else
		self.dx=0--since other wise on just one click it will keep moving
	end

	if self.dx<0 then--CALCULATION OF SELF.X AND SETTING LIMITS IN ONE SINGLE FUNCTION
		self.x=math.max(0,self.x+self.dx*dt)
	
	else
		self.x=math.min(VIRTUAL_WIDTH-self.width,self.x+self.dx*dt)
	end	
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],self.x, self.y)
    --main is passed along with gFrames since it returns a quad.
    --Since 16 indexes are there, the above logic works.For ex: size=1 skin=2. 5th index.
end
