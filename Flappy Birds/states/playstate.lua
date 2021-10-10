PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

bird = Bird()
 local SPAWNTIME=0
 local pipePairs={}
 local score=0
function PlayState:init()
   
    self.xy = math.random(2.0,3.5)
    --self.image=love.graphics.newImage('pause.png')
   
    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
 if keywaspressed('P') or keywaspressed('p') then
    sounds['pause']:play()
    love.audio.stop(sounds['music'])
    gStateMachine:change('pause')
end
    SPAWNTIME = SPAWNTIME+dt

if SPAWNTIME>self.xy
	then
	-- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
	table.insert(pipePairs, PipePair(y))
	SPAWNTIME=0
    self.xy = math.random(2.0,3.5)
end

for k, pair in pairs(pipePairs)do
    if pair.scored==false then --self.scored set to false in pipe pair
    if pair.x+ PIPE_WIDTH < bird.x
        then score=score+1
        pair.scored=true
        sounds['score']:play()

    end
    end
end


for k, pair in pairs(pipePairs)
do
pair:update(dt)
end

bird:update(dt)
--deletion of table in another loop since removing an element results in all other selemts moving one indices down, this will result in skipping of certain elements.
for k, Pair in pairs(pipePairs)
do
if Pair.remove then
	table.remove(pipePairs,k)
end
end

for k, pair in pairs(pipePairs)do
for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
            bird.y=VIRTUAL_HEIGHT / 2 - (bird.height / 2)
            bird.dy=0
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score',{ score=score })
            SPAWNTIME=0
            pipePairs={}
            score=0   
            end
        end
    end


if bird.y >= VIRTUAL_HEIGHT - 15 then
        bird.y=VIRTUAL_HEIGHT / 2 - (bird.height / 2)
        bird.dy=0
        sounds['explosion']:play() 
        sounds['hurt']:play()
        gStateMachine:change('score',{ score=score })
        SPAWNTIME=0
        pipePairs={}
       score=0  
    end
end

function PlayState:render()

 for k, pair in pairs(pipePairs)
    do
    pair:render()
	end
	bird:render()
	--TO PRINT SCORE IN THE LEFT TOP CORNER
	love.graphics.setFont(flappyfont)
	love.graphics.print('Score: '..tostring(score),8,8)
end

function PlayState:enter()
	scrolling=true
end

function PlayState:exit()
	scrolling=false
end


