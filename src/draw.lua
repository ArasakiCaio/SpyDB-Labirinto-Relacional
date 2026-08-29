local fonts = {
    title = love.graphics.newFont("ChauPhilomeneOne-Regular.ttf", 42),
    body = love.graphics.newFont("ChauPhilomeneOne-Regular.ttf", 23),
    small = love.graphics.newFont("ChauPhilomeneOne-Regular.ttf", 16)
}

local function drawMap(camera, propW, propH, map, tileW, tileH)
    local startX, endX = camera.x - math.floor(propW / 2), camera.x + math.floor(propW / 2)
    local startY, endY = camera.y - math.floor(propH / 2), camera.y + math.floor(propH / 2)
    for x = startX, endX do
        for y = startY, endY do
            local tile = map[y][x]
            if tile == 1 then love.graphics.setColor(.41, .41, .41)
            elseif tile == 2 then love.graphics.setColor(.42, .26, .15)
            else love.graphics.setColor(0, 0, 0) end
            love.graphics.rectangle("fill", (x - startX) * tileW, (y - startY) * tileH, tileW, tileH)
        end
    end
end

local function screenPosition(position, camera, propW, propH, tileW, tileH)
    return (position[1] - camera.x + math.floor(propW / 2)) * tileW, (position[2] - camera.y + math.floor(propH / 2)) * tileH
end

local function drawTotems(totems, camera, propW, propH, tileW, tileH)
    for _, totem in ipairs(totems) do
        local x, y = screenPosition(totem.position, camera, propW, propH, tileW, tileH)
        if totem.tipo.typeName == "Diagrama Entidade Relacionamento" then
            if totem.tipo.completed then love.graphics.setColor(0, 0, 1) else love.graphics.setColor(1, .8, 0) end
            love.graphics.rectangle("fill", x + tileW / 6, y + tileH / 6, tileW / 1.5, tileH / 1.5)
        elseif totem.tipo.typeName == "Decodificar Tabelas" then
            if totem.tipo.completed then love.graphics.setColor(0, 0, 1) else love.graphics.setColor(1, .8, 0) end
            love.graphics.polygon("fill", x + tileW / 2, y + tileH / 7, x + tileW / 6, y + tileH * .8, x + tileW * .83, y + tileH * .8)
        else
            love.graphics.setColor(0, 1, 0); love.graphics.circle("fill", x + tileW / 2, y + tileH / 2, math.min(tileW, tileH) / 3)
        end
    end
end

local function drawSprite(sprite, position, camera, propW, propH, tileW, tileH)
    local x, y = screenPosition(position, camera, propW, propH, tileW, tileH)
    local scale = math.min(tileW / 2 / sprite:getWidth(), tileH / 2 / sprite:getHeight(), 1)
    local spriteWidth, spriteHeight = sprite:getWidth() * scale, sprite:getHeight() * scale
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(sprite, x + (tileW - spriteWidth) / 2, y + (tileH - spriteHeight) / 2, 0, scale, scale)
end

local function drawEnemys(enemies, image, camera, propW, propH, tileW, tileH)
    local directions = { up = {0, -1}, down = {0, 1}, left = {-1, 0}, right = {1, 0} }
    for _, enemy in ipairs(enemies) do
        local direction = directions[enemy.look]
        if direction then
            local target = { enemy.position[1] + direction[1], enemy.position[2] + direction[2] }
            local x, y = screenPosition(target, camera, propW, propH, tileW, tileH)
            love.graphics.setColor(1, 0, 0, .65)
            love.graphics.rectangle("fill", x, y, tileW, tileH)
        end
        drawSprite(image, enemy.position, camera, propW, propH, tileW, tileH)
    end
end

local function drawPlayer(player, image, camera, propW, propH, tileW, tileH)
    drawSprite(image, player.position, camera, propW, propH, tileW, tileH)
end

