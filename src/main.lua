require("conf")
local constructors = require("constructors")
local movement = require("movements")
local colision = require("colision")
local screen = require("screen")
local draw = require("draw")
local utf8 = require("utf8")
local minigame = require("minigame")
local levels = require("levels")

local WIDTH, HEIGHT = 1366, 768
local propW, propH = 5, 5
local tamW, tamH = WIDTH / propW, HEIGHT / propH
local text = ""
local minigameType = levels.types

local function loadImage(path)
    if love.filesystem.getInfo(path) then return love.graphics.newImage(path) end
end

function love.textinput(character) text = text .. character end

function love.keypressed(key)
    if key == "backspace" then
        local offset = utf8.offset(text, -1)
        if offset then text = string.sub(text, 1, offset - 1) end
    end
end

local FONT = love.graphics.newFont("ChauPhilomeneOne-Regular.ttf", 30)
love.graphics.setFont(FONT)

local playerImg = loadImage("imgs/player.png")
local enemyImg = loadImage("imgs/enemy.png")
local setas = { setaA = loadImage("imgs/setaA.png"), setaD = loadImage("imgs/setaD.png") }

local function button(image, x, y)
    return { img = image, x = x, y = y, width = image:getPixelWidth(), height = image:getPixelHeight() }
end

local menuGraphics = { capa = loadImage("imgs/capa.png") }
menuGraphics.start = button(loadImage("imgs/start.png"), 0, 0)
menuGraphics.quit = button(loadImage("imgs/quit.png"), 0, 0)
menuGraphics.start.x = WIDTH / 2 - menuGraphics.start.width / 2
menuGraphics.start.y = HEIGHT / 2 - menuGraphics.start.height / 2
menuGraphics.quit.x = WIDTH / 2 - menuGraphics.quit.width / 2
menuGraphics.quit.y = HEIGHT / 2 + menuGraphics.quit.height

local GameOver = { capa = loadImage("imgs/GameOver.png") }
GameOver.continuar = button(loadImage("imgs/continuar.png"), 0, 0)
GameOver.continuar.x = WIDTH / 2 - GameOver.continuar.width / 2
GameOver.continuar.y = HEIGHT / 2 - GameOver.continuar.height / 4
local End = { capa = loadImage("imgs/end.png") }
End.quit = button(loadImage("imgs/endQuit.png"), 0, 0)
End.quit.x = WIDTH / 2 - End.quit.width / 2
End.quit.y = HEIGHT / 2 - End.quit.height / 4

local state, substate, lvl = "Menu", "Play", "tutorial"
local activeLevel, map, player, enemys, totems, playerStart, enemysStart
local tela, currentTotem, instrucao
local lifes, lifesTxt, contador, tempoAcumulado = nil, "", 0, 0
local isDown, minigameIsDown = false, false
local seeDER = { false, nil }
local showMissionAfterGuardWarning = false

local function copyEnemyStarts(enemies)
    local starts = {}
    for index, enemy in ipairs(enemies) do
        starts[index] = { position = { enemy.position[1], enemy.position[2] }, look = enemy.look, lastPosition = { enemy.position[1], enemy.position[2], enemy.look } }
    end
    return starts
end

-- Uma única entrada para qualquer fase: cria estado novo e evita que tentativas
-- anteriores alterem a definição da fase.
local function startLevel(levelId)
    activeLevel = levels.create(levelId, constructors, loadImage)
    map, player, enemys, totems = activeLevel.map, activeLevel.player, activeLevel.enemys, activeLevel.totems
    playerStart = { player.position[1], player.position[2] }
    enemysStart = copyEnemyStarts(enemys)
    seeDER = { false, totems[1].tipo.img[totems[1].tipo.answer] }
    if levelId == "tutorial" then
        instrucao = activeLevel.instruction
    elseif levelId == "lvl01" then
        instrucao = levels.guardWarning
        showMissionAfterGuardWarning = true
    else
        instrucao = activeLevel.instruction
        showMissionAfterGuardWarning = false
    end
    tela = screen.set(player, propW, propH)
    substate, currentTotem, text = "instrucao", nil, ""
    contador, tempoAcumulado = 0, 0
    lvl = levelId .. "Run"
end

local function levelIdFromRun(runId) return string.gsub(runId, "Run$", "") end

local function updateInstruction()
    if lvl == "tutorialRun" then
        if player.flags == 0 and substate == minigameType.DER then
            instrucao = levels.tutorialInstructions.diagram
        elseif player.flags == 1 then
            instrucao = substate == minigameType.DTB and levels.tutorialInstructions.table or levels.tutorialInstructions.triangle
        elseif player.flags >= 1 then
            instrucao = levels.tutorialInstructions.exit
        end
    end
end

function love.load()
    love.window.setMode(WIDTH, HEIGHT)
    love.keyboard.setKeyRepeat(true)
end

