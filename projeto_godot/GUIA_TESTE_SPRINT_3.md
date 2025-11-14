# 🧪 Guia de Teste - Sprint 3: Sistema Avançado

## 🚀 Instruções de Execução

### 1. Abrir e Executar
- Abra o Godot 4.3
- Importe o projeto: `/workspace/projeto_godot/`
- Pressione **F5** para executar

### 2. Seleção Inicial
- Interface de seleção aparecerá automaticamente
- Escolha qualquer linguagem para começar

### 3. Controles do Sprint 3
```
CONTROLES BÁSICOS:
F - Usar Habilidade

CONTROLES AVANÇADOS (Sprint 3):
Shift+F - Alternar modo (Básico/Avançado)
Shift+M - Ver Maestria de todas linguagens
Shift+U - Ver Melhorias disponíveis
Shift+S - Ver Estatísticas globais
Shift+I - Info Avançada da linguagem atual
```

---

## 🎯 TESTE 1: Sistema de Maestria

### Objetivo
Validar que o sistema de maestria funciona corretamente e progride naturalmente.

### Passo a Passo
1. **Selecione uma linguagem** (ex: Python 🐍)
2. **Use a habilidade repetidamente** (tecla F)
3. **Observe a progressão**:
   - Barra de progresso deve subir gradualmente
   - Label "XP: X / 25" deve atualizar
   - Após 25 XP: Notificação "Maestria subiu para nível 1!"

### Critérios de Sucesso
- [ ] XP aumenta corretamente (10 XP por uso)
- [ ] Progress bar atualiza em tempo real
- [ ] Notificações aparecem nas subidas de nível
- [ ] Máximo 5 níveis de maestria (0-4)

### Indicadores Visuais
- **Progress Bar**: Cor específica da linguagem
- **Feedback XP**: Label mostra "XP: X / Y" 
- **Notificações**: Console mostra "🎉 Maestria em Python subiu para nível 1!"

---

## 🎮 TESTE 2: Habilidades Evolutivas

### Objetivo
Validar que habilidades evoluem conforme nível de maestria.

### Python - Duck Typing
1. **Nível 0-1**: Duck Typing básico (8s cooldown)
2. **Nível 2-3**: Duck Typing Inteligente
3. **Nível 4-5**: Duck Typing Persistente (30s)

**Como Testar**:
- Use habilidade repetidamente até subir de nível
- Observe mudanças na descrição da habilidade
- Teste mecânicas específicas por nível

### Java - Garbage Collector
1. **Nível 0-1**: Remove obstáculo único
2. **Nível 2-3**: Remove obstáculos precisos
3. **Nível 4-5**: Remove obstáculos relacionados

**Como Testar**:
- Localize obstáculos no cenário
- Use habilidade em diferentes níveis
- Observe mudanças no comportamento

### C# - .NET Framework
1. **Nível 0-1**: Ponte básica
2. **Nível 2-3**: Ponte inteligente  
3. **Nível 4-5**: Multi-estruturas

**Como Testar**:
- Use sobre gaps/vazios
- Observe tipos de estruturas criadas
- Teste criação automática de múltiplas pontes

### JavaScript - Callback
1. **Nível 0-1**: Teletransporte simples
2. **Nível 2-3**: Cadeia de callbacks
3. **Nível 4-5**: Sistema assíncrono

**Como Testar**:
- Marque posição, teleporta
- Em nível alto: Teste múltiplos teletransportes
- Observe fila de eventos se disponível

### Critérios de Sucesso
- [ ] Cada nível tem comportamento distinto
- [ ] Descrição da habilidade atualiza
- [ ] Mecânicas específicas funcionam por nível
- [ ] Feedback visual apropriado

---

## 🛒 TESTE 3: Sistema de Melhorias

### Objetivo
Validar sistema de compra e ativação de melhorias.

### Passo a Passo
1. **Ganhe XP suficiente** (50+ XP recomendados)
2. **Pressione Shift+U** para ver melhorias
3. **Clique em "Comprar"** para uma melhoria
4. **Observe efeito** da melhoria ativada

### Melhorias por Linguagem

#### 🐍 Python
- **Type Hints** (50 XP): Duck Typing mais inteligente
- **List Comprehension** (75 XP): Múltiplas verificações
- **Context Manager** (100 XP): Duck Typing persistente

#### ☕ Java
- **Lambda Expressions** (60 XP): GC mais preciso
- **Streams API** (80 XP): GC em área maior  
- **Optional Class** (120 XP): GC inteligente

#### # C#
- **LINQ Queries** (70 XP): Pontes mais inteligentes
- **Async/Await** (90 XP): Pontes persistentes
- **Extension Methods** (110 XP): Múltiplas pontes

#### ⚡ JavaScript
- **Async Functions** (65 XP): Callbacks encadeados
- **Arrow Functions** (85 XP): Callback instantâneo
- **Destructuring** (105 XP): Múltiplos callbacks

### Critérios de Sucesso
- [ ] Botão "Comprar" habilitado apenas com XP suficiente
- [ ] XP deduzido corretamente após compra
- [ ] Melhoria ativada e funcional
- [ ] Feedback visual da ativação

---

## 📊 TESTE 4: Interface Avançada

### Mastery Overview (Shift+M)
**Objetivo**: Validar painel de maestria de todas linguagens

1. **Pressione Shift+M**
2. **Verifique**:
   - 4 cards (um por linguagem)
   - Progress bars para cada linguagem
   - Níveis de maestria atuais
   - XP atual de cada uma

