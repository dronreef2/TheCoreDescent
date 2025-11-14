# GUIA COMPLETO DE TESTES MANUAIS - THE CORE DESCENT
## Validação dos 9 Níveis Completos

Este guia fornece instruções detalhadas para validação manual completa de todos os sistemas do jogo "The Core Descent" após a implementação do Sprint 5.

---

## 📋 CHECKLIST DE TESTES PRÉ-REQUISITOS

### ✅ Configuração do Ambiente
- [ ] Godot 4.3+ instalado e configurado
- [ ] Projeto "The Core Descent" carregado sem erros
- [ ] Todos os 9 níveis (Level1.gd - Level9.gd) presentes em `/codigo/`
- [ ] LevelManager.gd atualizado com todos os níveis
- [ ] PlayerController.gd e sistemas de habilidades funcionando
- [ ] Interface de usuário responsiva

### ✅ Verificação de Arquivos
- [ ] Nível 1: A Torre de Marfim (494 linhas)
- [ ] Nível 2: A Forja de Ponteiros (714 linhas) 
- [ ] Nível 3: A Biblioteca de Objetos (883 linhas)
- [ ] Nível 4: A Arquitetura Concorrente (1,115 linhas)
- [ ] Nível 5: O Arquiteto de Software (1,446 linhas)
- [ ] Nível 6: A Arquitetura Web (496 linhas)
- [ ] Nível 7: O Ecossistema Mobile (698 linhas)
- [ ] Nível 8: A Ciência dos Dados (881 linhas)
- [ ] Nível 9: As Fronteiras da Tecnologia (1,071 linhas)

---

## 🎮 TESTE 1: PROGRESSÃO ENTRE NÍVEIS

### 1.1 Sequência Linear de Desbloqueio
**Objetivo:** Verificar se os níveis se desbloqueiam corretamente na sequência

**Passos:**
1. Iniciar o jogo no menu principal
2. **Nível 1 (A Torre de Marfim):**
   - [ ] Está disponível desde o início
   - [ ] Carrega sem erros
   - [ ] Pode ser jogado normalmente
   - [ ] Concluir o nível (score ≥ 85%)
3. **Nível 2 (A Forja de Ponteiros):**
   - [ ] Deve ficar desbloqueado após conclusão do Nível 1
   - [ ] Carrega sem erros
   - [ ] Concluir o nível
4. **Repetir para Níveis 3-9:**
   - [ ] Cada nível só fica disponível após conclusão do anterior
   - [ ] Não deve ser possível pular níveis
   - [ ] Todos carregam corretamente

**Critérios de Sucesso:**
- ✅ Progressão linear respeitada
- ✅ Todos os 9 níveis carregam sem erros
- ✅ Sistema de desbloqueio funciona

### 1.2 Funcionalidade de Menu
**Passos:**
1. Durante qualquer nível, pressionar ESC
2. **Menu de Pausa:**
   - [ ] Opção "Continuar" funciona
   - [ ] Opção "Reiniciar Nível" funciona
   - [ ] Opção "Menu Principal" funciona
3. Menu Principal:
   - [ ] Lista todos os 9 níveis
   - [ ] Níveis completados mostram score
   - [ ] Níveis bloqueados mostram cadeado
   - [ ] Click em nível desbloqueado carrega corretamente

**Critérios de Sucesso:**
- ✅ Navegação fluida entre menus
- ✅ Estados preservados corretamente

---

## 🧩 TESTE 2: FUNCIONAMENTO DOS 41 PUZZLES

### 2.1 Nível 1 - A Torre de Marfim (5 puzzles)
**Tema:** Conceitos básicos de lógica

**Puzzle 1.1 - Lógica Básica:**
- [ ] Blocos de variável disponíveis
- [ ] Movimento básico funciona
- [ ] Sequência linear pode ser criada
- **Solução esperada:** 3-5 movimentos

**Puzzle 1.2 - Estruturas Condicionais:**
- [ ] Blocos IF disponíveis
- [ ] Conectores de saída funcionam
- [ ] Condições podem ser configuradas
- **Solução esperada:** 4-6 movimentos

**Puzzle 1.3 - Loops Simples:**
- [ ] Blocos FOR disponíveis
- [ ] Limites de loop configuráveis
- [ ] Fluxo de execução correto
- **Solução esperada:** 5-7 movimentos

