push=require 'push'

Class=require 'class'

-- our Paddle class, which stores position and dimensions for each Paddle
-- and the logic for rendering them


-- our Ball class, which isn't much different than a Paddle structure-wise

-- size of our actual window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


-- size we're trying to emulate with push
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
local background=love.graphics.newImage('background.png')
local ground=love.graphics.newImage('ground.png')
local bgs=0
local gs=0
local BGSS=30
local GSS=60
local BACKGROUND_LOOPING_POINT=413
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/TitleScreenState'
require 'states/ScoreState'
require 'states/PauseState'


love.keyboard.keyspressed={}

--GROUND MOVING FASTER FOR PARALLAX EFFECT
--local BACKGROUND_LOOPING_POINT=413
--SPECEFIC TO IMAGE
--DOESN'T MATTER FOR GROUND CAUSE IT HAS A CONSTANT THEME
function love.load()
    -- set love's default filter to "nearest-neighbor", which essentially
    -- means there will be no filtering of pixels (blurriness), which is
    -- important for a nice crisp, 2D look
    love.graphics.setDefaultFilter('nearest', 'nearest')
    smallfont=love.graphics.newFont('font.ttf',8)
    mediumfont=love.graphics.newFont('flappy.ttf',14)
    largefont=love.graphics.newFont('flappy.ttf',56)
    flappyfont=love.graphics.newFont('flappy.ttf',28)
    love.graphics.setFont(flappyfont)

    sounds = { ['jump'] = love.audio.newSource('jump.wav', 'static'), ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'), ['score'] = love.audio.newSource('score.wav', 'static'),
        ['count']=love.audio.newSource('count.wav','static'),['music'] = love.audio.newSource('marios_way.mp3', 'static'),
        ['pause']=love.audio.newSource('down.wav','static') }
    
    sounds['music']:setLooping(true)
    sounds['music']:play()


--TO MAKE SURE SEEDS TO MATH.RANDOM ARE ALWAY RANDOM AND DONT HAVE A PATTERN
--REFER TO NOTES TO UNDERSTAND THE OS TIME. IN SECONDS A VERY LARGE NUMBER.
math.randomseed(os.time())

    -- set the title of our application window

    love.window.setTitle('FIFTY BIRD')
push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, 
{
        fullscreen = false,
        resizable = true
    ,
        vsync = true
 })

gStateMachine= StateMachine{ ['title']=function()return TitleScreenState()end,['countdown']=function()return CountdownState() end,
['play']=function()return PlayState() end,['score']=function()return ScoreState() end,['pause']=function()return PauseState() end}
gStateMachine:change('title')
end

function love.resize(w,h)
	 push:rezise(w,h)
	 end

function love.keypressed(key)
	 love.keyboard.keyspressed[key]=true
	  if key=='escape' then

	   
	  love.event.quit()
	end
    --another way to do it if
	--[[ key=='space'
		then 
		bird:jump()
	end]]
end
function keywaspressed(key)
	
	return love.keyboard.keyspressed[key]

end

function love.update(dt)

	bgs=(bgs+(BGSS*dt))%BACKGROUND_LOOPING_POINT
	gs=(gs+(GSS*dt))%VIRTUAL_WIDTH

gStateMachine:update(dt)
love.keyboard.keyspressed={}

end

function love.draw()
	 push:start()
	 love.graphics.draw(background,-bgs,0)
	 gStateMachine:render()
	 --[[ for k, pair in pairs(pipePairs)
    do
    pair:render()
	end]]
	  --before ground to make it look like its sticking out of ground
	 love.graphics.draw(ground,-gs,VIRTUAL_HEIGHT-16)
	 --bird:render()
	 push:finish()
	end