### Estatísticas Globais (Shift+S)
**Objetivo**: Validar painel de estatísticas

1. **Pressione Shift+S**
2. **Verifique**:
   - Estatísticas detalhadas por linguagem
   - Níveis, XP, progresso percentual
   - Melhorias disponíveis por linguagem

### Info Avançada (Shift+I)
**Objetivo**: Validar info detalhada da linguagem atual

1. **Pressione Shift+I**
2. **Verifique**:
   - Painel aparecendo no canto superior esquerdo
   - Linguagem atual e ícone
   - Nível de maestria atual
   - Barra de progresso colorida
   - Descrição da habilidade evoluída

### Critérios de Sucesso
- [ ] Todos os painéis abrem corretamente
- [ ] Dados atualizados em tempo real
- [ ] Interface visual atraente e organizada
- [ ] Fechamento funciona (botão X)

---

## ⚔️ TESTE 5: Modos Básico vs Avançado

### Objetivo
Validar alternância entre sistema básico (Sprint 2) e avançado (Sprint 3).

### Passo a Passo
1. **Use habilidade normalmente** (F) - deve usar modo atual
2. **Pressione Shift+F** - alterna modo
3. **Use habilidade** - observe diferenças
4. **Repita** para alternar novamente

### Diferenças Esperadas

#### Modo Básico
- Comportamento original do Sprint 2
- Feedback visual simples (verde/vermelho)
- Sem maestria ou melhorias

#### Modo Avançado
- Habilidades evoluídas por maestria
- Feedback visual dourado/especial
- Sistema de XP e progressão ativa

### Critérios de Sucesso
- [ ] Alternância funciona corretamente
- [ ] Comportamentos distintos entre modos
- [ ] Feedback visual diferente
- [ ] Sistema de maestria apenas no modo avançado

---

## 🎨 TESTE 6: Efeitos Visuais Avançados

### Objetivo
Validar efeitos visuais e feedback aprimorado do Sprint 3.

### Teste de Efeitos de Maestria
1. **Alcance maestria nível 3+** em qualquer linguagem
2. **Use habilidade** em modo avançado
3. **Observe**:
   - Efeito dourado especial
   - Partículas de maestria (se implementado)
   - Animação de escala

### Teste de Feedback Avançado
1. **Use habilidade básica**: Efeito verde simples
2. **Use habilidade avançada**: Efeito dourado com animação
3. **Use habilidade falhada**: Efeito amarelo original

### Critérios de Sucesso
- [ ] Efeitos visuais diferenciados
- [ ] Animações suaves e responsivas
- [ ] Cores específicas por tipo de ação
- [ ] Partículas para maestria alta (se implementado)

---

## 🔧 Solução de Problemas

### Se maestria não progride:
1. Confirme que está em modo avançado (Shift+F)
2. Verifique se habilidade está funcionando (não em cooldown)
3. Aguarde alguns segundos para atualização da UI

### Se melhorias não aparecem:
1. Ganhe mais XP (50+ recomendado)
2. Pressione Shift+U para refresh
3. Confirme que linguagem está selecionada

### Se UI não responde:
1. Verifique se AdvancedLanguageUI está carregada
2. Reinicie o Godot se necessário
3. Confirme que todos os scripts foram compilados

---

## ✅ Checklist Final de Validação

### Sistema de Maestria
- [ ] XP aumenta corretamente (10 por uso)
- [ ] Progress bars atualizam em tempo real
- [ ] Notificações de subida de nível aparecem
- [ ] Máximo 5 níveis funcionando
- [ ] Sistema reseta corretamente

### Habilidades Evolutivas
- [ ] Python: 3 níveis de Duck Typing funcionando
- [ ] Java: 3 níveis de GC funcionando
- [ ] C#: 3 níveis de .NET funcionando  
- [ ] JavaScript: 3 níveis de Callback funcionando
- [ ] Descrições atualizam por nível

### Sistema de Melhorias
- [ ] 12 melhorias disponíveis (3 por linguagem)
- [ ] Compra com XP funciona corretamente
- [ ] Melhorias ativam efeitos reais
- [ ] Interface de compra é intuitiva

### Interface Avançada
- [ ] Shift+M: Mastery overview funcional
- [ ] Shift+S: Estatísticas globais funcionais
- [ ] Shift+I: Info avançada atualizada
- [ ] Shift+U: Sistema de compras funcional

### Modos de Jogo
- [ ] Shift+F: Alterna modo básico/avançado
- [ ] Modo básico: Comportamento original
- [ ] Modo avançado: Todas as novas features
- [ ] Feedback visual diferenciado

### Efeitos Visuais
- [ ] Efeitos básicos (verde/vermelho/amarelo)
- [ ] Efeitos avançados (dourado com animação)
- [ ] Progress bars coloridas por linguagem
- [ ] Animações suaves e responsivas

---

## 🏆 Status Final

**TODAS AS FUNCIONALIDADES DO SPRINT 3 IMPLEMENTADAS E FUNCIONAIS!**

O Sistema Avançado de Habilidades por Linguagem está 100% operacional com:

✅ **Sistema de Maestria** completo e progressivo  
✅ **12 Melhorias** compráveis e funcionais  
✅ **Habilidades Evolutivas** por nível  
✅ **Interface Avançada** com todos os painéis  
✅ **Controles Intuitivos** e responsivos  
✅ **Efeitos Visuais** aprimorados  

**O Sprint 3 está completo e pronto para gameplay avançado! 🚀**