**Puzzle 1.4 - Funções Básicas:**
- [ ] Chamadas de função funcionais
- [ ] Parâmetros podem ser definidos
- [ ] Retorno de valores funciona
- **Solução esperada:** 6-8 movimentos

**Puzzle 1.5 - Integração:**
- [ ] Todos os conceitos anteriores
- [ ] Combinação de blocos correta
- [ ] Solução completa funcional
- **Solução esperada:** 8 movimentos

### 2.2 Nível 2 - A Forja de Ponteiros (6 puzzles)
**Tema:** Ponteiros e gerenciamento de memória

**Puzzle 2.1 - Referência vs Valor:**
- [ ] Conceito de ponteiro implementado
- [ ] Diferenciação valor/referência visível
- [ ] Manipulação de endereços
- **Solução esperada:** 5-7 movimentos

**Puzzle 2.2 - Aritmética de Ponteiros:**
- [ ] Operações com ponteiros
- [ ] Navegação em memória
- [ ] Alocação dinâmica
- **Solução esperada:** 6-8 movimentos

**Puzzle 2.3 - Ponteiros e Arrays:**
- [ ] Arrays como ponteiros
- [ ] Indexação via ponteiros
- [ ] Passagem por referência
- **Solução esperada:** 7-9 movimentos

**Puzzle 2.4 - Ponteiros de Função:**
- [ ] Callback functions
- [ ] Function pointers
- [ ] Dynamic dispatch
- **Solução esperada:** 8-10 movimentos

**Puzzle 2.5 - Gestão de Memória:**
- [ ] malloc/free concepts
- [ ] Memory leaks detection
- [ ] Smart pointers
- **Solução esperada:** 9-11 movimentos

**Puzzle 2.6 - Integração Avançada:**
- [ ] Todos os conceitos de ponteiros
- [ ] Otimização de código
- **Solução esperada:** 12 movimentos

### 2.3 Nível 3 - A Biblioteca de Objetos (6 puzzles)
**Tema:** Orientação a objetos

**Puzzle 3.1 - Classes e Objetos:**
- [ ] Criação de classes
- [ ] Instanciação de objetos
- [ ] Construtores
- **Solução esperada:** 6-8 movimentos

**Puzzle 3.2 - Herança:**
- [ ] Hierarquia de classes
- [ ] Subclasses funcionais
- [ ] Method overriding
- **Solução esperada:** 7-9 movimentos

**Puzzle 3.3 - Polimorfismo:**
- [ ] Dynamic binding
- [ ] Interface implementation
- [ ] Runtime type checking
- **Solução esperada:** 8-10 movimentos

**Puzzle 3.4 - Encapsulamento:**
- [ ] Private/public members
- [ ] Getters/setters
- [ ] Data hiding
- **Solução esperada:** 7-9 movimentos

**Puzzle 3.5 - Abstract Classes:**
- [ ] Abstract methods
- [ ] Interface contracts
- [ ] Multiple inheritance
- **Solução esperada:** 9-11 movimentos

**Puzzle 3.6 - Padrões de Design:**
- [ ] Singleton, Factory, Observer
- [ ] Design pattern integration
- **Solução esperada:** 11-13 movimentos

### 2.4 Nível 4 - A Arquitetura Concorrente (6 puzzles)
**Tema:** Concorrência e paralelismo

**Puzzle 4.1 - Threads Básicas:**
- [ ] Thread creation
- [ ] Thread execution
- [ ] Basic synchronization
- **Solução esperada:** 8-10 movimentos

**Puzzle 4.2 - Locks e Mutex:**
- [ ] Critical sections
- [ ] Mutex implementation
- [ ] Race condition prevention
- **Solução esperada:** 9-11 movimentos

**Puzzle 4.3 - Processos:**
- [ ] Process isolation
- [ ] IPC mechanisms
- [ ] Communication protocols
- **Solução esperada:** 10-12 movimentos

**Puzzle 4.4 - Future/Promise:**
- [ ] Async operations
- [ ] Result callbacks
- [ ] Error handling
- **Solução esperada:** 11-13 movimentos

**Puzzle 4.5 - Deadlock Prevention:**
- [ ] Deadlock detection
- [ ] Resource allocation
- [ ] Circular wait prevention
- **Solução esperada:** 12-14 movimentos

