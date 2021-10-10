LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(player)
    self.playerPokemon = player
    local hp=self.playerPokemon.HP
    local attack=self.playerPokemon.attack
    local defense=self.playerPokemon.defense
    local speed=self.playerPokemon.speed
    hpY,attackY,defenseY,speedY=self.playerPokemon:levelUp()

    self.LevelUpMenu = Menu {
        x = 12,
        y = 12,  
        width = 200,
        height = 100,
        render = false,
        font=gFonts['medium'], 

        items = {
            {
                text = 'HP: '..hp..'+'..hpY..' = '..self.playerPokemon.HP
            },
            {
            	text= 'Speed: '..speed..'+'..speedY..' = '..self.playerPokemon.speed
            },
            {
            	text= 'Attack: '..attack..'+'..attackY..' = '..self.playerPokemon.attack
            },
            {
            	text= 'Defense: '..defense..'+'..defenseY..' = '..self.playerPokemon.defense
            }
            

    }}
end

function LevelUpMenuState:update(dt)
    self.LevelUpMenu:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        self:fadeOutWhite()
    end
end

function LevelUpMenuState:render()
    self.LevelUpMenu:render()
end

function LevelUpMenuState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1, 
    function()

        -- resume field music
        gSounds['victory-music']:stop()
        gSounds['field-music']:play()
        
        -- pop off the battle state
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 255, g = 255, b = 255
        }, 1, function() end))
    end))
end