PlacementScreen = BaseScreen:extend()

function PlacementScreen:new(gridx, gridy)
    PlacementScreen.super.new(self, {0.0, 0.0, 0.0, 1.0}, nil)

    self.cellSize = 50
    self.selectedX = 0
    self.selectedY = 0
    self.gridx = 10
    self.gridy = 10
    self.selectedShip = "none"

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
            end,
            470, 25, 300, 40  -- x, y, width, height
        ),
        Button(
            "Battleship",  -- 4 spaces
            function()
                self.selectedShip = "b"
            end,
            470, 70, 300, 40
        ),
        Button(
            "Cruiser",  -- 3 spaces
            function()
                self.selectedShip = "r"
            end,
            470, 115, 300, 40
        ),
        Button(
            "Submarine",  -- 3 spaces
            function()
                self.selectedShip = "s"
            end,
            470, 160, 300, 40
        ),
        Button(
            "Destroyer",  -- 2 spaces
            function()
                self.selectedShip = "d"
            end,
            470, 205, 300, 40
        )
    }
end

function PlacementScreen:update()
    self.selectedX = math.floor(love.mouse.getX() / self.cellSize) + 1
    self.selectedY = math.floor(love.mouse.getY() / self.cellSize) + 1

    if love.mouse.isDown(1) and self.selectedX <= self.gridx and self.selectedY <= self.gridy then
        grid[self.selectedY][self.selectedX] = self.selectedShip
    end
end

function PlacementScreen:draw()
    PlacementScreen.super.draw(self)

    -- Build the grid
    for y = 1, self.gridy do
        for x = 1, self.gridx do
            local cellDrawSize = self.cellSize - 1

            if x == self.selectedX and y == self.selectedY then
                love.graphics.setColor(0, 1, 1)
            elseif grid[y][x] == "~" then
                love.graphics.setColor(.266, .529, .972)
            elseif grid[y][x] == "c" then
                love.graphics.setColor(.972, .67, .266)
            elseif grid[y][x] == "b" then
                love.graphics.setColor(.972, .266, .603)
            elseif grid[y][x] == "r" then
                love.graphics.setColor(.694, .972, .266)
            elseif grid[y][x] == "s" then
                love.graphics.setColor(.266, .972, .611)
            elseif grid[y][x] == "d" then
                love.graphics.setColor(.960, .266, .972)
            else
                love.graphics.setColor(.86, .86, .86)
            end

            love.graphics.rectangle(
                'fill',
                (x - 1) * self.cellSize,
                (y - 1) * self.cellSize,
                cellDrawSize,
                cellDrawSize
            )
        end
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.print('selected x: '..self.selectedX..', selected y: '..self.selectedY)
end
