TitleScreen = BaseScreen:extend()

function TitleScreen:new()
    TitleScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.widgets = {
        Button("New Game",
        function()
          SCREEN_MAN:changeScreen("setup")
        end,
        540, 140, 200, 100),
        Button("Load Game",
        function()
          local error = loadGame()
          if (error ~= nil) then
            self.widgets[4].visible = true
          else
            SCREEN_MAN:changeScreen("play")
          end
        end,
        540, 260, 200, 100),
        Button("Exit Game",
        function()
          love.event.push('quit')
        end,
        540, 380, 200, 100),
        Label("Load failed.", 540, 380, 100, {1.0, 1.0, 1.0, 1.0}, "left")
    }

    self.widgets[4].visible = false
    
end
