GameScreen = BaseScreen:extend()

function GameScreen:new(color, bg_image)
    GameScreen.super.new(self, {.3, .5, .3, 1.0}, nil)

    self.cellSize = 50
    self.selectedX = 0
    self.selectedY = 0
    self.gridx = 10
    self.gridy = 10

    eships = {
        ["c"] = Carrier(-1, -1),
        ["b"] = Battleship(-1, -1),
        ["r"] = Cruiser(-1, -1),
        ["s"] = Submarine(-1, -1),
        ["d"] = Destroyer(-1, -1)
    }

    egrid = {}
    for y = 1, self.gridy do
        egrid[y] = {}

        for x = 1, self.gridx do
            egrid[y][x] = "~"
        end
    end
    
    GameScreen.placeShip(self)
end

function GameScreen:placeShip()
    self.dx = love.math.random(10)
    self.dy = love.math.random(10)

    self.shipLetter = {"c"}
    for i, selectedShip in ipairs(self.shipLetter) do
        self.dx = love.math.random(1,10)
        self.dy = love.math.random(1,10)
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

    end
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
    self.selectedX = math.floor(love.mouse.getX() / self.cellSize) + 1
    self.selectedY = math.floor(love.mouse.getY() / self.cellSize) + 1
end

function GameScreen:draw()
    GameScreen.super.draw(self)

    -- Build the grid
    for y = 1, self.gridy do
        for x = 1, self.gridx do
            local cellDrawSize = self.cellSize - 1

            -- Set colors for different ships and water
            if x == self.selectedX and y == self.selectedY then
                love.graphics.setColor(0, 1, 1)
            elseif egrid[y][x] == "~" then
                love.graphics.setColor(.266, .529, .972)  -- Blue
            else
                love.graphics.setColor(eships[egrid[y][x]].color[1], eships[egrid[y][x]].color[2],
                        eships[egrid[y][x]].color[3])
            end

            -- Make the "pixel"
            love.graphics.rectangle(
                'fill',
                (x - 1) * self.cellSize,
                (y - 1) * self.cellSize,
                cellDrawSize,
                cellDrawSize
            )
            

            love.graphics.setColor(0,0,0)
            --love.graphics.print('selected x: '..self.selectedX..' selected y: '..self.selectedY..' dx: '..self.dx..' dy: '..self.dy)
            love.graphics.print(egrid[y][x])
            love.graphics.setColor(1,1,1)
        end
    end
end