# SpyDB — Labirinto Relacional

Jogo educativo feito com LÖVE/Lua.

## Criando ou alterando fases

As fases ficam centralizadas em `levels.lua`. Cada entrada em `definitions` descreve:

- `map`: matriz do labirinto (`0` parede, `1` bloqueio e `2` caminho);
- `player` e `enemies`: posições iniciais;
- `totems`: desafios DER, tabelas ou saída;
- `instruction`: imagem de introdução da fase.

Para criar uma fase, adicione a configuração em `definitions` e o seu ID em `Levels.order`. A progressão, o carregamento de imagens e a reinicialização passam a funcionar automaticamente.
