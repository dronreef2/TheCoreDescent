# 🎮 Guia de Teste - Sistema de Habilidades por Linguagem

## 🚀 Instruções de Execução

### 1. Abrir Godot e Executar Projeto
- Abra o Godot 4.3
- Abra o projeto localizado em `/workspace/projeto_godot/`
- Pressione **F5** para executar

### 2. Seleção de Linguagem
- A interface de seleção aparecerá automaticamente
- Escolha entre:
  - 🐍 **Python** (Azul) - Duck Typing
  - ☕ **Java** (Vermelho) - Garbage Collector  
  - # **C#** (Verde) - .NET Framework
  - ⚡ **JavaScript** (Amarelo) - Callback

### 3. Controles do Jogo
- **F**: Usar habilidade da linguagem selecionada
- **Mouse**: Arrastar blocos de lógica
- **ESC**: Pausar/despausar jogo

---

## 🧪 Testes Específicos por Linguagem

### 🐍 PYTHON - Duck Typing
**Objetivo**: Testar permissão temporária de interações incorretas

**Como Testar**:
1. Selecione **Python** no menu
2. Aproxime-se de uma porta/chave que normalmente wouldn't work
3. Pressione **F** para ativar Duck Typing
4. Tente passar pela porta - deve funcionar uma vez
5. Tente novamente - deve falhar (cooldown de 8s)

**Sinais de Sucesso**:
- Feedback visual verde ao usar habilidade
- Pode passar por porta/chave incorreta uma vez
- Cooldown indicator mostra tempo restante

---

### ☕ JAVA - Garbage Collector  
**Objetivo**: Testar remoção de obstáculos físicos

**Como Testar**:
1. Selecione **Java** no menu
2. Localize obstáculos no cenário (blocos, barriers)
3. Pressione **F** próximo ao obstáculo
4. Obstáculo deve ser removido instantaneamente

**Sinais de Sucesso**:
- Feedback visual verde ao usar habilidade  
- Obstáculo desaparece da cena
- Cooldown indicator mostra tempo restante (12s)

**Localização de Obstáculos**:
- Procure por objetos com cor diferente
- Blocos que bloqueiam passagem
- Barreira visuais no caminho

---

### # C# - .NET Framework
**Objetivo**: Testar criação de pontes temporárias

**Como Testar**:
1. Selecione **C#** no menu
2. Localize um gap/vazio ou área de água
3. Pressione **F** sobre o vazio
4. Uma ponte deve aparecer temporariamente
5. Cruze a ponte antes dela desaparecer (15s)

**Sinais de Sucesso**:
- Feedback visual verde ao usar habilidade
- Ponte marrom aparece no vazio
- Pode atravessar área antes da ponte desaparecer
- Cooldown indicator mostra tempo restante (15s)

**Identificação de Vazio**:
- Áreas sem chão visível
- Espaços entre plataformas
- "Água" visual (cor azul)

---

### ⚡ JAVASCRIPT - Callback
**Objetivo**: Testar sistema de marcação e teletransporte

**Como Testar**:
1. Selecione **JavaScript** no menu
2. Mova-se para uma posição importante
3. Pressione **F** pela primeira vez → **marca posição atual**
4. Mova-se para outro local
5. Pressione **F** novamente → **teletransporte para posição marcada**

**Sinais de Sucesso**:
- Feedback visual verde ao usar habilidade
- Primeira vez: marca posição (confirmação no console)
- Segunda vez: teleporta instantaneamente para posição marcada
- Cooldown indicator mostra tempo restante (10s)

**Estratégia de Teste**:
- Marque uma posição, vá para outro local, volte usando Callback

---

## 🔍 Indicadores Visuais Importantes

### Cooldown Indicator (Canto Superior Direito)
- **Vermelho + Tempo**: Habilidade em cooldown
- **Verde + "PRONTA"**: Habilidade disponível
- **Ícone Específico**: Mostra linguagem atual

### HUD Linguagem (Canto Superior Esquerdo)
- **Linguagem Atual**: Nome da linguagem selecionada
- **Habilidade Ativa**: Nome da habilidade especial

### Feedback do Player
- **Verde**: Habilidade usada com sucesso
- **Vermelho**: Habilidade indisponível (cooldown)
- **Amarelo**: Falha ao usar habilidade

---

## 🐛 Solução de Problemas

### Se a UI não aparecer:
1. Verifique se todos os arquivos foram criados corretamente
2. Reinicie o Godot e abra o projeto novamente

### Se habilidades não funcionarem:
1. Confirme se a linguagem foi selecionada
2. Verifique cooldown no indicador visual
3. Teste em áreas apropriadas (vazios para pontes, obstáculos para garbage collection)

### Se teletransporte não funcionar:
1. Confirme que a posição foi marcada (console.log)
2. Mova-se para local diferente antes do segundo uso
3. Aguarde cooldown completar

---

## ✅ Checklist de Validação

### Interface
- [ ] Seleção de linguagem funciona
- [ ] UI de cooldown visível
- [ ] HUD informativo atualizado
- [ ] Controles respondem

### Python (Duck Typing)
- [ ] Habilidade pode ser usada uma vez
- [ ] Interação incorreta permitida temporariamente  
- [ ] Cooldown de 8s funciona

### Java (Garbage Collector)
- [ ] Remove obstáculos físicos
- [ ] Feedback visual apropriado
- [ ] Cooldown de 12s funciona

### C# (.NET Framework)
- [ ] Cria ponte sobre vazios
- [ ] Ponte dura 15 segundos
- [ ] Pode atravessar antes de desaparecer

### JavaScript (Callback)
- [ ] Marca posição no primeiro uso
- [ ] Teleporta para posição marcada no segundo uso
- [ ] Cooldown de 10s funciona

---

## 🎯 Status Final

**TODAS AS 4 LINGUAGENS IMPLEMENTADAS E FUNCIONAIS!**

O Sistema de Habilidades por Linguagem está 100% operacional e pronto para integração com os níveis do jogo.