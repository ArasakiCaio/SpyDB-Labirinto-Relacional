local function playerColision(player, enemys, map)
    local nextX = player.position[1] + player.velx
    local nextY = player.position[2] + player.vely
    if nextX < 1 or nextX > #map[1] or nextY < 1 or nextY > #map or map[nextY][nextX] == 0 or map[nextY][nextX] == 1 then
        player.velx, player.vely = 0, 0
        return
    end
    for _, enemy in ipairs(enemys) do
        if enemy.position[1] == nextX and enemy.position[2] == nextY then
            player.velx, player.vely = 0, 0
            return
        end
    end
end

local function enemyCanSeePlayer(enemy, player)
    local dx = player.position[1] - enemy.position[1]
    local dy = player.position[2] - enemy.position[2]
    return (dx == 0 and dy == 0)
        or (enemy.look == "up" and dx == 0 and dy == -1)
        or (enemy.look == "down" and dx == 0 and dy == 1)
        or (enemy.look == "left" and dx == -1 and dy == 0)
        or (enemy.look == "right" and dx == 1 and dy == 0)
end

local function resetPositions(player, enemies, playerStart, enemyStarts)
    player.position[1], player.position[2] = playerStart[1], playerStart[2]
    for index, enemy in ipairs(enemies) do
        local start = enemyStarts[index]
        enemy.position[1], enemy.position[2] = start.position[1], start.position[2]
        enemy.look = start.look
        enemy.lastPosition = { start.lastPosition[1], start.lastPosition[2], start.lastPosition[3] }
    end
end

local function enemyLook(player, enemies, lifes, state, playerStart, enemyStarts)
    for _, enemy in ipairs(enemies) do
        if enemyCanSeePlayer(enemy, player) then
            if lifes <= 1 then return lifes, "GameOver" end
            lifes = lifes - 1
            resetPositions(player, enemies, playerStart, enemyStarts)
            break
        end
    end
    return lifes, state
end

return { playerColision = playerColision, enemyLook = enemyLook }
