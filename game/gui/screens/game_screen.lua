GameScreen = BaseScreen:extend()

function GameScreen:new(color, bg_image)
    GameScreen.super.new(self, {.3, .5, .3, 1.0}, nil)
end