PlacementScreen = BaseScreen:extend()

function PlacementScreen:new(gridx, gridy)
    PlacementScreen.super.new(self, {0.0, 0.0, 0.0, 1.0}, nil)

    self.cellSize = 50
    self.selectedX = 0
    self.selectedY = 0
    self.gridx = 10
    self.gridy = 10
    self.selectedShip = "none"

    ships = {
        ["c"] = Carrier(-1, -1),
        ["b"] = Battleship(-1, -1),
        ["r"] = Cruiser(-1, -1),
        ["s"] = Submarine(-1, -1),
        ["d"] = Destroyer(-1, -1)
    }

    grid = {}
    for y = 1, self.gridy do
        grid[y] = {}

        for x = 1, self.gridx do
            grid[y][x] = "~"
        end
    end

    self.widgets = {
        Button(
            "Carrier",
            function()
                self.selectedShip = "c"
            end,
            670, 25, 125, 40  -- x, y, width, height
        ),
        Button(
            "Battleship",
            function()
                self.selectedShip = "b"
            end,
            670, 70, 125, 40
        ),
        Button(
            "Cruiser",
            function()
                self.selectedShip = "r"
            end,
            670, 115, 125, 40
        ),
        Button(
            "Submarine",
            function()
                self.selectedShip = "s"
            end,
            670, 160, 125, 40
        ),
        Button(
            "Destroyer",
            function()
                self.selectedShip = "d"
            end,
            670, 205, 125, 40
        ),
        Button(
            "Rotate",
            function()
                if self.selectedShip ~= "none" and ships[self.selectedShip].x == -1 then
                    ships[self.selectedShip].rotate(ships[self.selectedShip])
                end
            end,
            670, 250, 125, 40
        ),
        Button(
            "Start game!",
            function()
                SCREEN_MAN:changeScreen("game")
            end,
            670, 548, 125, 40
        )
    }
end

function PlacementScreen:placeShip()
    -- If mouse is clicked, within the grid, the ship wont go off the board, the ship hasn't been placed yet,
    -- and a ship is selected
    if love.mouse.isDown(1) and self.selectedX <= self.gridx and self.selectedY <= self.gridy
            and self.selectedShip ~= "none"
            and self.gridy - self.selectedY + 1 >= ships[self.selectedShip].length
            and self.gridx - self.selectedX + 1 >= ships[self.selectedShip].width
            and ships[self.selectedShip].x == -1 then
        -- Check to make sure the ship will not overlap others
        for s = 0, ships[self.selectedShip].length - 1 do
            if grid[self.selectedY + s][self.selectedX] ~= "~" then
                return
            end
        end

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
