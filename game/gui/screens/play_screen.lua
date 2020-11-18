PlayScreen = BaseScreen:extend()

function PlayScreen:new(color, bg_image)
    PlayScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.player1 = true

    self.cellSize = 50
    self.gridSize = 10

    self.widgets = {
        GameGrid(
            40, 40, self.cellSize, self.gridSize, GAME_INFO["playerOne"]["shipGrid"], nil
        ),
        GameGrid(
            740 , 40, self.cellSize, self.gridSize, GAME_INFO["playerOne"]["hitGrid"], nil
        ),
        Button(
            "Finish turn",
            function()
                if self.player1 then
                    self.widgets[1] = GameGrid(40, 40, self.cellSize, self.gridSize,
                            GAME_INFO["playerTwo"]["shipGrid"], nil)
                    self.widgets[2] = GameGrid(740 , 40, self.cellSize, self.gridSize,
                            GAME_INFO["playerTwo"]["hitGrid"], nil)
                    self.player1 = false
                else
                    self.widgets[1] = GameGrid(40, 40, self.cellSize, self.gridSize,
                            GAME_INFO["playerOne"]["shipGrid"], nil)
                    self.widgets[2] = GameGrid(740 , 40, self.cellSize, self.gridSize,
                            GAME_INFO["playerOne"]["hitGrid"], nil)
                    self.player1 = true
                end

            end,
            540, 648, 200, 50
        ),
        Label(
            "Your ships:",
            190, 10, 200,
            {1.0, 1.0, 1.0, 1.0}, "center"
        ),
        Label(
            "Your shots:",
            895, 10, 200,
            {1.0, 1.0, 1.0, 1.0}, "center"
        )
    }
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
