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
            0 ,0, self.cellSize, self.gridSize, self:getGrid(), nil,
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
    }
    
    self.shipProgress = 1
    GameScreen.placeShip(self)
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
    
    --[[
    self.dx = love.math.random(10)
    self.dy = love.math.random(10)

    self.shipLetter = {"c", "b"}
    for i, selectedShip in ipairs(self.shipLetter) do
        self.dx = love.math.random(10)
        self.dy = love.math.random(10)
        egrid[self.dy][self.dx] = selectedShip
         -- Check to make sure the ship will not overlap others when placed vertically
        self.empty = true
        for s = 0, eships[selectedShip].length - 1 do
            if egrid[self.dy + s][self.dx] ~= "~" then
                self.empty = false
                break
            end
        end
        -- Check to make sure the ship will not overlap others when placed horizontal
        for k = 0, eships[selectedShip].width - 1 do 
            if egrid[self.dy][self.dx+ k] ~= "~" then
                self.empty = false
                break
            end
        end
        --self.empty = true

        -- If all spaces are open
         if self.empty then
            -- Set x and y in ship object
            eships[selectedShip].x = self.dx
            eships[selectedShip].y = self.dy

            -- Add ship to grid
            for l = 0, eships[selectedShip].length - 1 do
                for w = 0, eships[selectedShip].width - 1 do
                    egrid[self.dy + l][self.dx + w] = selectedShip
                end
            end
        end
        
    end ]]
    --[[
        -- Check to make sure the ship will not overlap others when placed vertically
        empty = true
        for s = 0, ships[self.selectedShip].length - 1 do
            if grid[self.selectedY + s][self.selectedX] ~= "~" then
                empty = false
                break
            end
        end

        -- Check to make sure the ship will not overlap others when placed horizontal
        for k = 0, ships[self.selectedShip].width - 1 do 
            if grid[self.selectedY][self.selectedX + k] ~= "~" then
                empty = false
                break
            end
        end


        -- If all spaces are open
        if empty then
            -- Set x and y in ship object
            ships[self.selectedShip].x = self.selectedX
            ships[self.selectedShip].y = self.selectedY

            -- Add ship to grid
            for l = 0, ships[self.selectedShip].length - 1 do
                for w = 0, ships[self.selectedShip].width - 1 do
                    grid[self.selectedY + l][self.selectedX + w] = self.selectedShip
                end
            end
        end
    end
    ]]
end


function GameScreen:update()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    local gGrid = self.widgets[1]

    --[[
    if (checkRectCollision(mouseX, mouseY, gGrid.x, gGrid.y, 
        gGrid.gridx*gGrid.cellSize, gGrid.gridy*gGrid.cellSize )) then
            gGrid.selectedX = math.floor((mouseX - gGrid.x) / gGrid.cellSize) + 1
            gGrid.selectedY = math.floor((mouseY - gGrid.y) / gGrid.cellSize) + 1
    else
            gGrid.selectedX = -1
            gGrid.selectedY = -1
    end
    ]]
end

function GameScreen:getGrid()
    return GAME_INFO["computer"]["shipGrid"]
end

function GameScreen:getShips()
    return GAME_INFO["computer"]["ships"]
  end