require 'source/dependencies'

function love.load()
    --nearest nearest to give a retro look and no blur effect
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    love.window.setTitle('Breakout')
    gFonts = { ['small'] = love.graphics.newFont('fonts/font.ttf', 8),['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32) }
    
    love.graphics.setFont(gFonts['small'])

    -- load up the graphics we'll be using throughout our states
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }
    --global table for paddles
    gFrames={ ['paddles']=GenerateQuadPaddles(gTextures['main']),['ball']=GenerateQuadBalls(gTextures['main']),
            ['bricks']=GenerateQuadBricks(gTextures['main']),['hearts']=GenerateQuads(gTextures['hearts'], 10, 9),
            ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),['powerup']=GenerateQuadPowerUp(gTextures['main'])}
    --since total width is 20, each hearts width will be 10 and have same height. GQ will return a table with 2 indexes.
    -- initialize our virtual resolution, which will be rendered within our
    -- actual window no matter its dimensions
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = { 
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav','static'),
        ['select'] = love.audio.newSource('sounds/select.wav','static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav','static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav','static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav','static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav','static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav','static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav','static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav','static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav','static'),

        ['music'] = love.audio.newSource('sounds/music.wav','static')
    }

    gStateMachine = StateMachine { ['start'] = function() return StartState() end, ['serve'] = function() return ServeState() end, 
    ['play']=function() return PlayState() end,['victory']= function() return VictoryState() end,
    ['gameover'] = function() return GameOverState() end, ['highscore'] = function() return HighScoreState() end,
    ['enterscore'] = function() return EnterHighScoreState() end, ['paddle'] = function() return PaddleSelectState() end }
    
   
    gStateMachine:change('start',{ highScores = loadHighScores()})
    --PASSING HIGH SCORE FROM BELOW FUNCTION
    gSounds['music']:play()
    gSounds['music']:setLooping(true)

    -- a table we'll use to keep track of which keys have been pressed 
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
   
    gStateMachine:update(dt)

  
    love.keyboard.keysPressed = {}
end

--called everytime a key is pressed
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

--[[
    A custom function that will let us test for individual keystrokes outside
    of the default `love.keypressed` callback, since we can't call that logic
    elsewhere by default.
]]
function keywaspressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

--[[
    Called each frame after update; is responsible simply for
    drawing all of our game objects and more to the screen.
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')

    -- background should be drawn regardless of state, scaled to fit our
    -- virtual resolution
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 0, 0, --[[no rotation]]0,
        -- scale factors on X and Y axis so it fills the screen
        --'-1' ADDED, SINCE WITHOUT IT BLACK EDGES ARE VISIBLE.
        VIRTUAL_WIDTH / (backgroundWidth-1), VIRTUAL_HEIGHT / (backgroundHeight-1))
    
    gStateMachine:render()
   
    displayFPS()
    
    push:apply('end')
end

function renderHealth(health)
    healthx=VIRTUAL_WIDTH-100
    --render lives left
    for i=1,health do
        love.graphics.draw(gTextures['hearts'],gFrames['hearts'][1],healthx,4)
        healthx=healthx+11
    end
    --render missing health or lives lost
    for i=1,3-health do
        love.graphics.draw(gTextures['hearts'],gFrames['hearts'][2],healthx,4)
        healthx=healthx+11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)--IN 2 DIFF PRINT FUNCTIONS SINCE SCORE KEEPS CHANGING AND MIGHT NEED SHIFTING.
    --RIGHT ALLIGNMENT SINCE AT THE CORNER.  
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')--Could be a single print fn.But this is cleaner.
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function loadHighScores() --FUNCTION TO LOAD HIGH SCORE LIST FROM SAVE DATA
    love.filesystem.setIdentity('breakout')
    --if doesn't exist, give it some default score
    if love.filesystem.getInfo('breakout.lst')==false then
        local scores=''-- setting to empty string
        for i=10,1,-1 do
            scores=scores .. "DHB\n"
            scores=scores .. tostring(1000*i) .. "\n"
        end
        --inputting the string data collected above
        love.filesystem.write('breakout.lst',scores)
    end

    local name=true--to check if current read object is a string(i.e the name) or the score
    local currentName=nil
    local counter=1

    local scores={}--set an empty table

    for i=1,10 do
        --making the table BLANK
        scores[i]={name=nil,score=nil}
    end

    --ITERATE OVER THE TABLE
    for line in love.filesystem.lines('breakout.lst') do
        if name then--since name is odd since comes first then score and is set to true initiall
            scores[counter].name=string.sub(line,1,3)--1 to 3 limit set if in data name is bigger than that
            --name=false
        else
            scores[counter].score=tonumber(line)
            counter=counter+1--required here, since name and score in a collective index
            --name=true
        end
        name = not name-- instead of keeping flags in both loops, just keep one
    end

    return scores
end


