GameScreen = BaseScreen:extend()

function GameScreen:new(color, bg_image)
    GameScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.cellSize = 50
    self.gridSize = 10
    self.selectedX = 0
    self.selectedY = 0
    self.gridx = 10
    self.gridy = 10

    self.selectedShip = "none"
    

    self.widgets = {
        GameGrid(
            0 , 0, self.cellSize, self.gridSize, self:getGrid(), nil,
            function()
                print("Clicking Works")
            end
        ),
        Button(
            "Back to Placement",
            function()
                SCREEN_MAN:changeScreen("placement")
            end,
            2, 548, 200, 50
        ),
        Button(
            "To Play Screen",
            function()
                SCREEN_MAN:changeScreen("play")
            end,
            300, 548, 200, 50
        )
    }
    
    self.shipProgress = 1
    --GameScreen.placeShip(self)
end

function GameScreen:placeShip()
    
    local gGrid = self.widgets[1] -- Just to make code cleaner

    local widgetTable = {
        [1] = "c",
        [2] = "b",
        [3] = "r",
        [4] = "s",
        [5] = "d"
    }

    while self.shipProgress < 6 do

        self.selectedShip = widgetTable[self.shipProgress]

        --randomly assigns the posistion of each ship
        gGrid.selectedX = love.math.random(1,10)
        gGrid.selectedY = love.math.random(1,10)

        --randomly assigns the rotation of each ship
        self.rotation = love.math.random(1,2)
        if self.rotation == 2 then
            self:getShips()[self.selectedShip].rotate(self:getShips()[self.selectedShip])
        end

        if self.selectedShip ~= "none" and self:getShips()[self.selectedShip].x == -1
            and gGrid.selectedX ~= -1 and gGrid.selectedY ~= -1
            and gGrid.gridx - gGrid.selectedX + 1 >= self:getShips()[self.selectedShip].width
            and gGrid.gridy - gGrid.selectedY + 1 >= self:getShips()[self.selectedShip].length
        then

            -- If all spaces are open
            if canPlaceShip(gGrid.selectedX, gGrid.selectedY, self:getShips()[self.selectedShip], self:getGrid()) then
                -- Set x and y in ship object
                self:getShips()[self.selectedShip].x = gGrid.selectedX
                self:getShips()[self.selectedShip].y = gGrid.selectedY
                self.shipProgress = self.shipProgress + 1

                -- Add ship to grid
                for l = 0, self:getShips()[self.selectedShip].length - 1 do
                    for w = 0, self:getShips()[self.selectedShip].width - 1 do
                        self:getGrid()[gGrid.selectedY + l][gGrid.selectedX + w] = self.selectedShip
                        
                    end
                end
            end
        end
    end

    -- Clears selected box on grid
    gGrid.selectedX = -1
    gGrid.selectedY = -1
    

end


function GameScreen:update()
    local gGrid = self.widgets[1]
end

function GameScreen:getGrid()
    return GAME_INFO["playerTwo"]["shipGrid"]
end

function GameScreen:getShips()
    return GAME_INFO["playerTwo"]["ships"]
  end