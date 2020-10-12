TitleScreen = BaseScreen:extend()

function TitleScreen:new()
    TitleScreen.super.new(self)

    self.widgets = {
        Button("Hello",
        function()
            SCREEN_MAN:changeScreen("setup")
        end,
        20, 20, 200, 100),
        Button("Exit Game",
        function()
            love.event.push('quit')
        end,
        20, 140, 200, 100)
    }
    
end