local function sampleValues(attribute)
    if string.find(attribute, "cpf") then return {"123.456.789-00", "987.654.321-00", "...", "111.222.333-44"} end
    local values = {
        nome = {"Ana Souza", "Bruno Lima", "...", "Carla Reis"}, email = {"ana@email.com", "bruno@email.com", "...", "carla@email.com"},
        salario = {"R$ 2.500", "R$ 3.100", "...", "R$ 4.200"}, titulo = {"O Labirinto", "Banco de Dados", "...", "A Espia"},
        autor = {"M. Silva", "L. Costa", "...", "R. Alves"}, categoria = {"Misterio", "Tecnologia", "...", "Ficcao"},
        data = {"10/03/2026", "14/03/2026", "...", "21/03/2026"}, devolucao = {"20/03/2026", "24/03/2026", "...", "31/03/2026"},
        contato = {"(11) 99999-0001", "(11) 98888-0002", "...", "(11) 97777-0003"}, registro = {"LEI-001", "LEI-002", "...", "LEI-008"}
    }
    return values[attribute] or {"1", "2", "...", "8"}
end

local function drawTextTable(width, height, totem, typedText, hasTutorialHint)
    local x, y, tableWidth, tableHeight
    if hasTutorialHint then
        -- Evita sobreposição com a dica textual do tutorial à esquerda.
        x, y, tableWidth, tableHeight = 500, 250, width - 650, height - 360
    else
        x, y, tableWidth, tableHeight = 200, 140, width - 400, height - 270
    end
    local data = totem.tipo
    local columnWidth, oldFont = tableWidth / #data.answers, love.graphics.getFont()
    love.graphics.setColor(.32, .36, .42); love.graphics.rectangle("fill", x, y, tableWidth, 65)
    love.graphics.setColor(1, 1, 1); love.graphics.setFont(fonts.title); love.graphics.printf(data.title, x, y + 10, tableWidth, "center")
    love.graphics.setFont(fonts.small)
    for index, answer in ipairs(data.answers) do
        local columnX = x + (index - 1) * columnWidth
        love.graphics.setColor(.72, .75, .8); love.graphics.rectangle("fill", columnX + 2, y + 69, columnWidth - 4, tableHeight - 69)
        love.graphics.setColor(.18, .23, .3); love.graphics.rectangle("fill", columnX + 2, y + 69, columnWidth - 4, 42)
        local isNewCorrect = data.lastCorrectIndex == index and data.lastCorrectAt and love.timer.getTime() - data.lastCorrectAt < 1.2
        if isNewCorrect and math.floor(love.timer.getTime() * 8) % 2 == 0 then love.graphics.setColor(.3, 1, .5) else love.graphics.setColor(1, 1, 1) end
        love.graphics.printf(data.correctAnswers[index] and answer or "???", columnX + 8, y + 80, columnWidth - 16, "center")
        love.graphics.setColor(.05, .05, .05)
        for row, value in ipairs(sampleValues(answer)) do love.graphics.printf(value, columnX + 10, y + 126 + (row - 1) * 56, columnWidth - 20, "center") end
    end
    love.graphics.setFont(oldFont); love.graphics.setColor(.3, 1, .5)
    local cursor = math.floor(love.timer.getTime() * 2) % 2 == 0 and "|" or " "
    local prompt = data.completed and "Concluido! Aperte Esc para fechar o minijogo." or ("> " .. typedText .. cursor)
    love.graphics.printf(prompt, x + 12, height - 82, tableWidth - 24, "left")
end

local function drawDTB(width, height, propW, propH, typedText, totem, seeDER, hasTutorialHint)
    if not seeDER[1] then return drawTextTable(width, height, totem, typedText, hasTutorialHint) end
    love.graphics.setColor(0, 0, 1); love.graphics.rectangle("fill", width / propW / 2, height / propH / 2, width - width / propW, height - height / propH)
    love.graphics.setColor(1, 1, 1); local image = seeDER[2]
    love.graphics.draw(image, width / propW / 2 + (width - width / propW - image:getWidth()) / 2, height / propH / 2 + (height - height / propH - image:getHeight()) / 2)
