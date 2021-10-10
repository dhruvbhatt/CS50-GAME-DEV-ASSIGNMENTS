LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}
    local tileID = TILE_ID_GROUND
    local keyExists=true
    local lockExists=true
    local keyPos = math.random(1,math.floor(width/2))
    local lockPos= math.random(math.floor(width/2),(width-10))
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)
    keyObtained=false
    frames=math.random(1,4)
    local gap=false
    local consecutive=false
    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        -- lay out the empty space
        for y = 1, 6 do
            --tile ID HAS BEEN SET TO EMPTY ABOVE
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end
        

        -- chance to just be emptiness
        if ((gap==true) or (math.random(7) == 1 and not(x==1) and not (x==lockPos) and not (x>=(width-3)) 
            and not (x==lockPos-1) and not (x>=(width-2)) and not consecutive)) then
            for y = 7, height do
                --tile ID HAS BEEN SET TO EMPTY ABOVE its being edited here two being put
                table.insert(tiles[y],Tile(x, y, tileID, nil, tileset, topperset))
                --table.insert(tiles[y],
                    --Tile(x+1, y, tileID, nil, tileset, topperset))
 
            end
                            if gap then 
                    gap=false
                    consecutive=true
                else
                    gap=true
                end
        else
            consecutive=false
            tileID = TILE_ID_GROUND
           blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 and not (x>=(width-3))  then
                blockHeight = 2
                --changed if pillar exists
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil--since topper will now be at 5.
            
            -- chance to generate bushes
            elseif math.random(8) == 1 and not (x==keyPos) and not (x>=(width-3))  then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end
            if lockExists and x==lockPos then
                table.insert(objects,   
                    GameObject {
                        texture = 'lockKey',
                        x = (lockPos - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = frames+4,
                        collidable = true, 
                        solid =  true,
                        rendering=true,
                        -- collision function takes itself
                        onCollide = function(obj)
                        if keyObtained then
                                    obj.solid=false
                                    obj.collidable=false
                                    gSounds['pickup']:play()
                                    obj.rendering=false
                        --passing the class with variables into a variable
                            local flag= GameObject {
                                texture = 'flag',
                                x = (width-1.5) * TILE_SIZE,
                                y = (3) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                frame=7,
                                collidable = false
                            }
                            --FOR FLAG MOVEMENT
                            Timer.every(0.25, function()
                                flag.frame=flag.frame==8 and 7 or flag.frame+1
                                end)
                            --inserting into table
                            table.insert(objects,flag)

                            local post= GameObject {
                                        texture = 'post',
                                        x = (width-2) * TILE_SIZE,
                                        y = (3) * TILE_SIZE,
                                        width = 16,
                                        height = 64,
                                        frame = math.random(6),
                                        consumable = true,
                                        solid=false,
                                        onConsume=function(player,object)
                                            gStateMachine:change('play',{score=player.score,size=width+10})
                                        end
                                    }

                            table.insert(objects,post)
                        end
                    end
                                       
                    }
                    )
                    
                    lockExists=false
            end


            -- chance to spawn a block
            if math.random(10) == 1 and not(x==1) and not (x==lockPos) and not (x==keyPos) and not (x>=(width-3)) then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
                
    
                end
            
    end
         
         for x=1, width do
            if (tiles[6][x].id==TILE_ID_EMPTY) and tiles[7][x].topper==topper and keyExists and x==keyPos then
                       table.insert(objects,
                        GameObject {
                            texture = 'lockKey',
                            x = (x-1)*TILE_SIZE,
                            y = (6-1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            frame = frames,
                            consumable = true,
                            onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                                keyObtained=true
                                            end
                        }
                        )
                       keyExists=false
                   elseif x==keyPos then
                        keyPos=keyPos+1
                    end
                end



           

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end