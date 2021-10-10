Brick=Class{}

-- some of the colors in our palette (to be used with particle systems)
--same order as brick color
paletteColors = {
    -- blue
    [1] = { ['r'] = 0.39, ['g'] = 0.61, ['b'] = 1 },
    -- green
    [2] = { ['r'] = 0.42, ['g'] = 0.75,['b'] = 0.19 },
    -- red
    [3] = { ['r'] = 0.85, ['g'] = 0.34,['b'] = 0.39 },
    -- purple
    [4] = { ['r'] = 0.84,['g'] = 0.48,['b'] = 0.73 },
    -- gold
    [5] = { ['r'] = 0.98, ['g'] = 0.95, ['b'] = 0.21 }}

function Brick:init(x,y)
	self.x=x
	self.y=y
	self.width=32
	self.height=16
	self.inPlay=true --ITS A FLAG WHICH IS SET TO FALSE WHEN BALL COLLIDES WITH BRICK SO IT DOESN'T RENDER IT, AND IT CEASES TO EXIST.
	self.tier=0--EACH COLOR CONSISTS OF 4 TIERS. RANGES FROM 0 TO 3. EXCEPT the 6th color which only has one tier.
	self.color=1--6 COLORS EXIST, ranges from 1 TO 6.
	self.special=true

	self.pSystem=love.graphics.newParticleSystem(gTextures['particle'],64)
	self.pSystem:setParticleLifetime(0.5,1)
	self.pSystem:setLinearAcceleration(-15, 0, 15, 80)--X ranges from -15 to 15. Y from 0 to 80
	self.pSystem:setEmissionArea('normal',10,10)
end

function Brick:hit()
	--function is called from playstate when ball collides.
	
	--self.color in accordance with pallet table above
	if not self.special then
		self.pSystem:setColors(paletteColors[self.color].r,paletteColors[self.color].g,paletteColors[self.color].b,
			55*(self.tier+1),--initial intensity or alpha
			paletteColors[self.color].r,paletteColors[self.color].g,paletteColors[self.color].b,0)
			--transistion color is same but can be different if required(future)
			--0 at end means fades with lifetime
		--64 PARTICLES EMISSION
		self.pSystem:emit(64)
	else
		self.pSystem:setColors(paletteColors[5].r,paletteColors[5].g,paletteColors[5].b,
			55*(5+1),--initial intensity or alpha
			paletteColors[5].r,paletteColors[5].g,paletteColors[5].b,0)
			--transistion color is same but can be different if required(future)
			--0 at end means fades with lifetime
		--64 PARTICLES EMISSION
		self.pSystem:emit(64)
	end
	
	gSounds['brick-hit-2']:play()
	if self.tier>0 then
		if self.color==1 then
			self.tier=self.tier-1--if blue lowest color then go one tier down
			self.color=5
		else
			self.color=self.color-1 --if color higher than blue just go one color down of same tier
		end
	else
		if self.color==1 then --lowest tier of blue color then stop rendering
			gSounds['brick-hit-1']:play()
			self.inPlay=false
		else
			self.color=self.color-1
		end
	end

end

function Brick:update(dt)
    self.pSystem:update(dt)
    --UPDATED BY ITSELF SINCE PROVIDED BY LUA
end

function Brick:render()
	if self.inPlay then--since only prints when its true, duh!
		--the logic to print the brick as per the color and tier when ranges from 1-21
		if self.special then
			love.graphics.draw(gTextures['main'], gFrames['powerup'][3],self.x,self.y)
		else
			love.graphics.draw(gTextures['main'], gFrames['bricks'][((self.color-1)*4)+self.tier+1],self.x, self.y)
		end	
	end
end

--SEPERATE RENDER TO MAKE SURE IT RENDERS OVER THE BRICKS.
function Brick:renderParticles()
    love.graphics.draw(self.pSystem, self.x + 16, self.y + 8)
end