**Puzzle 4.6 - Integração Concorrente:**
- [ ] Multi-threading patterns
- [ ] Performance optimization
- **Solução esperada:** 14-16 movimentos

### 2.5 Nível 5 - O Arquiteto de Software (6 puzzles)
**Tema:** Arquitetura e padrões avançados

**Puzzle 5.1 - MVC Pattern:**
- [ ] Model-View-Controller
- [ ] Separation of concerns
- [ ] Data flow
- **Solução esperada:** 10-12 movimentos

**Puzzle 5.2 - Dependency Injection:**
- [ ] DI container
- [ ] Service registration
- [ ] Constructor injection
- **Solução esperada:** 11-13 movimentos

**Puzzle 5.3 - Microservices:**
- [ ] Service boundaries
- [ ] API communication
- [ ] Load balancing
- **Solução esperada:** 12-14 movimentos

**Puzzle 5.4 - Event-Driven:**
- [ ] Event bus
- [ ] Pub/Sub patterns
- [ ] Event handling
- **Solução esperada:** 13-15 movimentos

**Puzzle 5.5 - CQRS:**
- [ ] Command Query Separation
- [ ] Read/Write optimization
- **Solução esperada:** 14-16 movimentos

**Puzzle 5.6 - Arquitetura Completa:**
- [ ] All patterns integrated
- [ ] Scalability design
- **Solução esperada:** 16-20 movimentos

### 2.6 Nível 6 - A Arquitetura Web (6 puzzles)
**Tema:** Desenvolvimento web full-stack

**Puzzle 6.1 - HTML/CSS Basics:**
- [ ] DOM manipulation
- [ ] Styling system
- [ ] Layout creation
- **Solução esperada:** 8-10 movimentos

**Puzzle 6.2 - JavaScript Logic:**
- [ ] Event handling
- [ ] DOM interaction
- [ ] Script integration
- **Solução esperada:** 9-11 movimentos

**Puzzle 6.3 - API Integration:**
- [ ] REST API calls
- [ ] Data fetching
- [ ] JSON processing
- **Solução esperada:** 10-12 movimentos

**Puzzle 6.4 - Framework Components:**
- [ ] Component system
- [ ] Props/state
- [ ] Component lifecycle
- **Solução esperada:** 11-13 movimentos

**Puzzle 6.5 - Backend Services:**
- [ ] Server logic
- [ ] Database integration
- [ ] Authentication
- **Solução esperada:** 12-14 movimentos

**Puzzle 6.6 - Full-Stack Integration:**
- [ ] Frontend + Backend
- [ ] Real-time features
- **Solução esperada:** 14-16 movimentos

### 2.7 Nível 7 - O Ecossistema Mobile (6 puzzles)
**Tema:** Desenvolvimento mobile

**Puzzle 7.1 - Native Development:**
- [ ] Platform APIs
- [ ] Native UI components
- [ ] Device features
- **Solução esperada:** 10-12 movimentos

**Puzzle 7.2 - Cross-Platform:**
- [ ] Shared codebase
- [ ] Platform abstraction
- [ ] Code reuse
- **Solução esperada:** 11-13 movimentos

**Puzzle 7.3 - Mobile UI/UX:**
- [ ] Touch interfaces
- [ ] Responsive design
- [ ] Navigation patterns
- **Solução esperada:** 12-14 movimentos

**Puzzle 7.4 - Device Features:**
- [ ] Camera integration
- [ ] GPS/location
- [ ] Sensors
- **Solução esperada:** 13-15 movimentos

**Puzzle 7.5 - Performance:**
- [ ] Memory management
- [ ] Battery optimization
- [ ] App lifecycle
- **Solução esperada:** 14-16 movimentos

**Puzzle 7.6 - App Distribution:**
- [ ] App store integration
- [ ] Updates mechanism
- **Solução esperada:** 16-18 movimentos

### 2.8 Nível 8 - A Ciência dos Dados (6 puzzles)
**Tema:** Data Science e Machine Learning

**Puzzle 8.1 - Data Processing:**
- [ ] Data cleaning
- [ ] Data transformation
- [ ] Analysis pipeline
- **Solução esperada:** 12-14 movimentos