end

local function drawDER(width, height, propW, propH, totem, arrows)
    love.graphics.setColor(0, 0, 1); love.graphics.rectangle("fill", width / propW / 2, height / propH / 2, width - width / propW, height - height / propH)
    local image = totem.tipo.img[totem.tipo.diagram]; love.graphics.setColor(1, 1, 1)
    love.graphics.draw(image, width / propW / 2 + (width - width / propW - image:getWidth()) / 2, height / propH / 2 + (height - height / propH - image:getHeight()) / 2)
    love.graphics.draw(arrows.setaA, width / propW / 2 + 20, height / 2 - arrows.setaA:getHeight() / 2)
    love.graphics.draw(arrows.setaD, width - width / propW / 2 - arrows.setaD:getWidth() - 20, height / 2 - arrows.setaD:getHeight() / 2)
    if totem.tipo.completed then
        love.graphics.setColor(.3, 1, .5)
        love.graphics.printf("Correto! Aperte Esc para fechar o minijogo.", width / propW, height - height / propH, width - width / propW * 2, "center")
    end
end

local function drawAR(width, height, propW, propH)
    love.graphics.setColor(0, 0, 1); love.graphics.rectangle("fill", width / propW / 2, height / propH / 2, width - width / propW, height - height / propH)
end

local function drawInstruction(width, height, instruction)
    local margin, oldFont = 110, love.graphics.getFont()
    local accent = instruction.accent or {.2, .65, 1}
    local continueText = instruction.continueText or "Pressione I ou Esc para continuar"
    love.graphics.setColor(.04, .06, .1, .96); love.graphics.rectangle("fill", margin, 75, width - margin * 2, height - 150, 18, 18)
    love.graphics.setColor(accent[1], accent[2], accent[3]); love.graphics.rectangle("fill", margin, 75, width - margin * 2, 8)
    love.graphics.setColor(1, 1, 1); love.graphics.setFont(fonts.title); love.graphics.printf(instruction.title, margin + 45, 115, width - margin * 2 - 90, "center")
    love.graphics.setColor(.92, .95, 1); love.graphics.setFont(fonts.body); love.graphics.printf(instruction.body, margin + 55, 195, width - margin * 2 - 110, "left")
    love.graphics.setColor(accent[1], accent[2], accent[3]); love.graphics.printf(continueText, margin + 45, height - 125, width - margin * 2 - 90, "center"); love.graphics.setFont(oldFont)
end

local function drawInstructionHint(instruction)
    local oldFont = love.graphics.getFont(); love.graphics.setColor(.04, .06, .1, .92); love.graphics.rectangle("fill", 18, 18, 470, 210, 12, 12)
    love.graphics.setColor(.3, .75, 1); love.graphics.setFont(fonts.body); love.graphics.printf(instruction.title, 35, 35, 436, "center")
    love.graphics.setColor(1, 1, 1); love.graphics.setFont(fonts.small); love.graphics.printf(instruction.body, 35, 78, 436, "left"); love.graphics.setFont(oldFont)
end

local function drawMenu(menu)
    love.graphics.setColor(1, 1, 1); love.graphics.draw(menu.capa, 0, 0); love.graphics.draw(menu.start.img, menu.start.x, menu.start.y); love.graphics.draw(menu.quit.img, menu.quit.x, menu.quit.y)
end

return { drawMenu=drawMenu, drawMap=drawMap, drawTotems=drawTotems, drawEnemys=drawEnemys, drawPlayer=drawPlayer, drawDTB=drawDTB, drawDER=drawDER, drawAR=drawAR, drawInstruction=drawInstruction, drawInstructionHint=drawInstructionHint }
