function checkRectCollision(checkX, checkY, x, y, width, height)
    if (checkX < x or checkX > x+width or checkY < y or checkY > y + height)
    then
        return false
    end
    
    return true
end

function canPlaceShip(cellX, cellY, ship, grid)
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