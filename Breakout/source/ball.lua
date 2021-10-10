Ball=Class{}

function Ball:init(skin)
	self.width=8
	self.height=8
	self.dy=0
	self.dx=0
	self.skin=skin
end

function Ball:collides(target)
	if self.x>target.x+target.width or self.x+self.width<target.x then
		return false
	end

	if self.y>target.y+target.height or self.y+self.height<target.y then
		return false
	end
	return true --If above two aren't true. Since return functions.
	--Thus, they collide/overlap.
end

function Ball:reset()
	self.x= VIRTUAL_WIDTH/2-4
	self.y= VIRTUAL_HEIGHT/2-4
	self.dx=0
	self.dy=0
end

function Ball:update(dt)
	self.x=self.x+self.dx*dt
	self.y=self.y+self.dy*dt

	if self.x>=VIRTUAL_WIDTH-8 then
		self.x=VIRTUAL_WIDTH-8
		self.dx=-self.dx
		gSounds['wall-hit']:play()
    end

    if self.x<=0 then
    	self.x=0
    	self.dx=-self.dx
    	gSounds['wall-hit']:play()
    end

    if self.y<=0 then
    	self.y=0
    	self.dy=-self.dy
    	gSounds['wall-hit']:play()
    end
end

function Ball:render(z,q)
	-- gTexture is our global texture for all blocks
    -- gBallFrames is a table of quads mapping to each individual ball skin in the texture
	love.graphics.draw(gTextures['main'], gFrames['ball'][self.skin],self.x,self.y)
end