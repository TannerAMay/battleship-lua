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

        --randomly assigns the position of each ship
        local selectedX = love.math.random(1,gridSize)
        local selectedY = love.math.random(1,gridSize)

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

function AIFire(hitGrid, gridSize, lastX, lastY)
    if GAME_INFO["isAiHardmode"] then
        return AIHardFire(hitGrid, gridSize, lastX, lastY)
    else
        return AIEasyFire(hitGrid, gridSize)
    end
end

function AIEasyFire(hitGrid, gridSize)
    local selectedX = -1
    local selectedY = -1

    while selectedX == -1 or hitGrid[selectedY][selectedX] == "h" do
        selectedX = love.math.random(1,gridSize)
        selectedY = love.math.random(1,gridSize)
    end

    return {selectedX, selectedY}
end

function AIHardFire(hitGrid, gridSize, lastX, lastY)
    if GAME_INFO["playerTwo"]["previousShot"] == "miss" then
        local selectedX = -1
        local selectedY = -1

        while selectedX == -1 or hitGrid[selectedY][selectedX] == "h" or hitGrid[selectedY][selectedX] == "p" do
            selectedX = love.math.random(1,gridSize)
            selectedY = love.math.random(1,gridSize)
        end

        print(selectedX, selectedY)
        lastX = selectedX
        lastY = selectedY
        return {selectedX, selectedY, lastX, lastY}
    else
        local selectedX = -1
        local selectedX = -1
        local tries = 0

        while (selectedX == -1 or hitGrid[selectedY][selectedX] == "h" or hitGrid[selectedY][selectedX] == "p") and tries < 4 do
            local randomNum = love.math.random(1,4)
            if randomNum == 1 and (lastX + 1 <= gridSize) then
                selectedX = lastX + 1
                selectedY = lastY
            elseif randomNum == 2 and (lastX - 1 >= 1) then
                selectedX = lastX - 1
                selectedY = lastY
            elseif randomNum == 3 and (lastY + 1 <= gridSize) then
                selectedY = lastY + 1
                selectedX = lastX
            elseif randomNum == 4 and (selectedY - 1 >= 1) then
                selectedY = lastY- 1
                selectedX = lastX
            end
            tries = tries + 1
        end

        if tries == 4 then
            while selectedX == -1 or hitGrid[selectedY][selectedX] == "h" or hitGrid[selectedY][selectedX] == "p" do
                selectedX = love.math.random(1,gridSize)
                selectedY = love.math.random(1,gridSize)
            end
        end

        print(selectedX, selectedY)
        lastX = selectedX
        lastY = selectedY
        return {selectedX, selectedY, lastX, lastY}
    end



end
