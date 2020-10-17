PlacementScreen = BaseScreen:extend()

function PlacementScreen:new(gridx, gridy)
    PlacementScreen.super.new(self, {0.0, 0.0, 0.0, 1.0}, nil)

    self.cellSize = 50
    self.selectedX = 0
    self.selectedY = 0
    self.gridx = 10
    self.gridy = 10
    self.selectedShip = "none"

    ships = {}
    grid = {}
    for y = 1, self.gridy do
        grid[y] = {}

        for x = 1, self.gridx do
            grid[y][x] = "~"
        end
    end

    self.widgets = {
        Button(
            "Carrier",  -- 5 spaces, C
            function()
                self.selectedShip = "c"
                ships["c"] = Carrier(-1, -1)
            end,
            670, 25, 125, 40  -- x, y, width, height
        ),
        Button(
            "Battleship",  -- 4 spaces
            function()
                self.selectedShip = "b"
                ships["b"] = Battleship(-1, -1)
            end,
            670, 70, 125, 40
        ),
        Button(
            "Cruiser",  -- 3 spaces
            function()
                self.selectedShip = "r"
                ships["r"] = Cruiser(-1, -1)
            end,
            670, 115, 125, 40
        ),
        Button(
            "Submarine",  -- 3 spaces
            function()
                self.selectedShip = "s"
                ships["s"] = Submarine(-1, -1)
            end,
            670, 160, 125, 40
        ),
        Button(
            "Destroyer",  -- 2 spaces
            function()
                self.selectedShip = "d"
                ships["d"] = Destroyer(-1, -1)
            end,
            670, 205, 125, 40
        )
    }
end

function PlacementScreen:placeShip()
    -- If mouse is clicked, within the grid, the ship wont go off the board, and the ship hasn't been placed yet
    if love.mouse.isDown(1) and self.selectedX <= self.gridx and self.selectedY <= self.gridy
            and self.gridy - self.selectedY >= ships[self.selectedShip].length and ships[self.selectedShip].x == -1 then
        -- Check to make sure the ship will not overlap others
        empty = true
        for s = 0, ships[self.selectedShip].length - 1 do
            if grid[self.selectedY + s][self.selectedX] ~= "~" then
                empty = false
                break
            end
        end

        if empty then
            -- Set x and y in ship object
            ships[self.selectedShip].x = self.selectedX
            ships[self.selectedShip].y = self.selectedY

            -- Add ship to grid
            for s = 0, ships[self.selectedShip].length - 1 do
                grid[self.selectedY + s][self.selectedX] = self.selectedShip
            end
        end
    end
end

function PlacementScreen:update()
    self.selectedX = math.floor(love.mouse.getX() / self.cellSize) + 1
    self.selectedY = math.floor(love.mouse.getY() / self.cellSize) + 1

    PlacementScreen.placeShip(self)
end

function PlacementScreen:draw()
    PlacementScreen.super.draw(self)

    -- Build the grid
    for y = 1, self.gridy do
        for x = 1, self.gridx do
            local cellDrawSize = self.cellSize - 1

            -- Set colors for different ships and water
            if x == self.selectedX and y == self.selectedY then
                love.graphics.setColor(0, 1, 1)
            elseif grid[y][x] == "~" then
                love.graphics.setColor(.266, .529, .972)  -- Blue
            else
                love.graphics.setColor(ships[grid[y][x]].color[1], ships[grid[y][x]].color[2],
                        ships[grid[y][x]].color[3])
            end

            -- Make the "pixel"
            love.graphics.rectangle(
                'fill',
                (x - 1) * self.cellSize,
                (y - 1) * self.cellSize,
                cellDrawSize,
                cellDrawSize
            )
        end
    end
end
