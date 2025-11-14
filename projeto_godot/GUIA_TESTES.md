# 🧪 GUIA DE TESTES RÁPIDOS

## ⚡ TESTE EM 2 MINUTOS

### Preparação (30s)
1. Abrir Godot 4.3+
2. Abrir projeto `projeto_godot/`
3. Pressionar F5 para executar

### Verificações (90s)

#### 1. Menu Principal ✅
- [ ] Título "THE CORE DESCENT" aparece
- [ ] Botões clicáveis funcionam
- [ ] Interface limpa e responsiva

#### 2. Gameplay ✅  
- [ ] Player (círculo cyan) visível
- [ ] 3 blocos coloridos aparecem: IF (azul), FOR (verde), MOVE (magenta)
- [ ] Arrastar blocos funciona
- [ ] Snap para grade funciona
- [ ] Player se move entre blocos
- [ ] Trail effect aparece

#### 3. Controles ✅
- [ ] ESC abre/fecha pause menu
- [ ] Mouse controla drag-and-drop
- [ ] Interface reativa

---

## 🔍 TESTES DETALHADOS

### Teste de Performance
```gdscript
# Adicionar ao GameManager para medir FPS
func _process(delta):
	# Pressionar F1 para mostrar FPS
	if Input.is_action_just_pressed("F1"):
		print("FPS: ", Performance.get_monitor(Performance.TIME_FPS))
```

### Teste de Blocos
```gdscript
# Pressionar F2 para adicionar mais blocos de teste
func _input(event):
	if event.is_action_pressed("F2"):
		create_test_blocks()  # Adiciona mais blocos para stress test
```

### Teste de Estados
```gdscript
# Pressionar F3 para mostrar debug info
func _input(event):
	if event.is_action_pressed("F3"):
		print("=== ESTADO ATUAL ===")
		print("Game State: ", GameManager.current_state)
		print("Player State: ", player.current_state)
		print("Blocks: ", get_tree().get_nodes_in_group("logic_blocks").size())
```

---

## 🎮 CENÁRIOS DE TESTE

### Cenário 1: Primeiro Contato
1. Executar projeto
2. Clicar "INICIAR PROTÓTIPO"
3. Clicar "TESTE RÁPIDO"
4. **Resultado:** Player e 3 blocos aparecem

### Cenário 2: Drag-and-Drop
1. Clicar no bloco azul (IF)
2. Arrastar para nova posição
3. Soltar (deve fazer snap)
4. **Resultado:** Bloco se posiciona na grade

### Cenário 3: Navegação
1. Observar player (círculo cyan)
2. Verificar se se move automaticamente
3. Verificar trail effect
4. **Resultado:** Player navega pelos blocos

### Cenário 4: Interface
1. Pressionar ESC (pause)
2. Clicar "CONTINUAR"
3. **Resultado:** Pause menu funcional

---

## 🐛 PROBLEMAS COMUNS E SOLUÇÕES

### Problema: Tela preta
**Causa:** GameManager não é AutoLoad
**Solução:**
1. Project → Project Settings
2. AutoLoad → Add
3. Path: `res://scripts/GameManager.gd`
4. Name: `GameManager`

### Problema: Blocos não aparecem
**Causa:** Scripts não estão carregando
**Solução:**
1. Verificar se `scripts/` pasta existe
2. Verificar se arquivos `.gd` têm extensão correta
3. Reimportar projeto

### Problema: Player não se move
**Causa:** Physics não está funcionando
**Solução:**
1. Verificar se Physics está habilitado
2. Verificar se Camera2D está configurada
3. Verificar se script PlayerController está anexado

### Problema: Lag durante drag
**Causa:** Muitas operações de snap
**Solução:**
1. Reduzir `snap_threshold` para 8px
2. Desabilitar `highlight_valid_snap` temporariamente

---

## 📊 MÉTRICAS DE SUCESSO

### Indicadores Positivos ✅
- Menu carrega em < 1 segundo
- Blocos respondem ao mouse instantaneamente
- Snap funciona com precisão 100%
- Player mantém 60 FPS
- Interface não apresenta delay

### Indicadores de Problema ❌
- Lag perceptível durante drag
- Blocos não fazem snap
- Player não aparece ou não se move
- Interface não responde
- FPS < 30

---

## 🚀 EXPANSÕES PARA TESTAR

### Adicionar Novos Blocos
```gdscript
# No GameManager.gd, função create_test_blocks()
var variable_block = LogicBlock.new()
variable_block.block_type = LogicBlock.BlockType.VARIABLE
variable_block.position = Vector2(500, 150)
add_child(variable_block)
variable_block.add_to_group("logic_blocks")
```

### Modificar Cores
```gdscript
# No LogicBlock.gd, função create_block_texture()
base_color = Color(1.0, 0.5, 0.0)  # Laranja personalizado
```

### Alterar Tamanho da Grid
```gdscript
# No GameManager.gd
@export var grid_size: int = 48  # Grade maior
```

---

*Este guia de testes garante que o protótipo está funcionando perfeitamente antes de prosseguir com desenvolvimentos mais complexos.*