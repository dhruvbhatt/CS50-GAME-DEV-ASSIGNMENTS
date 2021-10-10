TitleScreenState=Class{__includes=BaseState}

function TitleScreenState:update(dt)
	if keywaspressed('enter') or keywaspressed('return') then
	gStateMachine:change('countdown')
end
end

function TitleScreenState:render()
love.graphics.setFont(flappyfont)
love.graphics.printf('Fifty Bird', 0, 100, VIRTUAL_WIDTH, 'center')

love.graphics.setFont(mediumfont)
love.graphics.printf('Press Enter', 0, 144, VIRTUAL_WIDTH, 'center')
end
