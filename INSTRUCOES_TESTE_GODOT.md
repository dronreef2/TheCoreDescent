# 🎮 Instruções para Testar no Godot

**Data**: 2024-11-17  
**Branch**: `feature/core-services-refactor`  
**Status**: ✅ Todos os scripts validados (18/18)

---

## 📋 Pré-requisitos

- ✅ Godot 4.5+ instalado
- ✅ Projeto clonado localmente
- ✅ Branch `feature/core-services-refactor` checada

---

## 🚀 Passo a Passo

### 1. **Importar o Projeto**

**No Godot Project Manager:**

1. Clique em **"Importar"**
2. Navegue até: `/workspaces/TheCoreDescent/projeto_godot/`
3. Selecione o arquivo: `project.godot`
4. Clique em **"Importar e Editar"**

**Caminho no Windows (WSL):**
```
\\wsl.localhost\Ubuntu\workspaces\TheCoreDescent\projeto_godot
```

---

### 2. **Verificar Compilação (2 minutos)**

Quando o editor abrir:

1. **Painel Output** (parte inferior) - Verificar se não há erros vermelhos
2. **FileSystem** (esquerda) - Expandir `codigo/`
3. **Abrir arquivos refatorados:**
   - `codigo/BaseLevel.gd` - Deve compilar sem erros
   - `codigo/Level1.gd` - Primeira linha: `extends BaseLevel`
   - `codigo/services/GameStateService.gd` - Sem erros

**Resultado esperado**: ✅ Nenhum erro de compilação

---

### 3. **Executar o Projeto (F5)**

1. Pressione **F5** ou clique em **▶️ "Executar Projeto"**
2. Se pedir para escolher cena principal, selecione: `res://scenes/Main.tscn`

**O que deve acontecer:**
- Menu principal aparece
- Lista de níveis é exibida
- Nível 1 está desbloqueado

**Se houver erros:**
- Copie mensagens do painel **Output**
- Me envie para análise

---

### 4. **Testar Level1 Especificamente (5 minutos)**

**Navegar até Level1:**
1. No menu, clique em **"Nível 1: A Torre de Marfim"**
2. Ou abra diretamente a cena do Level1 (se existir .tscn)

**Verificar UI:**
- [ ] ✅ Título exibido: **"A Torre de Marfim"**
- [ ] ✅ Contador: **"Movimentos: 0"**
- [ ] ✅ Timer: **"Tempo: 0s"**
- [ ] ✅ Instruções visíveis

**Testar Timer:**
- [ ] ✅ Timer inicia em 0s
- [ ] ✅ Incrementa: 1s, 2s, 3s...
- [ ] ✅ Continua durante gameplay

**Testar Puzzle:**
- [ ] ✅ Blocos lógicos aparecem
- [ ] ✅ Arrastar blocos funciona
- [ ] ✅ Contador incrementa ao mover
- [ ] ✅ Player se move corretamente

**Completar Puzzle:**
- [ ] ✅ Chegar ao objetivo detecta vitória
- [ ] ✅ Pontuação é exibida
- [ ] ✅ Próximo puzzle carrega (após ~2s)

---

### 5. **Verificar Console (durante execução)**

**Painel Output/Debugger:**

**✅ BOM (mensagens normais):**
```
Level loaded: Level1
Puzzle 0 loaded
Player moved to position...
Puzzle completed! Score: ...
```

**❌ RUIM (erros que NÃO devem aparecer):**
```
ERROR: Method not found
ERROR: Null reference
ERROR: Invalid get index
SCRIPT ERROR: ...
```

Se aparecer algum erro vermelho, **anote a mensagem completa!**

---

### 6. **Testar Transições**

1. Complete o Puzzle 1
2. Aguarde transição para Puzzle 2
3. Verifique:
   - [ ] ✅ Timer reseta
   - [ ] ✅ Contador reseta  
   - [ ] ✅ Novo puzzle carrega
   - [ ] ✅ Player reposicionado

---

### 7. **Testar Pause Menu**

Durante o jogo:
1. Pressione botão **Pause** ou tecla ESC
2. Verificar:
   - [ ] ✅ Menu pause abre
   - [ ] ✅ Timer para
   - [ ] ✅ Botão "Continuar" funciona
   - [ ] ✅ Botão "Menu" funciona

---

## 📊 Relatório de Teste

### **Resultado Geral:**
- [ ] ✅ **APROVADO** - Tudo funcionou perfeitamente
- [ ] ⚠️ **APROVADO COM RESSALVAS** - Pequenos bugs não críticos
- [ ] ❌ **REPROVADO** - Erros críticos impedem gameplay

### **Bugs Encontrados:**
```
(Liste aqui qualquer problema encontrado)

1. 
2. 
3. 
```

### **Mensagens de Erro (se houver):**
```
(Cole aqui as mensagens do console Output)


```

---

## 🔍 Validação Técnica

### **Scripts Refatorados - Status:**

| Arquivo | Status | Notas |
|---------|--------|-------|
| `BaseLevel.gd` | ⏳ | Testa ao carregar Level1 |
| `Level1.gd` | ⏳ | Testa na execução |
| `GameStateService.gd` | ⏳ | Testa ao salvar/carregar |
| `LevelFlowService.gd` | ⏳ | Testa nas transições |
| `GameManager.gd` | ⏳ | Testa no menu principal |

### **Métricas Validadas:**

- **LOC Level1**: Deve ter ~282 linhas (antes: 494)
- **Redução**: -43% de boilerplate
- **Herança**: Level1 extends BaseLevel ✅
- **Sintaxe**: 18/18 scripts válidos ✅

---

## 🐛 Problemas Comuns e Soluções

### **Problema 1: "Scene not found"**
**Causa**: Caminho da cena incorreto  
**Solução**: Verificar `project.godot` - main_scene deve ser `res://scenes/Main.tscn`

### **Problema 2: "Script error on load"**
**Causa**: Referência a node que não existe  
**Solução**: Verificar se todos os nodes UI estão na cena

### **Problema 3: "Method not found"**
**Causa**: Método do BaseLevel não implementado  
**Solução**: Verificar se Level1 sobrescreveu métodos necessários

### **Problema 4: Timer não incrementa**
**Causa**: `_process()` não está chamando `super._process(delta)`  
**Solução**: Verificar método `_process` do Level1

---

## ✅ Checklist Final

Antes de reportar sucesso:

- [ ] Projeto importou sem erros
- [ ] Nenhum erro no console ao abrir
- [ ] Menu principal carrega
- [ ] Level1 carrega e executa
- [ ] UI renderiza corretamente
- [ ] Timer funciona
- [ ] Puzzles completam
- [ ] Transições funcionam
- [ ] Pause menu funciona
- [ ] Sem errors no Output

---

## 📞 Próximos Passos

### **Se tudo passou:**
1. ✅ Marcar validação manual como completa
2. 📝 Atualizar `CHECKLIST_TESTE_LEVEL1.md`
3. 🚀 Migrar Level2 usando mesmo padrão
4. 🔄 Continuar rollout Level3-14

### **Se encontrou bugs:**
1. 🐛 Documentar no relatório acima
2. 📸 Tirar screenshot se possível
3. 📋 Copiar mensagens de erro do console
4. 💬 Reportar para correção

---

## 🎯 Objetivo da Validação

Confirmar que a refatoração:
- ✅ Não quebrou funcionalidades existentes
- ✅ Reduziu código duplicado (BaseLevel)
- ✅ Manteve mesma experiência de jogo
- ✅ Não introduziu bugs novos

---

**Boa sorte com os testes! 🎮**

Se precisar de ajuda, me envie os erros do console Output.
