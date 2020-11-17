GameGrid = Object:extend()

--[[
    Widget form of the grid that was found on PlacementScreen.
    This way we can use the same grid for the GameScreen as well.

    Parameters:
        x: X position of the grid. Default:0
        y: Y position of the grid. Default:0
        cellSize: The width and height of a cell in the grid. Default: 50
        gridSize: The number of cells in the grid. Default: 10
        grid: the data table that this is reflecting. Default: nil
        onClick: The function that is called when a cell is clicked on.
]]
function GameGrid:new(x, y, cellSize, gridSize, grid, hitGrid, onClick)
    -- Actual position on screen
    self.x = x or 0
    self.y = y or 0

    self.cellSize = cellSize or 50
    self.gridx = gridSize or 10
    self.gridy = gridSize or 10

    self.grid = grid
    self.hitGrid = hitGrid

    -- Position of selected cell
    self.selectedX = -1
    self.selectedY = -1

    self.onClick = onClick or function () 
        print(string.format("X:%d Y:%d", self.selectedX, self.selectedY)) 
    end

    if (not self.grid) then
        self:initGrid()
        print("WARNING: GameGrid not actually connected to a pre-existing grid. Changes may not do anything.")
    end

    if (not self.hitGrid) then
        self:initHitgrid()
        print("WARNING: GameGrid not actually connected to a pre-existing hitgrid. Changes may not do anything.")
    end
end

function GameGrid:mousepressed(x, y, button, istouch, presses)
    if (checkRectCollision(x, y, self.x, self.y, self.gridx * self.cellSize, self.gridy * self.cellSize)) then
        self.onClick()
    end
end

function GameGrid:reset()
end

function GameGrid:update()
end

function GameGrid:draw()
    -- Build the grid
    for y = 1, self.gridy do
        for x = 1, self.gridx do
            local cellDrawSize = self.cellSize - 1 -- This way there is a gap between the sqaures

            -- Set colors for different ships and water
            if x == self.selectedX and y == self.selectedY then
                love.graphics.setColor(0, 1, 1)
            elseif self.grid[y][x] == "~" then
                love.graphics.setColor(.266, .529, .972)
            elseif self.grid[y][x] == "c" then
                love.graphics.setColor(.972, .67, .266)
            elseif self.grid[y][x] == "b" then
                love.graphics.setColor(.972, .266, .603)
            elseif self.grid[y][x] == "r" then
                love.graphics.setColor(.694, .972, .266)
            elseif self.grid[y][x] == "s" then
                love.graphics.setColor(.266, .972, .611)
            elseif self.grid[y][x] == "d" then
                love.graphics.setColor(.960, .266, .972)
            end

            -- Make the "pixel"
            love.graphics.rectangle(
                'fill',
                self.x + (x - 1) * self.cellSize,
                self.y + (y - 1) * self.cellSize,
                cellDrawSize,
                cellDrawSize
            )
        end
    end
end

function GameGrid:initGrid()
    -- Resets the grid
    self.grid = {}
    for y=1, self.gridy do
        self.grid[y] = {}
        for x=1, self.gridx do
            self.grid[y][x] = "~"
        end
    end
end

function GameGrid:initHitgrid()
    self.hitGrid = {}
    for y=1, self.gridy do
        self.hitGrid[y] = {}
        for x=1, self.gridx do
            self.hitGrid[y][x] = "~"
        end
    end
end