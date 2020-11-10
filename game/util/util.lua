function checkRectCollision(checkX, checkY, x, y, width, height)
    if (checkX < x or checkX > x+width or checkY < y or checkY > y + height)
    then
        return false
    end
    
    return true
end

--[[
    A function to check if a ship is in a valid placement location

    Parameters:
        cellX: the selected cell x position
        cellY: the selected cell y position
        ship: the ship to be placed
        grid: the shipGrid to place the ship on
]]
function canPlaceShip(cellX, cellY, ship, grid)
    if cellY + ship.length >= #grid then
        return false
    if cellX + ship.width >= #grid[1] then
        return false
    for dx = 0, ship.width - 1 do
        if grid[cellY][cellX + dx] ~= "~" then
            return false
        end
    end

    for dy = 0, ship.length - 1 do
        if grid[cellY + dy][cellX] ~= "~" then
            return false
        end
    end

    return true
end

--[[
    A quick and dirty function to quickly construct a square grid

    Parameters:
        rows: the number of rows in the grid
        cols: the number of cols in the grid
        fill: the element to insert into the newly created grid.
]]
function makeGrid(rows, cols, fill)
    local grid = {}
    local row = nil

    for i = 1, rows do
        row = {}
        for j = 1, cols do
            row[j] = fill
        end
        grid[i] = row
    end

    return grid
end