**Puzzle 8.2 - Feature Engineering:**
- [ ] Feature extraction
- [ ] Data normalization
- [ ] Feature selection
- **Solução esperada:** 13-15 movimentos

**Puzzle 8.3 - ML Algorithms:**
- [ ] Supervised learning
- [ ] Model training
- [ ] Prediction system
- **Solução esperada:** 14-16 movimentos

**Puzzle 8.4 - Deep Learning:**
- [ ] Neural networks
- [ ] Backpropagation
- [ ] Model optimization
- **Solução esperada:** 15-17 movimentos

**Puzzle 8.5 - Big Data:**
- [ ] Distributed processing
- [ ] Data streaming
- [ ] Scalable analytics
- **Solução esperada:** 16-18 movimentos

**Puzzle 8.6 - MLOps:**
- [ ] Model deployment
- [ ] Monitoring system
- [ ] Continuous improvement
- **Solução esperada:** 18-20 movimentos

### 2.9 Nível 9 - As Fronteiras da Tecnologia (6 puzzles)
**Tema:** Tecnologias emergentes

**Puzzle 9.1 - IoT Ecosystem:**
- [ ] Device connectivity
- [ ] Sensor networks
- [ ] Data collection
- **Solução esperada:** 14-16 movimentos

**Puzzle 9.2 - Blockchain:**
- [ ] Distributed ledger
- [ ] Smart contracts
- [ ] Consensus mechanisms
- **Solução esperada:** 15-17 movimentos

**Puzzle 9.3 - Quantum Computing:**
- [ ] Quantum gates
- [ ] Superposition
- [ ] Quantum algorithms
- **Solução esperada:** 16-18 movimentos

**Puzzle 9.4 - AR/VR Integration:**
- [ ] Spatial computing
- [ ] Immersive interfaces
- [ ] 3D interactions
- **Solução esperada:** 17-19 movimentos

**Puzzle 9.5 - Edge Computing:**
- [ ] Local processing
- [ ] Latency optimization
- [ ] Distributed intelligence
- **Solução esperada:** 18-20 movimentos

**Puzzle 9.6 - Sustainable Tech:**
- [ ] Green computing
- [ ] Energy efficiency
- [ ] Environmental impact
- **Solução esperada:** 20-25 movimentos

---

## ⚡ TESTE 3: PERFORMANCE (60 FPS)

### 3.1 Frame Rate Monitoring
**Ferramentas:** 
- Console do Godot (F12)
- Monitor de performance integrado

**Testes:**
1. **FPS por Nível:**
   - [ ] Nível 1: ≥ 55 FPS estável
   - [ ] Nível 2: ≥ 55 FPS estável
   - [ ] Nível 3: ≥ 55 FPS estável
   - [ ] Nível 4: ≥ 55 FPS estável
   - [ ] Nível 5: ≥ 50 FPS estável
   - [ ] Nível 6: ≥ 55 FPS estável
   - [ ] Nível 7: ≥ 55 FPS estável
   - [ ] Nível 8: ≥ 50 FPS estável
   - [ ] Nível 9: ≥ 50 FPS estável

2. **Stress Test:**
   - [ ] Jogar todos os níveis sequencialmente por 30 minutos
   - [ ] Verificar se FPS se mantém estável
   - [ ] Não deve haver travamentos ou stuttering

### 3.2 Memory Usage
**Critérios:**
- [ ] Uso inicial ≤ 100MB
- [ ] Uso máximo ≤ 300MB
- [ ] Não deve haver memory leaks perceptíveis

### 3.3 Load Times
**Objetivos:**
- [ ] Carregamento do menu: ≤ 2 segundos
- [ ] Carregamento de nível: ≤ 3 segundos
- [ ] Transição entre puzzles: ≤ 1 segundo

---

## 🔧 TESTE 4: INTEGRAÇÃO DOS SISTEMAS

### 4.1 Sistema de Habilidades (Sprint 2)
**PlayerController + LanguageAbilitySystem:**

**Teste por Nível:**
1. **Nível 1:**
   - [ ] Habilidades desabilitadas por padrão
   - [ ] Botão F não responde

2. **Nível 2:**
   - [ ] Habilidades habilitadas
   - [ ] Linguagem C++ disponível
   - [ ] Ponteiro ability funciona
   - [ ] Cooldown visível

