function GenerateQuads(atlas,titlewidth,titleheight)
	
	local SHEET_WIDTH=atlas:getWidth()/titlewidth --calculated to check how many times to iterate over spritesheet to generate a rectangle
	local SHEET_HEIGHT=atlas:getHeight()/titleheight
	local SPRITE_SHEET={}
	local Sheet_Counter=1
	--since index starts with 1 in lua
	for y=0, SHEET_HEIGHT-1 do 
		
		for x=0,SHEET_WIDTH-1 do
			SPRITE_SHEET[Sheet_Counter]=love.graphics.newQuad(x*titlewidth,y*titleheight,titlewidth,titleheight,atlas:getDimensions())
			--width and height imp since it goes ahead by that much.
			Sheet_Counter=Sheet_Counter+1
		end
	end
	
	return SPRITE_SHEET
end

--function works identical to python slice function. Since lua doesn't provide one by default. We have to make it

function table.slice(tbl,first,last,step)
	local sliced={}
	for i=first or 1,last or #tbl,step or 1 do --or since, if values are not passed. # gives the last index, length of table.
		sliced[#sliced+1]=tbl[i]--#sliced gives last index and since its empty will start from 0
	end
	return sliced
end

--function to extract specefic paddles from sprite sheet
function GenerateQuadPaddles(atlas)
	local x=0
	local y=64--Since paddles are present 4 rows down onwards, and each row/images height is 16
	local counter=1--index start from 1
	local quads={}
	for i=0,3 do
	    quads[counter]=love.graphics.newQuad(x,y,32,16,atlas:getDimensions())
	    counter=counter+1
	    quads[counter]=love.graphics.newQuad(x+32,y,64,16,atlas:getDimensions())
	    counter=counter+1
	    quads[counter]=love.graphics.newQuad(x+96,y,96,16,atlas:getDimensions())--96 cause from the start
	    counter=counter+1
	    quads[counter]=love.graphics.newQuad(x,y+16,128,16,atlas:getDimensions())
	    counter=counter+1
   		x=0
   		y=y+32 --Since 2 rows down
    end
    
    return quads
end

function GenerateQuadBalls(atlas)
	local x=96--check image for reference
	local y=48
	local counter=1--index starts at 1 in lua
	local quads={}

	for i=0,3 do
		quads[counter]=love.graphics.newQuad(x,y,8,8,atlas:getDimensions())
		counter=counter+1
		x=x+8
	end
	x=96
	y=y+8
	for i=0,2 do
		quads[counter]=love.graphics.newQuad(x,y,8,8,atlas:getDimensions())
		counter=counter+1
	end
	return quads
end

function GenerateQuadBricks(atlas)
	--can directly use slice function since all bricks are of same size
	--FIRST GENERATE QUADS OF 32*16 DIMENSION. AND THE ENTIRE SPREAD SHEET IS DIVIDED.
	--THEN ENTER THE NUMBER TILL WHICH YOU WANT. CHECK SPRITE SHEET FOR REFERENCE
	return table.slice(GenerateQuads(atlas,32,16),1,21)	
end

function GenerateQuadPowerUp(atlas)
	local quad={}
	quad[1]=love.graphics.newQuad(128,192,16,16,atlas:getDimensions())
	quad[2]=love.graphics.newQuad(144,192,16,16,atlas:getDimensions())
	quad[3]=love.graphics.newQuad(160,48,32,16,atlas:getDimensions())
	return quad
end

