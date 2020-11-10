--Screen for Ship Placement

PlacementScreen = BaseScreen:extend()

function PlacementScreen:new(gridx, gridy)
    PlacementScreen.super.new(self, {0.0, 0.0, 0.0, 1.0}, nil)

    self.cellSize = 50
    self.gridSize = 10

    -- Checks if player one is the active player for placement screen
    self.isOneSelected = true

    self.selectedShip = "none"
    local rotateSwitch = function()
        local widgetTable = {
            ["c"] = 8,
            ["b"] = 9,
            ["r"] = 10,
            ["s"] = 11,
            ["d"] = 12
        }
        if self:getShips()[self.selectedShip].width > 1 then
            self.widgets[widgetTable[self.selectedShip]].text = "H"
        else
            self.widgets[widgetTable[self.selectedShip]].text = "V"
        end
    end

    local startBtnText = nil
    if (GAME_INFO == "PlayerComputer") then
      startBtnText = "Start Game"
    else
      startBtnText = "Next Player"
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
                if self.selectedShip ~= "none" and self:getShips()[self.selectedShip].x == -1 then
                    self:getShips()[self.selectedShip].rotate(self:getShips()[self.selectedShip])
                    rotateSwitch()
                end
            end,
            645, 250, 150, 40  -- x, y, width, height
        ),
        Button(
            "Remove",
            function()
                if self.selectedShip ~= "none" then
                    for y = 1, #self:getGrid() do
                        for x = 1, #self:getGrid()[1] do
                            if self:getGrid()[x][y] == self.selectedShip then
                                -- clears ship id from board and sets the posistion back to the intitial state
                                -- currently keeps current ship rotation 
                                self:getGrid()[x][y] = "~" 
                                self:getShips()[self.selectedShip].x = -1 
                                self:getShips()[self.selectedShip].y = -1
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
        GameGrid(
            0 ,0, self.cellSize, self.gridSize, self:getGrid(), nil,
            function()
                self:newPlaceShip()
            end
        ),
        Button(
            "Start Game",
            function()
                SCREEN_MAN:changeScreen("game")
            end,
            645, 340, 150, 40  -- x, y, width, height
        ),
        Label(
          "Player One",
          220, 520, 100,
          {1.0, 1.0, 1.0, 1.0}, "center"
        ),
        Button(
          ">",
          function()
            self:changePlayer()
          end,
          340, 520, 20, 50
        ),
        Button(
          "<",
          function()
            self:changePlayer()
          end,
          180, 520, 20, 50
        )
    }
end

function PlacementScreen:newPlaceShip()
    local gGrid = self.widgets[13] -- Just to make code cleaner

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

            -- Add ship to grid
            for l = 0, self:getShips()[self.selectedShip].length - 1 do
                for w = 0, self:getShips()[self.selectedShip].width - 1 do
                    self:getGrid()[gGrid.selectedY + l][gGrid.selectedX + w] = self.selectedShip
                end
            end
        end
    end
end

function PlacementScreen:reset()
  if GAME_INFO["gamemode"] ~= "PlayerPlayer" then
    self.widgets[16].visible = false
    self.widgets[16].enabled = false

    self.widgets[17].visible = false
    self.widgets[17].enabled = false
  else
    self.widgets[16].visible = true
    self.widgets[16].enabled = true

    self.widgets[17].visible = true
    self.widgets[17].enabled = true
  end
end

function PlacementScreen:update()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()
    local gGrid = self.widgets[13]

    if (checkRectCollision(mouseX, mouseY, gGrid.x, gGrid.y, 
        gGrid.gridx*gGrid.cellSize, gGrid.gridy*gGrid.cellSize )) then
            gGrid.selectedX = math.floor((mouseX - gGrid.x) / gGrid.cellSize) + 1
            gGrid.selectedY = math.floor((mouseY - gGrid.y) / gGrid.cellSize) + 1
    else
            gGrid.selectedX = -1
            gGrid.selectedY = -1
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

    self.widgets[btnSelected].color = self:getShips()[self.selectedShip].color
end

function PlacementScreen:changePlayer()
  if (GAME_INFO["gamemode"] ~= "PlayerPlayer") then
    return
  end
  self.isOneSelected = not (self.isOneSelected)

  self.widgets[13].grid = self:getGrid()
  self.widgets[15].text = (self.isOneSelected and "Player One") or "Player Two"
end

function PlacementScreen:getGrid()
  if self.isOneSelected then
    return GAME_INFO["playerOne"]["shipGrid"]
  end
  return GAME_INFO["playerTwo"]["shipGrid"]
end

function PlacementScreen:getShips()
  if self.isOneSelected then
    return GAME_INFO["playerOne"]["ships"]
  end
  return GAME_INFO["playerTwo"]["ships"]
end