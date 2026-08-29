local function newPlayer(x, y, vx, vy)
    return {
        position = {x, y},
        velx = vx,
        vely = vy,
        flags = 0
    }
end

local function newEnemy(x, y, vx, vy, lookside)
    return {
        position = {x, y},
        velx = vx,
        vely = vy,
        look = lookside,
        lastPosition = {x, y, lookside}
    }
end

local function newTotem(x, y, type)
    return {
        position = {x, y},
        tipo = type,
    }
end

return {
    newPlayer = newPlayer,
    newEnemy = newEnemy,
    newTotem = newTotem,
}