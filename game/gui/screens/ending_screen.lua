EndingScreen = BaseScreen:extend()

function EndingScreen:new(color, bg_image)
    EndingScreen.super.new(self, {.3, .5, .3, 1.0}, nil)
end