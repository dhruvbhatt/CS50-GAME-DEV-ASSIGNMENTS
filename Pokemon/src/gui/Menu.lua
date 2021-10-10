--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A Menu is simply a Selection layered onto a Panel, at least for use in this
    game. More complicated Menus may be collections of Panels and Selections that
    form a greater whole.
]]
local render=true
Menu = Class{}

function Menu:init(def)
    if def.render==false then
    renders=false
    else
    renders=true
    end 
    panel= Panel(def.x, def.y, def.width, def.height)
     
    self.selection = Selection {
        items = def.items,
        x = def.x,
        y = def.y,
        width = def.width,
        height = def.height,
        renders=renders,
        font=def.font or gFonts['small']
    }
end

function Menu:update(dt)
    if renders then
    self.selection:update(dt)
end
end

function Menu:render()
    panel:render()
    self.selection:render()
end
