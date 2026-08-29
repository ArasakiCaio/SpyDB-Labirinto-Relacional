-- Definições declarativas das fases. Para adicionar uma fase, inclua uma entrada
-- em `definitions` e informe-a em `order`; o restante do jogo a inicializa igual.
local Levels = {}

Levels.types = {
    DER = "Diagrama Entidade Relacionamento",
    AR = "Algebra Relacional",
    DTB = "Decodificar Tabelas",
    EXIT = "Exit"
}

Levels.order = { "tutorial", "lvl01", "lvl02" }

local definitions = {
    tutorial = {
        map = {
            {0,0,0,0,0,0,0}, {0,2,2,2,2,2,0}, {0,1,1,1,1,2,0},
            {0,2,2,2,2,2,0}, {0,2,1,1,1,1,0}, {0,2,2,2,2,2,0}, {0,0,0,0,0,0,0}
        },
        player = {2, 2}, instruction = {
            title = "Instruções",
            body = "Ande até o quadrado azul e aperte Espaço para interagir."
        },
        totems = {
            { kind = "der", position = {6, 2}, answer = 2, images = {"imgs/tutorial/tutorialErro01.png", "imgs/tutorial/tutorialR.png"} },
            { kind = "table", position = {2, 4}, title = "Funcionario", answers = {"cpf", "nome", "salario", "id_departamento"} },
            { kind = "exit", position = {6, 6} }
        }
    },
    lvl01 = {
        map = {
            {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,1,1,1,1,1,1,2,2,2,2,2,2,2,2,1,0}, {0,2,2,2,2,2,2,2,1,1,2,1,1,1,2,1,0}, {0,1,2,1,1,2,1,2,1,1,2,1,1,1,2,1,0}, {0,2,2,1,1,2,1,2,2,2,2,2,2,2,2,2,0}, {0,1,2,2,2,2,1,1,1,2,1,1,2,1,1,1,0}, {0,1,1,1,1,2,1,1,1,2,2,2,2,1,1,1,0}, {0,1,1,1,1,2,2,2,2,2,1,1,2,1,1,1,0}, {0,2,2,2,2,2,1,1,1,2,1,1,2,2,2,2,0}, {0,1,2,1,2,2,2,2,2,2,2,2,2,1,1,1,0}, {0,1,2,1,2,1,1,2,1,1,1,2,1,1,1,1,0}, {0,1,1,1,2,1,1,2,1,1,1,2,1,1,1,1,0}, {0,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,0}, {0,1,1,1,2,1,1,1,2,1,1,2,1,2,1,1,0}, {0,2,2,1,2,1,1,1,2,1,1,2,2,2,2,1,0}, {0,1,2,2,2,1,1,2,2,1,1,2,1,2,1,1,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        },
        player = {2, 3}, enemies = {{10,2,"left"}, {3,10,"down"}, {15,9,"left"}}, instruction = {
            title = "Missão",
            body = "Acreditamos que alguns corretores e proprietários de imóveis estão manipulando informações. Encontre os proprietários dos imóveis e com qual corretor eles estão em contato.\n\nInformações adicionais:\n• Um imóvel pertence a apenas um proprietário, mas um proprietário pode possuir vários imóveis.\n• Um proprietário pode contatar vários corretores e um corretor pode contatar vários proprietários.\n• Um inquilino aluga apenas um imóvel e um imóvel pode ser alugado apenas por um inquilino."
        },
        totems = {
            {kind="der", position={2,9}, answer=1, images={"imgs/lvl01/lvl01R.png", "imgs/lvl01/lvl01Erro01.png", "imgs/lvl01/lvl01Erro02.png", "imgs/lvl01/lvl01Erro03.png"}},
            {kind="table", position={8,16}, title="Contata", answers={"id", "cpf_proprietario", "cpf_corretor"}},
            {kind="table", position={16,5}, title="Proprietario", answers={"cpf", "nome", "contato"}},
            {kind="exit", position={16,13}}
        }
    },
    lvl02 = {
        map = {
            {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, {0,1,1,2,1,2,1,1,2,2,1,1,2,2,2,1,0}, {0,1,2,2,2,2,1,1,2,1,1,1,2,1,2,2,0}, {0,1,1,2,1,2,1,1,2,1,1,1,2,1,1,1,0}, {0,2,2,2,1,2,2,2,2,2,2,2,2,1,1,1,0}, {0,1,1,1,1,2,1,1,1,2,1,1,2,1,1,1,0}, {0,1,1,1,1,2,1,1,1,2,1,1,2,1,2,1,0}, {0,1,1,1,2,2,2,2,2,2,2,2,2,1,2,1,0}, {0,2,2,2,2,1,1,2,1,1,1,2,2,2,2,2,0}, {0,1,1,1,2,1,1,2,2,2,2,2,1,1,1,1,0}, {0,1,1,1,2,2,2,2,1,1,1,2,1,1,1,1,0}, {0,1,1,1,2,1,1,2,1,1,1,2,2,2,2,1,0}, {0,2,2,2,2,2,2,2,2,2,1,2,1,1,2,2,0}, {0,1,2,1,1,1,2,1,1,2,1,2,1,1,2,1,0}, {0,1,2,1,1,1,2,1,1,2,2,2,2,2,2,2,0}, {0,1,2,2,2,2,2,2,2,2,1,1,1,1,1,1,0}, {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        },
        player={16,13}, enemies={{2,9,"left"},{9,2,"down"},{15,9,"left"}}, instruction={
            title = "Missão",
            body = "Acreditamos que alguns espiões estão trocando informações por meio de livros de uma biblioteca. Encontre os leitores e os livros que eles emprestaram da biblioteca.\n\nInformações adicionais:\n• Um empréstimo é de apenas um livro e feito por apenas um leitor.\n• O leitor é uma especialização de pessoa, igualmente para o funcionário da biblioteca."
        },
        totems={
            {kind="der",position={16,15},answer=2,images={"imgs/lvl02/lvl02Erro01.png","imgs/lvl02/lvl02R.png","imgs/lvl02/lvl02Erro02.png"}},
            {kind="table",position={2,13},title="Livro",answers={"id","titulo","autor","categoria"}},
            {kind="table",position={15,7},title="Emprestimo",answers={"id_livro","cpf_leitor","data","devolucao"}},
            {kind="table",position={9,8},title="Pessoa",answers={"cpf","nome","email"}},
            {kind="table",position={10,16},title="Leitor",answers={"cpf_pessoa","registro"}},
            {kind="exit",position={2,5}}
        }
    }
}

local function images(paths, loadImage)
    local result = {}
    for _, path in ipairs(paths) do table.insert(result, loadImage(path)) end
    return result
end

local function buildTotem(definition, constructors, loadImage)
    local type = { typeName = Levels.types.EXIT }
    if definition.kind == "der" then
        type = { typeName = Levels.types.DER, img = images(definition.images, loadImage), diagram = 1, answer = definition.answer, completed = false }
    elseif definition.kind == "table" then
        type = { typeName = Levels.types.DTB, title = definition.title, answers = definition.answers, correctAnswers = {}, completed = false }
        for index = 1, #definition.answers do type.correctAnswers[index] = false end
    end
    return constructors.newTotem(definition.position[1], definition.position[2], type)
end

function Levels.create(id, constructors, loadImage)
    local definition = assert(definitions[id], "Fase desconhecida: " .. tostring(id))
    local level = { id = id, map = definition.map, player = constructors.newPlayer(definition.player[1], definition.player[2], 0, 0), enemys = {}, totems = {}, instruction = definition.instruction }
    for _, enemy in ipairs(definition.enemies or {}) do table.insert(level.enemys, constructors.newEnemy(enemy[1], enemy[2], 0, 0, enemy[3])) end
    for _, totem in ipairs(definition.totems) do table.insert(level.totems, buildTotem(totem, constructors, loadImage)) end
    return level
end

Levels.tutorialInstructions = {
    diagram = {
        title = "Diagrama Entidade-Relacionamento",
        body = "1. Selecione o diagrama com as teclas A e D.\n\n2. Aperte Enter para confirmar a escolha.\n\n3. Encontre o diagrama que corresponde a um departamento com muitos funcionários."
    },
    triangle = {
        title = "Instruções",
        body = "Ande até o triângulo azul e aperte Espaço para interagir.\n\nAtenção: só é possível interagir com um triângulo depois de concluir o desafio quadrado."
    },
    table = {
        title = "Decodificar tabelas",
        body = "1. Digite individualmente o nome dos atributos/colunas. Exemplo: nome.\n\n2. Aperte Enter para enviar a resposta.\n\n3. Aperte Tab para alternar entre a tabela e o diagrama selecionado no desafio anterior.\n\nAtenção: chaves estrangeiras seguem o formato [atributo]_[entidade]. Exemplo: id_departamento."
    },
    exit = {
        title = "Avançar de fase",
        body = "Ande até o círculo verde e aperte Espaço para avançar.\n\nAtenção: só é possível usar a saída depois de concluir todos os desafios quadrados e triangulares."
    }
}

Levels.guardWarning = {
    title = "Cuidado",
    body = "Existem guardas procurando por você. Não seja pego!\n\nVocê tem três vidas. Cada vez que um guarda encontrar você, perderá uma vida, mas o progresso da fase não será perdido enquanto você ainda tiver vidas.\n\nAtenção: os guardas continuam se movendo enquanto você lê instruções ou resolve minijogos.",
    accent = {1, .2, .2}
}

return Levels