3. **Nível 3:**
   - [ ] Linguagens Java e Python
   - [ ] Duck Typing (Python) funcional
   - [ ] Garbage Collector (Java) funcional

4. **Nível 4:**
   - [ ] Linguagens C# e JavaScript
   - [ ] Bridge (C#) funcional
   - [ ] Callback (JS) funcional

5. **Nível 5:**
   - [ ] Todas as 5 linguagens disponíveis
   - [ ] Switching entre linguagens
   - [ ] Combinação de abilities

**Níveis 6-9:**
- [ ] Habilidades tecnológicas específicas funcionam
- [ ] No conflicts entre sistemas
- [ ] UI feedback adequado

### 4.2 Sistema de Maestria (Sprint 3)
**AdvancedLanguageAbilitySystem:**

**Funcionalidades:**
- [ ] XP system visível (Shift+M)
- [ ] Mastery levels increase
- [ ] Upgrade system (Shift+U)
- [ ] Statistics display (Shift+S)
- [ ] Advanced info (Shift+I)
- [ ] Mode toggle (Shift+F)

**Progressive Unlocking:**
- [ ] Level 1-2: Basic mastery
- [ ] Level 3-4: Intermediate
- [ ] Level 5-6: Advanced
- [ ] Level 7-9: Expert mastery

### 4.3 Persistência de Dados
**Progress Saving:**
- [ ] Conclusões de níveis salvas
- [ ] Scores preservados
- [ ] Mastery progress mantido
- [ ] Achievement system funcional
- [ ] Reload não perde dados

### 4.4 Sistema de Conquistas
**Achievements to Test:**
- [ ] "Primeiros Passos" - Complete 1st level
- [ ] "Perfeccionista" - 100% score em qualquer nível
- [ ] "Velocista" - Complete nível < 2 minutes
- [ ] "Arquiteto Completo" - Complete all levels

---

## 🐛 BUG TRACKING

### Formato de Report de Bug:
```
**BUG #XXX**
**Nível:** X
**Puzzle:** X.X
**Descrição:** [Descrição clara do problema]
**Passos para Reproduzir:**
1. [Passo 1]
2. [Passo 2]
3. [Comportamento inesperado]
**Comportamento Esperado:** [O que deveria acontecer]
**Severidade:** [Crítico/Alto/Médio/Baixo]
**Screenshot/Log:** [Se aplicável]
```

### Categorias de Bugs:

#### 🚨 Críticos
- [ ] Game crash durante gameplay
- [ ] Loss de save data
- [ ] Complete level blocking
- [ ] System integration failure

#### ⚠️ Altos
- [ ] Incorrect puzzle solutions
- [ ] Score calculation errors
- [ ] UI/UX problems
- [ ] Performance degradation

#### 📝 Médios
- [ ] Visual glitches
- [ ] Audio problems
- [ ] Minor logic errors
- [ ] Text/typo issues

#### ℹ️ Baixos
- [ ] Cosmetic issues
- [ ] Minor performance impacts
- [ ] Documentation errors

---

## ✅ RELATÓRIO FINAL

### Checklist de Completion:
- [ ] Todos os 9 níveis testados individualmente
- [ ] Todos os 41 puzzles validados
- [ ] Performance targets atingidos
- [ ] Integração entre sistemas verificada
- [ ] Bug reports documentados
- [ ] Sistema de progressão validado
- [ ] Funcionalidades avançadas testadas

### Métricas de Sucesso:
- **Taxa de Conclusão:** ≥ 95% dos puzzles devem ser solucionáveis
- **Performance:** ≥ 55 FPS médio, ≥ 50 FPS mínimo
- **Estabilidade:** 0 crashes durante 2+ horas de teste
- **Usabilidade:** Todas as funcionalidades acessíveis via UI

### Próximos Passos após Testes:
1. **Correção de Bugs Críticos**
2. **Otimização de Performance**
3. **Ajustes de Balanceamento**
4. **Validação Final**
5. **Preparação para Sprint 6**

---

**Data do Teste:** _______________
**Responsável:** _______________
**Versão do Jogo:** 1.0.0 (Sprint 5)
**Resultado Final:** ⬜ APROVADO ⬜ REPROVADO

**Observações:**
```
[Espaço para comentários adicionais, sugestões de melhoria, ou outras notas relevantes]
```
