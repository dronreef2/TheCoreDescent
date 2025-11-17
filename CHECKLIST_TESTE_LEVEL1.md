# ✅ Checklist de Teste Manual - Level1

**Objetivo**: Verificar que a refatoração Level1 → BaseLevel funcionou corretamente

---

## 📋 Pré-requisitos
- [ ] Godot 4.x instalado localmente
- [ ] Projeto aberto no editor
- [ ] Branch `feature/core-services-refactor` checado

---

## 🧪 Testes de Código

### 1. Verificação de Arquivos
- [ ] `codigo/BaseLevel.gd` existe e compila sem erros
- [ ] `codigo/Level1.gd` existe e compila sem erros
- [ ] `codigo/services/GameStateService.gd` existe
- [ ] `codigo/services/LevelFlowService.gd` existe
- [ ] Level1 mostra `extends BaseLevel` (não `extends Node2D`)

### 2. Redução de Código
- [ ] Level1.gd tem ~282 linhas (antes: 494)
- [ ] BaseLevel.gd tem ~179 linhas
- [ ] Redução confirmada: **-43% de boilerplate**

---

## 🎮 Testes Funcionais no Editor

### 3. Carregar Scene
1. Abra o editor Godot
2. Navegue até `codigo/Level1.gd` no FileSystem
3. **Verificar**:
   - [ ] Arquivo abre sem erros de sintaxe
   - [ ] Não há warnings de deprecated code
   - [ ] Script Analyzer não mostra erros

### 4. Verificar Herança
No editor de scripts (`codigo/Level1.gd`):
- [ ] Linha 1: `extends BaseLevel` (não `extends Node2D`)
- [ ] Método `_on_level_ready()` existe e override BaseLevel
- [ ] Método `_init()` define `level_name = "A Torre de Marfim"`

### 5. Testar Scene no Editor
1. Abra a cena do Level1 (se existir `.tscn`)
2. Ou crie uma cena temporária com Level1
3. **Verificar nodes esperados**:
   - [ ] UI existe com:
     - `puzzle_title` (Label)
     - `move_counter` (Label)
     - `timer_label` (Label)
     - `instructions` (Label)
   - [ ] Botão Pause existe
   - [ ] Área de jogo está configurada

---

## ▶️ Testes de Execução (Play)

### 6. Iniciar Level1
1. Rode a scene Level1 no editor (F6) OU
2. Rode o jogo completo e navegue até Level1 (F5)

**Verificar UI Inicial**:
- [ ] Título exibido: "**A Torre de Marfim**"
- [ ] Move Counter exibido: "Movimentos: 0"
- [ ] Timer exibido: "Tempo: 0s"
- [ ] Instruções de puzzle visíveis

### 7. Teste de Timer
- [ ] Timer inicia em 0s quando level começa
- [ ] Timer incrementa automaticamente (1s, 2s, 3s...)
- [ ] Timer continua rodando durante gameplay
- [ ] Timer para quando puzzle é completado

### 8. Teste de Puzzles
**Carregar Primeiro Puzzle**:
- [ ] Puzzle carrega automaticamente ao entrar no level
- [ ] Blocos lógicos aparecem disponíveis
- [ ] Posição inicial do player está correta
- [ ] Goal/objetivo está visível

**Interagir com Puzzle**:
- [ ] Arrastar blocos funciona
- [ ] Contador de movimentos incrementa
- [ ] Blocos executam quando player interage
- [ ] Feedback visual funciona (highlight, animações)

### 9. Teste de Completude
**Completar Puzzle**:
1. Resolva o primeiro puzzle (chegue ao goal)
2. **Verificar**:
   - [ ] Signal `puzzle_completed` emitido
   - [ ] Pontuação calculada exibida
   - [ ] Próximo puzzle carrega automaticamente (após 2s)
   - [ ] Contador reseta para novo puzzle

**Completar Todos os 3 Puzzles**:
- [ ] Puzzle 1 → Puzzle 2 transição funciona
- [ ] Puzzle 2 → Puzzle 3 transição funciona
- [ ] Puzzle 3 → Level completo
- [ ] Signal `level_completed` emitido
- [ ] Transição para próximo level funciona

---

## 🔄 Testes de Estado

### 10. Pause Menu
- [ ] Botão Pause acessível durante gameplay
- [ ] Clicar Pause abre menu
- [ ] Timer para durante pause
- [ ] Continuar retoma gameplay
- [ ] Menu Pause funciona corretamente

### 11. Reset de Puzzle
- [ ] Função reset limpa blocos/itens anteriores
- [ ] Timer reseta entre puzzles
- [ ] Move counter reseta entre puzzles
- [ ] Estado do player reseta corretamente

---

## 🐛 Testes de Regressão

### 12. Verificar Funcionalidades Preservadas
Comparar com Level1 original (branch `main`):
- [ ] Mesma mecânica de puzzle (3 puzzles progressivos)
- [ ] Mesmos blocos lógicos disponíveis
- [ ] Mesma dificuldade/solução
- [ ] Mesma UI/UX (só estrutura mudou)
- [ ] Mesma pontuação/scoring

### 13. Verificar Sem Quebras
- [ ] Não há `null reference` errors no console
- [ ] Não há `method not found` errors
- [ ] Não há `invalid get index` warnings
- [ ] Performance similar ao Level1 antigo

---

## 📊 Métricas de Sucesso

### Objetivos da Refatoração
- [x] ✅ Level1 reduzido de 494→282 linhas (-43%)
- [ ] ⏳ Mesma funcionalidade preservada (testar acima)
- [ ] ⏳ Timer funciona corretamente
- [ ] ⏳ UI renderiza sem erros
- [ ] ⏳ Puzzles carregam e completam normalmente

---

## 📝 Resultado do Teste

**Data**: _______________  
**Testador**: _______________

### Status Geral
- [ ] ✅ **APROVADO** - Todos os testes passaram
- [ ] ⚠️ **APROVADO COM RESSALVAS** - Pequenos bugs não críticos
- [ ] ❌ **REPROVADO** - Bugs críticos/funcionalidade quebrada

### Bugs Encontrados
```
(Liste aqui qualquer bug ou comportamento inesperado)

1. 
2. 
3. 
```

### Notas Adicionais
```
(Observações sobre performance, UX, sugestões)


```

---

## 🚀 Próximos Passos

Se testes passaram:
1. ✅ Commit validação manual no git
2. 🔄 Migrar Level2-Level14 usando mesmo padrão
3. 🧪 CI/CD com testes automatizados

Se bugs encontrados:
1. 🐛 Documentar bugs neste checklist
2. 🔧 Criar issues no GitHub
3. 🛠️ Corrigir antes de migrar outros levels
