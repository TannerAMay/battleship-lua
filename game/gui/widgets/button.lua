Button = Object:extend()

function Button:new(text, on_click,  x, y, width, height, is_enabled, is_visible)
    self.text = text
    self.on_click = on_click
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.enabled = is_enabled or true
    self.visible = is_visible or true


    self.color = {0.2, 0.2, 0.8, 1.0}
    self.disabled_color = {0.6, 0.6, 0.6, 1.0}
    self.active_color = {0.5, 0.5, 0.9, 1.0}

    self.selected = false
end

--[[
    Normal functions
]]
function Button:getDrawColor()
    if (self.selected)
    then
        return self.active_color[1], self.active_color[2], self.active_color[3], #self.active_color == 4 and self.active_color[4] or 1.0
    elseif (not self.enabled)
    then
        return self.disabled_color[1], self.disabled_color[2], self.disabled_color[3], #self.disabled_color == 4 and self.disabled_color[4] or 1.0
    else
        return self.color[1], self.color[2], self.color[3], #self.color == 4 and self.color[4] or 1.0
    end
end

--[[
    Events functions
]]
function Button:mousepressed(x, y, button, istouch, presses)
    if (button == 1 and self.enabled and checkRectCollision(x, y, self.x, self.y, self.width, self.height))
    then
        self.selected = true
    end
end

function Button:mousereleased(x, y, button, istouch, presses)
    if (button == 1 and self.enabled and checkRectCollision(x, y, self.x, self.y, self.width, self.height))
    then
        self.on_click()
    end
    
    self.selected = false
end

--[[
    Love drawing functions
]]
function Button:reset()
    self.selected = false -- just in case
end

function Button:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
end

function Button:draw()
    if (self.visible)
    then
        love.graphics.setColor(self:getDrawColor()) -- That way we can animate the hover effect

        -- The button rectangle
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        
        -- Button text
        love.graphics.setColor(0.8, 0.8, 0.8, 0.8)
        love.graphics.printf(self.text, self.x, self.y+self.height/2-10, self.width, "center")
    end
end