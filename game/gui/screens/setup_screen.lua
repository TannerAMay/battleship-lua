SetupScreen = BaseScreen:extend()

function SetupScreen:new()
    SetupScreen.super.new(self, {.3, .3, .5, 1.0}, nil)

    self.widgets = {
        Button(
            "Back to Title",
            function()
                SCREEN_MAN:changeScreen("title")
            end,
            2, 548, 200, 50
        ),
        Label(
            "Difficulty:",
            0, 0, 100, {1.0, 1.0, 1.0, 1.0}, "left"
        ),
        Label(
            "",
            100, 0, 100, {1.0, 1.0, 1.0, 1.0}, "left"
        ),
        Label(
            "Gamemode:",
            440, 0, 200, {1.0, 1.0, 1.0, 1.0}, "left"
        ),
        Label(
            "",
            565, 0, 200, {1.0, 1.0, 1.0, 1.0}, "left"
        ),
        Button(
            "Player vs Player",
            function()
                self:changeMode("PlayerPlayer")
            end,
            440, 25, 300, 40
        ),
        Button(
            "Player vs Computer",
            function()
                self:changeMode("PlayerComputer")
            end,
            440, 70, 300, 40
        ),
        Button(
            "Computer vs Computer",
            function()
                self:changeMode("ComputerComputer")
            end,
            440, 115, 300, 40
        ),
        Button(
            "Easy",
            function()
                self:changeDiff(false)
            end,
            2, 25, 150, 40
        ),
        Button(
            "Hard",
            function()
                self:changeDiff(true)
            end,
            2, 70, 150, 40
        ),
        Button(
            "Start",
            function()
                GAME_INFO["isAiHardmode"] = self.hard_mode
                GAME_INFO["gamemode"] = self.gamemode
                SCREEN_MAN:changeScreen("placement")
            end,
            440, 548, 150, 40
        )
    }

    self.gamemode = "none"
    self.hard_mode = nil

    self:changeDiff(false)
    self:changeMode("PlayerComputer")
end

function SetupScreen:changeDiff(is_hard)
    self.hard_mode = is_hard
    if (self.hard_mode)
    then
        self.widgets[3].text = "Hard"
    else
        self.widgets[3].text = "Easy"
    end
end

function SetupScreen:changeMode(new_mode)
    self.gamemode = new_mode
    self.widgets[5].text = self.gamemode

    if (self.gamemode == "PlayerPlayer")
    then
        self.widgets[9].enabled = false
        self.widgets[10].enabled = false
    else
        self.widgets[9].enabled = true
        self.widgets[10].enabled = true
    end
end