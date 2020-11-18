function AIPlaceShips(playerStr, gridSize)
    local widgetTable = {
        [1] = "c",
        [2] = "b",
        [3] = "r",
        [4] = "s",
        [5] = "d"
    }
    
    local shipProgress = 1
    while shipProgress < 6 do
        local selectedShip = widgetTable[shipProgress]

        --randomly assigns the posistion of each ship
        local selectedX = love.math.random(1,10)
        local selectedY = love.math.random(1,10)

        --randomly assigns the rotation of each ship
        local rotation = love.math.random(1,2)
        if rotation == 2 then
            GAME_INFO[playerStr]["ships"][selectedShip].rotate(GAME_INFO[playerStr]["ships"][selectedShip])
        end

        if selectedShip ~= "none" and GAME_INFO[playerStr]["ships"][selectedShip].x == -1
            and selectedX ~= -1 and selectedY ~= -1
            and gridSize - selectedX + 1 >= GAME_INFO[playerStr]["ships"][selectedShip].width
            and gridSize - selectedY + 1 >= GAME_INFO[playerStr]["ships"][selectedShip].length
        then
            -- If all spaces are open
            if canPlaceShip(selectedX, selectedY, GAME_INFO[playerStr]["ships"][selectedShip],
                GAME_INFO[playerStr]["shipGrid"])
            then
                -- Set x and y in ship object
                GAME_INFO[playerStr]["ships"][selectedShip].x = selectedX
                GAME_INFO[playerStr]["ships"][selectedShip].y = selectedY
                shipProgress = shipProgress + 1

                -- Add ship to grid
                for l = 0, GAME_INFO[playerStr]["ships"][selectedShip].length - 1 do
                    for w = 0, GAME_INFO[playerStr]["ships"][selectedShip].width - 1 do
                        GAME_INFO[playerStr]["shipGrid"][selectedY + l][selectedX + w] = selectedShip
                    end
                end
            end
        end
    end

    -- Clears selected box on grid
    selectedX = -1
    selectedY = -1
end
