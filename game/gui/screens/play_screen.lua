PlayScreen = BaseScreen:extend()

function PlayScreen:new(color, bg_image)
    PlayScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.player1 = true
    self.fired = false

    self.cellSize = 50
    self.gridSize = 10

    self.widgets = {
        GameGrid(
            40, 70, self.cellSize, self.gridSize, GAME_INFO["playerOne"]["shipGrid"], nil
        ),
        GameGrid(
            740 , 70, self.cellSize, self.gridSize, GAME_INFO["playerOne"]["hitGrid"], nil,
            function()
                self:fire()
            end
        ),
        Button(
            "Finish turn",
            function()
                if not self.fired then
                    return
                end

                local opponent = "playerTwo"
                self.fired = false

                if not self.player1 then
                    opponent = "playerOne"
                    self.player1 = true
                else
                    self.player1 = false
                end

                self.widgets[1] = GameGrid(40, 70, self.cellSize, self.gridSize,
                    GAME_INFO[opponent]["shipGrid"], nil)
                self.widgets[2] = GameGrid(740 , 70, self.cellSize, self.gridSize,
                    GAME_INFO[opponent]["hitGrid"], nil,
                    function()
                        self:fire()
                    end)
            end,
            540, 648, 200, 50
        ),
        Label(
            "Your ships:",
            190, 40, 200,
            {1.0, 1.0, 1.0, 1.0}, "center"
        ),
        Label(
            "Your shots:",
            895, 40, 200,
            {1.0, 1.0, 1.0, 1.0}, "center"
        ),
        Label(
            (self.player1 and "Player One's Turn") or "Player Two's Turn",
            515, 10, 250,
            {1.0, 1.0, 1.0, 1.0}, "center"
        )
    }
end

function PlayScreen:fire()
    if self.fired then
        return
    end

    local gGrid = self.widgets[2]
    local player = "playerOne"
    local opponent = "playerTwo"

    if not self.player1 then
        player = "playerTwo"
        opponent = "playerOne"
    end

    if gGrid.selectedX ~= -1 and gGrid.selectedY ~= -1
            and GAME_INFO[player]["hitGrid"][gGrid.selectedY][gGrid.selectedX] ~= "h"
    then
        self.fired = true

        GAME_INFO[player]["hitGrid"][gGrid.selectedY][gGrid.selectedX] = "h"
        GAME_INFO[opponent]["shipGrid"][gGrid.selectedY][gGrid.selectedX] = "h"
        GAME_INFO[opponent]["health"] = GAME_INFO[opponent]["health"] - 1

        if GAME_INFO[opponent]["health"] == 0 then
            --[[Switch to ending screen]]
        end
    end
end

function PlayScreen:load()
    missed = love.graphics.newImage('game/overlays/miss.png')
end

function PlayScreen:update()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    local gGrid = self.widgets[2]

    if (checkRectCollision(mouseX, mouseY, gGrid.x, gGrid.y, 
        gGrid.gridx*gGrid.cellSize, gGrid.gridy*gGrid.cellSize )) then
            gGrid.selectedX = math.floor((mouseX - gGrid.x) / gGrid.cellSize) + 1
            gGrid.selectedY = math.floor((mouseY - gGrid.y) / gGrid.cellSize) + 1
    else
            gGrid.selectedX = -1
            gGrid.selectedY = -1
    end
end

function PlayScreen:drawOverlay()
    local gGrid = self.widgets[2]

    print("Missed")

    GAME_INFO["playerTwo"]["shipGrid"][gGrid.selectedY][gGrid.selectedX] = "~"

end