function love.mousepressed(mx, my, mouseButton)
    if mouseButton ~= 1 then return end
    local function clicked(item) return mx >= item.x and mx < item.x + item.width and my >= item.y and my < item.y + item.height end
    if state == "Menu" then
        if clicked(menuGraphics.start) then state, lifes = "inGame", 3 elseif clicked(menuGraphics.quit) then love.event.quit() end
    elseif state == "End" and clicked(End.quit) then
        love.event.quit()
    elseif state == "GameOver" and clicked(GameOver.continuar) then
        state, lvl = "inGame", levelIdFromRun(lvl)
    end
end

function love.update(dt)
    if state ~= "inGame" then return end

    -- IDs sem "Run" representam uma fase que ainda precisa ser montada.
    if not string.match(lvl, "Run$") then
        if lvl ~= "tutorial" then lifes = 3 end
        startLevel(lvl)
    end

    tempoAcumulado = tempoAcumulado + dt
    updateInstruction()
    lifesTxt = "Vidas restantes: " .. lifes

    local previousSubstate = substate
    isDown, substate, currentTotem, text, lvl, state = movement.keyboardInput(player, totems, isDown, substate, currentTotem, text, lvl, state, levels.order)
    if previousSubstate == "instrucao" and substate == "Play" and showMissionAfterGuardWarning then
        instrucao = activeLevel.instruction
        substate = "instrucao"
        showMissionAfterGuardWarning = false
    end
    if previousSubstate == "Play" and substate == "instrucao" and lvl ~= "tutorialRun" then
        instrucao = activeLevel.instruction
    end
    lifes, state = colision.enemyLook(player, enemys, lifes, state, playerStart, enemysStart)
    contador, tempoAcumulado = movement.enemyMovement(contador, tempoAcumulado, enemys, constructors, map)
    colision.playerColision(player, enemys, map)
    movement.playerNewPosition(player)

    if substate == minigameType.DER then
        player, minigameIsDown, substate = minigame.DER(player, minigameIsDown, currentTotem, substate, lifes, lvl)
    elseif substate == minigameType.DTB then
        player, minigameIsDown, substate, lifes, text, seeDER = minigame.DTB(player, minigameIsDown, currentTotem, substate, lifes, text, seeDER, lvl)
    end

    local halfW, halfH = math.floor(propW / 2), math.floor(propH / 2)
    if player.position[1] >= tela.x + halfW then tela.x = tela.x + 1 elseif player.position[1] <= tela.x - halfW then tela.x = tela.x - 1 end
    if player.position[2] >= tela.y + halfH then tela.y = tela.y + 1 elseif player.position[2] <= tela.y - halfH then tela.y = tela.y - 1 end
    player.velx, player.vely = 0, 0
end

function love.draw()
    if state == "Menu" then
        draw.drawMenu(menuGraphics)
    elseif state == "inGame" then
        draw.drawMap(tela, propW, propH, map, tamW, tamH)
        draw.drawTotems(totems, tela, propW, propH, tamW, tamH)
        draw.drawEnemys(enemys, enemyImg, tela, propW, propH, tamW, tamH)
        draw.drawPlayer(player, playerImg, tela, propW, propH, tamW, tamH)
        if substate == minigameType.DTB then
            draw.drawDTB(WIDTH, HEIGHT, propW, propH, text, currentTotem, seeDER, lvl == "tutorialRun")
        elseif substate == minigameType.DER then
            draw.drawDER(WIDTH, HEIGHT, propW, propH, currentTotem, setas)
        elseif substate == minigameType.AR then
            draw.drawAR(WIDTH, HEIGHT, propW, propH)
        elseif substate == "instrucao" then
            draw.drawInstruction(WIDTH, HEIGHT, instrucao)
        elseif substate == "exitLocked" then
            draw.drawInstruction(WIDTH, HEIGHT, {
                title = "Saída bloqueada",
                body = "Ainda faltam minigames para concluir esta fase. Resolva todos os desafios amarelos antes de usar a saída verde.",
                accent = {1, .8, 0},
                continueText = "Pressione Esc para continuar"
            })
        elseif substate == "tableLocked" then
            draw.drawInstruction(WIDTH, HEIGHT, {
                title = "Tabela bloqueada",
                body = "Antes de decodificar esta tabela, encontre e conclua o minigame de Diagrama Entidade-Relacionamento (DER).",
                accent = {1, .8, 0},
                continueText = "Pressione Esc para continuar"
            })
        else
            love.graphics.setColor(255,0,0)
            love.graphics.printf(lifesTxt, 8, 10, WIDTH - WIDTH / propW * 2)
        end
        if (substate == minigameType.DTB or substate == minigameType.DER) and lvl == "tutorialRun" then
            draw.drawInstructionHint(instrucao)
        end
    elseif state == "End" then
        love.graphics.setColor(255,255,255); love.graphics.draw(End.capa, 0, 0); love.graphics.draw(End.quit.img, End.quit.x, End.quit.y)
    elseif state == "GameOver" then
        love.graphics.setColor(255,255,255); love.graphics.draw(GameOver.capa, 0, 0); love.graphics.draw(GameOver.continuar.img, GameOver.continuar.x, GameOver.continuar.y)
    end
end
