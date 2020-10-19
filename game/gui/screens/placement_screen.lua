--Screen for Ship Placement

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

    rotateSwitch = {
        ["c"] = function()
            if ships[self.selectedShip].width > 1 then
                self.widgets[8].text = "H"
            else
                self.widgets[8].text = "V"
            end
        end,
        ["b"] = function()
            if ships[self.selectedShip].width > 1 then
                self.widgets[9].text = "H"
            else
                self.widgets[9].text = "V"
            end
        end,
        ["r"] = function()
            if ships[self.selectedShip].width > 1 then
                self.widgets[10].text = "H"
            else
                self.widgets[10].text = "V"
            end
        end,
        ["s"] = function()
            if ships[self.selectedShip].width > 1 then
                self.widgets[11].text = "H"
            else
                self.widgets[11].text = "V"
            end
        end,
        ["d"] = function()
            if ships[self.selectedShip].width > 1 then
                self.widgets[12].text = "H"
            else
                self.widgets[12].text = "V"
            end
        end
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
            "Carrier (5)",
            function()
                self.selectedShip = "c"

                self:updateShipButtonColor(1)
            end,
            645, 25, 150, 40  -- x, y, width, height
        ),
        Button(
            "Battleship (4)",
            function()
                self.selectedShip = "b"

                self:updateShipButtonColor(2)
            end,
            645, 70, 150, 40  -- x, y, width, height
        ),
        Button(
            "Cruiser (3)",
            function()
                self.selectedShip = "r"

                self:updateShipButtonColor(3)
            end,
            645, 115, 150, 40  -- x, y, width, height
        ),
        Button(
            "Submarine (3)",
            function()
                self.selectedShip = "s"
                
                self:updateShipButtonColor(4)
            end,
            645, 160, 150, 40  -- x, y, width, height
        ),
        Button(
            "Destroyer (2)",
            function()
                self.selectedShip = "d"
                
                self:updateShipButtonColor(5)
            end,
            645, 205, 150, 40  -- x, y, width, height
        ),
        Button(
            "Rotate",
            function()
                if self.selectedShip ~= "none" and ships[self.selectedShip].x == -1 then
                    ships[self.selectedShip].rotate(ships[self.selectedShip])
                    if self.selectedShip == "c" then
                        rotateSwitch["c"]()
                    end
                    if self.selectedShip == "b" then
                        rotateSwitch["b"]()
                    end
                    if self.selectedShip == "r" then
                        rotateSwitch["r"]()
                    end
                    if self.selectedShip == "s" then
                        rotateSwitch["s"]()
                    end
                    if self.selectedShip == "d" then
                        rotateSwitch["d"]()
                    end
                end
            end,
            645, 250, 150, 40  -- x, y, width, height
        ),
        Button(
            "Remove",
            function()
                if self.selectedShip ~= "none" then
                    for y = 1, self.gridy do
                        for x = 1, self.gridx do
                            if grid[x][y] == self.selectedShip then
                                -- clears ship id from board and sets the posistion back to the intitial state
                                -- currently keeps current ship rotation 
                                grid[x][y] = "~" 
                                ships[self.selectedShip].x = -1 
                                ships[self.selectedShip].y = -1
                            end
                        end
                    end
                end
            end,
            645, 295, 150, 40  -- x, y, width, height
        ),
        Label(
            "V",
            625, 25, 25, {1.0, 1.0, 1.0, 1.0}, "left" -- x, y, width, color, align
        ),
        Label(
            "V",
            625, 70, 25, {1.0, 1.0, 1.0, 1.0}, "left" -- x, y, width, color, align
        ),
        Label(
            "V",
            625, 115, 25, {1.0, 1.0, 1.0, 1.0}, "left" -- x, y, width, color, align
        ),
        Label(
            "V",
            625, 160, 25, {1.0, 1.0, 1.0, 1.0}, "left" -- x, y, width, color, align
        ),
        Label(
            "V",
            625, 205, 25, {1.0, 1.0, 1.0, 1.0}, "left" -- x, y, width, color, align
        ),

    }
end

function PlacementScreen:placeShip()
    -- If mouse is clicked, within the grid, the ship wont go off the board, and the ship hasn't been placed yet
    if love.mouse.isDown(1) --mouse clicked
            and self.selectedX <= self.gridx and self.selectedY <= self.gridy -- mouse within grid
            and self.selectedShip ~= "none" -- a ship is actually selected to be placed
            and self.gridy - self.selectedY + 1 >= ships[self.selectedShip].length -- the ship's length does not exit the grid
            and self.gridx - self.selectedX + 1 >= ships[self.selectedShip].width -- the ship's width does not exit the grid
            and ships[self.selectedShip].x == -1 then 

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

--[[
    Meant to update all of the ship select buttons to reflect which one is selected currently.

    Parameters:
        btnSelected - The index of the button that has a ship selected now. Should be [1-5]
]]
function PlacementScreen:updateShipButtonColor(btnSelected)
    if (self.selectedShip == nil) then -- No idea how this could happen, but just in case.
        return
    end

    for i=1, 5 do
        self.widgets[i].color = {0.2, 0.2, 0.8, 1.0}
    end

    self.widgets[btnSelected].color = ships[self.selectedShip].color
end