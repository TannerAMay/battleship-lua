PlayScreen = BaseScreen:extend()

function PlayScreen:new(color, bg_image)
    PlayScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.cellSize = 50
    self.gridSize = 10

    
    self.widgets = {
        GameGrid(
            0, 0, self.cellSize, self.gridSize, GAME_INFO["playerOne"]["shipGrid"], nil
        ),
        GameGrid(
            600 , 0, self.cellSize, self.gridSize, GAME_INFO["playerTwo"]["shipGrid"], nil
        ),
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
