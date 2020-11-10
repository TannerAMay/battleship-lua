BaseScreen = Object:extend()

--[[
The abstract base class for screens.
Parameters:
    color - the color that will be rendered as the background if there is not a bg_image
    bg_image - the background image that will be rendered
]]
function BaseScreen:new(color, bg_image)
    self.widgets = {}

    self.color = color or {0.5, 0.5, 0.5}
    self.bg_image = bg_image
end

function BaseScreen:mousepressed(x, y, button, istouch, presses)
    for k, v in ipairs(self.widgets) do
        if (v.mousepressed ~= nil)
        then
            v:mousepressed(x, y, button, istouch, presses)
        end
    end
end

function BaseScreen:mousereleased(x, y, button, istouch, presses)
    for k, v in ipairs(self.widgets) do
        if (v.mousereleased ~= nil)
        then
            v:mousereleased(x, y, button, istouch, presses)
        end
    end
end

function BaseScreen:draw()
    for k, v in ipairs(self.widgets) do
        v:draw()
    end
end

function BaseScreen:reset()
    for k, v in ipairs(self.widgets) do
        v:reset()
    end
end

function BaseScreen:update(dt)
    for k, v in ipairs(self.widgets) do
        v:update(dt)
    end
end