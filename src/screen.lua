local function set(player, propW, propH)
    local screen = {x = player.position[1], y = player.position[2]}

    if screen.x < (math.floor(propW/2) + 1) then
        screen.x = (math.floor(propW/2) + 1)
    end

    if screen.y < (math.floor(propH/2) + 1) then
        screen.y = (math.floor(propH/2) + 1)
    end

    return screen
end

return {
    set = set
}