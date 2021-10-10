LevelMaker=Class{}
--pattern for rows
solid=1
alternate=2
skip=3
none=4

function LevelMaker.createMaps(level)
	local bricks={}
	local numrows=math.random(1,5)
	local numcols=math.random(7,13)
	local specialBrickCol=math.random(1,numcols)
	local specialBrickRow=math.random(1,numrows)
	if numcols%2==0 then
		numcols=numcols+1--to make sure number of columns is odd, to make a ceratin pattern
	end

	--highest spawned color and tier for the certain level. WILL CHANGE IN FUTURE, NOW JUST A CONCEPT.
	local highestColor = math.min(5, level % 5 + 3)--since color ranges from 1 to 5 for right now.
	local highestTier = math.min(3, math.floor(level / 2.5))--ranges from 0 to 3
	
	for y=1,numrows do--since we want to draw the top row after leaving one row of space(16 pixels)
		--alternate pattern, ksip pattern flag and color
		local alternatePattern=math.random(1,2)==1 and true or false --TERNARY OPERATOR
		local skipPattern=math.random(1,2)==1 and true or false
		
		local alternateColor1=math.random(1,highestColor)
		local alternateColor2=math.random(1,highestColor)
		local skipFlag=math.random(1,2)==1 and true or false
		local alternateFlag=math.random(1,2)==1 and true or false
		local alternateTier1=math.random(0,highestTier)
		local alternateTier2=math.random(0,highestTier)

		--solid pattern if alt is false
		local solidcolor=math.random(1,highestColor)
		local solidTier=math.random(0,highestTier)
		
		for x=1,numcols do--we want to draw x from 0, so we'll subtract by 1 in body.
			
			if skipPattern and skipFlag then
				skipFlag=false
				goto continue
			else
				skipFlag=true
			end
			--calling brick class and passing x and y value to init function below.
			b=Brick((x-1)*32 + 8 + (13-numcols)*16 , y*16)
			--(x-1) since index starts from 1, but co-ordinates satrt from 0.AND *32 to take into consideration the width.
			--'+8' is required so it doesn't just render from the left edge. Since V_W % B_W =16. Thus 8 on both sides to begin with.
			--^(assuming 13 is numcols)
			--for further correction of padding: (13-numcols)*16 is to impart the padding and so it doesn't just render from the left edge.
			--^Since total width is 32. It's multiplied by 16 for left padding. Rest left is allocated to right padding since space is left,duh.
			--y*16 since duh.
			if (x==specialBrickCol and y==specialBrickRow) then
				b.special=true
			else
				b.special=false
				if alternatePattern and alternateFlag then
					b.color=alternateColor1
					b.tier=alternateTier1
					alternateFlag=false
				else
					b.color=alternateColor2
					b.tier=alternateTier2
					alternateFlag=true
				end
					--WILL OVERWRITE THE ABOVE, IF ALTPATTERN IS FALSE. THUS, CORRECT.
				if not alternatePattern then
					b.color=solidcolor
					b.tier=solidTier
				end
			end
			table.insert(bricks, b)--insert the above object into the table
			--since lua doesn't provide continue statement, we make our own
			::continue::
		end
	end
	
	if #bricks == 0 then
		return self.createMaps(level)
	else
		return bricks--return the table
	end
end
