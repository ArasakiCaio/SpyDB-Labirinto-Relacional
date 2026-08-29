local function DER(player, isDown, currentMinigame, substate, lifes, lvl)
    -- Após acertar, a resposta fica travada até o jogador fechar o desafio.
    if currentMinigame.tipo.completed then
        return player, isDown, substate, lifes, lvl
    end

    if love.keyboard.isDown("a", "left") then
        if not isDown then
            if currentMinigame.tipo.diagram > 1 then
                currentMinigame.tipo.diagram = currentMinigame.tipo.diagram - 1
            end
            isDown = true
        end
    elseif love.keyboard.isDown("d", "right") then
        if not isDown then
            if currentMinigame.tipo.diagram < #currentMinigame.tipo.img then
                currentMinigame.tipo.diagram = currentMinigame.tipo.diagram + 1
            end
            isDown = true
        end
    elseif love.keyboard.isDown("return") then
        if not isDown then
            if currentMinigame.tipo.diagram == currentMinigame.tipo.answer then
                player.flags = 1
                currentMinigame.tipo.completed = true
                if lvl == "tutorialRun" then
                    substate = "instrucao"
                end
            end
        end
            isDown = true
    else
        isDown = false
    end

    return player, isDown, substate, lifes, lvl

end

local function DTB(player, isDown, currentMinigame, substate, lifes, text, seeDER, lvl)
    if love.keyboard.isDown("tab") then
        if not isDown then
            if seeDER[1] == false then
                seeDER[1] = true
            else
                seeDER[1] = false
            end
            isDown = true
        end
    elseif love.keyboard.isDown("return") then
        if not isDown then
            local flag = false
            for index, answer in ipairs(currentMinigame.tipo.answers) do
                if string.upper(answer) == string.upper(string.gsub(text, "^%s*(.-)%s*$", "%1")) then
                    if currentMinigame.tipo.correctAnswers[index] == false then
                        currentMinigame.tipo.correctAnswers[index] = true
                        currentMinigame.tipo.lastCorrectIndex = index
                        currentMinigame.tipo.lastCorrectAt = love.timer.getTime()
                    end
                    flag = true
                    text = ""
                end
            end

            for _, answers in ipairs(currentMinigame.tipo.correctAnswers) do
                if answers == false then
                    flag = false
                end
            end

            if flag == true then
                player.flags = player.flags + 1
                currentMinigame.tipo.completed = true
                text = ""
                if lvl == "tutorialRun" then
                    substate = "instrucao"
                end
            end
        end
            isDown = true
    else
        isDown = false
    end

    return player, isDown, substate, lifes, text, seeDER, lvl
end

return {
    DER = DER,
    DTB = DTB
}
