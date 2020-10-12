ScreenManager = Object:extend()

function ScreenManager:new()
    self.screens = {
        ["title"] = TitleScreen(),
        ["setup"] = SetupScreen(),
        ["pause"] = PauseScreen(),
        ["game"] = GameScreen()
    }
    
    self.last_screen = nil
    self:changeScreen("title")
end

function ScreenManager:mousepressed(x, y, button, istouch, presses)
    self.cur_screen:mousepressed(x, y, button, istouch, presses)
end

function ScreenManager:mousereleased(x, y, button, istouch, presses)
    self.cur_screen:mousereleased(x, y, button, istouch, presses)
end

function ScreenManager:changeScreen(screen_name)
    self.cur_screen = self.screens[screen_name]
    love.graphics.setBackgroundColor(self.cur_screen.color[1], self.cur_screen.color[2], self.cur_screen.color[3], 1.0)

    self.cur_screen:reset()
end