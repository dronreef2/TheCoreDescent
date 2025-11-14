# GUIA DE EXECUÇÃO DE TESTES - THE CORE DESCENT
## Passo a Passo para Validação Completa

Este guia fornece instruções passo a passo para executar todos os testes de validação do "The Core Descent" após a implementação do Sprint 5.

---

## 🚀 PREPARAÇÃO INICIAL

### 1. Verificação do Ambiente
Antes de começar os testes, certifique-se de que:

- [ ] **Godot 4.3+** está instalado e funcionando
- [ ] Projeto "The Core Descent" abre sem erros
- [ ] Console do Godot (F12) está disponível para monitoramento
- [ ] Sistema tem pelo least 2GB de RAM livre
- [ ] Ambiente está livre de outros processos intensivos

### 2. Configuração do Projeto
No Godot Editor:

1. **Abrir o projeto:**
   ```
   Arquivo → Abrir → /workspace/projeto_godot/
   ```

2. **Verificar estrutura:**
   - Verificar se todos os arquivos Level1-9.gd estão em `/codigo/`
   - Verificar se LevelManager.gd está atualizado

3. **Configurações de performance:**
   ```
   Projeto → Configurações do Projeto → Renderização
   - VSync: Habilitado
   - FPS máximo: 60
   ```

4. **Configurar console para verbose:**
   ```
   Projeto → Configurações do Projeto → Debug
   - Stdout: Ativo
   - Stderr: Ativo
   ```

---

## 🔧 EXECUÇÃO DOS TESTES

### MÉTODO 1: TESTES AUTOMATIZADOS (RECOMENDADO)

#### Passo 1: Carregar Script de Testes
1. No Godot Editor, criar novo script:
   ```
   right-click em Main → Novo Script → ValidacaoTestes.gd
   ```

2. Copiar conteúdo de `/workspace/testes_automatizados/AutomatedTestSuite.gd`

3. No `_ready()` do Main.gd, adicionar:
   ```gdscript
   func _ready():
       # Código existente...
       
       # Inicializar testes automatizados
       var test_suite = AutomatedTestSuite.new()
       add_child(test_suite)
       
       # Aguardar 2 segundos e executar testes
       await get_tree().create_timer(2.0).timeout
       test_suite.run_complete_test_suite()
   ```

#### Passo 2: Executar Testes
1. **Rodar o projeto:** F5 ou botão "Rodar"
2. **Monitorar console:** F12 para ver output dos testes
3. **Aguardar conclusão:** Testes leva 15-20 minutos

#### Passo 3: Analisar Resultados
- Console mostrará progresso em tempo real
- Arquivo de relatório será salvo em `user://test_report_*.md`
- Verificar se score geral ≥ 70%

### MÉTODO 2: VALIDAÇÃO DE INTEGRAÇÃO

#### Passo 1: Carregar Validador
1. Criar script `ValidacaoIntegracao.gd` no Main
2. Copiar conteúdo de `/workspace/validacao_tecnica/SystemIntegrationValidator.gd`

#### Passo 2: Executar Validação
```gdscript
func _ready():
    var validator = SystemIntegrationValidator.new()
    add_child(validator)
    
    await get_tree().create_timer(1.0).timeout
    validator.run_full_validation()
```

#### Passo 3: Verificar Health Score
- **Excelente:** ≥ 80%
- **Bom:** 65-79%
- **Aceitável:** 50-64%
- **Pobre:** 30-49%
- **Crítico:** < 30%

### MÉTODO 3: TESTES MANUAIS DETALHADOS

#### Preparação
1. Abrir guia manual: `/workspace/testes_manuais/GUIA_TESTES_MANUAIS_COMPLETO.md`
2. Imprimir checklist para acompanhamento
3. Preparar planilha para documentar resultados

#### Execução por Fases

##### Fase 1: Estrutura Básica (30 min)
- [ ] Carregamento do menu principal
- [ ] Navegação entre menus
- [ ] UI responsiveness
- [ ] Performance básica (FPS > 55)

##### Fase 2: Progressão Linear (60 min)
Testar cada nível sequencialmente:

**Para cada nível 1-9:**
1. Verificar se está desbloqueado corretamente
2. Carregar nível (tempo < 3s)
3. Jogar primeiro puzzle
4. Verificar se score é calculável
5. Sair do nível (ESC → Menu)

**Critérios de Sucesso:**
- Progressão linear respeitada
- Carregamento sem erros
- Gameplay responsivo

##### Fase 3: Validação Detalhada (120 min)
Testar mecânicas específicas por nível:

**Nível 1:** Movimento básico, lógica simples
**Nível 2:** Sistema de ponteiros, habilidades C++
**Nível 3:** OOP, Java + Python
**Nível 4:** Concorrência, C# + JavaScript
**Nível 5:** Arquitetura, todas linguagens
**Nível 6:** Web dev, HTML/CSS/JS/React
**Nível 7:** Mobile, iOS/Android
**Nível 8:** Data Science, ML
**Nível 9:** Emerging tech, IoT/Blockchain

##### Fase 4: Sistemas Avançados (45 min)
- [ ] Sistema de habilidades (F key)
- [ ] Modo avançado (Shift+F)
- [ ] Maestria (Shift+M)
- [ ] Upgrades (Shift+U)
- [ ] Estatísticas (Shift+S)
- [ ] Persistência de dados

##### Fase 5: Performance (30 min)
- [ ] FPS monitorado em cada nível
- [ ] Memory usage stable
- [ ] Stress test 30min gameplay
- [ ] Load times adequados

---

## 📊 MONITORAMENTO DURANTE TESTES

### Console do Godot (F12)
**Output Esperado:**
```
🧪 Suite de testes automatizados configurada
🚀 Iniciando suite completa de testes...
🔍 Testando nível 1: A Torre de Marfim
📥 Nível 1 carregado em 1.2s
🧩 Testando 5 puzzles do nível 1
✅ Nível 1 testado - Score: 87 | Tempo: 45.3s
```

**Alertas Críticos:**
```
❌ ERRO: Nível X não encontrado
⚠️ Carregamento lento do nível X: 5.2s
🚨 Memory leak detectado
```

### Métricas a Monitorar
- **FPS:** Mantém ≥ 55 em gameplay normal
- **Memory:** ≤ 300MB durante uso normal
- **Load Time:** ≤ 3s para qualquer nível
- **Responsiveness:** Input response < 16ms

---

## 🐛 DOCUMENTAÇÃO DE BUGS

### Formato Padrão
```
**BUG #[Número]**
**Nível:** X
**Puzzle:** X.X
**Descrição:** [Descrição clara]
**Passos para Reproduzir:**
1. [Passo 1]
2. [Passo 2]
3. [Comportamento inesperado]
**Comportamento Esperado:** [O que deveria acontecer]
**Severidade:** [Crítico/Alto/Médio/Baixo]
**Screenshot:** [Se aplicável]
**Console Log:** [Mensagens de erro relevantes]
```

### Severidade
- **🚨 Crítico:** Game crash, data loss, complete blocking
- **⚠️ Alto:** Incorrect gameplay, major UI problems
- **📝 Médio:** Visual glitches, minor logic errors
- **ℹ️ Baixo:** Cosmetic issues, text typos

### Localização de Arquivos
Salvar reports em:
```
/workspace/bugs_encontrados/
├── critical_bugs.md
├── high_priority_bugs.md
├── medium_priority_bugs.md
└── low_priority_bugs.md
```

---

## 📈 INTERPRETAÇÃO DOS RESULTADOS

### Score Automatizado
- **≥ 85:** Excelente - Pronto para produção
- **70-84:** Bom - Pequenos ajustes necessários
- **55-69:** Aceitável - Requer correções
- **< 55:** Precisa de trabalho significativo

### Health Score de Integração
- **≥ 80:** Excelente - Todas integrações funcionando
- **65-79:** Bom - Integrações estáveis
- **50-64:** Aceitável - alguns problemas de integração
- **< 50:** Crítico - Problemas sérios de arquitetura

### Indicadores de Problemas
**Performance Issues:**
- FPS drops para < 30
- Load times > 5s
- Memory usage > 500MB

**Integration Issues:**
- Sistema de habilidades não funciona
- Progressão de níveis quebrada
- Save/load não funciona

**Logic Issues:**
- Puzzles insolúveis
- Scores incorretos
- UI state inconsistencies

---

## 🔧 CORREÇÕES COMUNS

### Bug: Nível não carrega
**Verificar:**
1. Arquivo LevelX.gd existe em `/codigo/`
2. LevelManager.gd tem entrada correta
3. Scene path é válido
4. Script não tem erros de compilação

### Bug: Performance baixa
**Soluções:**
1. Otimizar código dos níveis mais pesados (5, 8, 9)
2. Reduzir object count na scene
3. Implementar object pooling
4. Otimizar texturas e sprites

### Bug: Sistema de habilidades não funciona
**Verificar:**
1. PlayerController tem referência ao sistema
2. Habilidades estão habilitadas para o nível
3. Abilities system não é null
4. Input handlers estão configurados

### Bug: Save/load não funciona
**Verificar:**
1. Métodos save_progress e load_saved_progress existem
2. Estrutura de dados está correta
3. Arquivo de save tem permissões adequadas
4. Dados serializados/deserializados corretamente

---

## ✅ CHECKLIST FINAL DE APROVAÇÃO

### Core Functionality
- [ ] Todos os 9 níveis carregam sem erros
- [ ] Progressão linear funciona corretamente
- [ ] Todos os 41 puzzles são solucionáveis
- [ ] Sistema de pontuação funciona
- [ ] Menus navegam corretamente

### Performance
- [ ] FPS ≥ 55 em todos os níveis
- [ ] Load time ≤ 3s por nível
- [ ] Memory usage ≤ 300MB
- [ ] Sem memory leaks detectáveis
- [ ] Input responsiveness < 16ms

### Integration
- [ ] Sistema de habilidades funciona
- [ ] Progressão de desbloqueio correta
- [ ] Save/load preserva dados
- [ ] Achievement system ativa
- [ ] Audio/visual feedback adequado

### Quality
- [ ] 0 bugs críticos
- [ ] ≤ 5 bugs de alta prioridade
- [ ] UI/UX consistente
- [ ] Text/interface legível
- [ ] No console errors críticos

### Documentation
- [ ] Test reports generated
- [ ] Bug reports documented
- [ ] Performance metrics recorded
- [ ] Integration status verified

---

## 📞 SUPORTE E TROUBLESHOOTING

### Problemas Comuns

**"Script compilation error"**
- Verificar sintaxe GDScript
- Confirmar que todos os extends estão corretos
- Verificar referências de arquivos

**"Null reference exception"**
- Verificar se nodes existem antes de usar
- Adicionar verificações null antes de chamar métodos
- Verificar ordem de inicialização

**"Performance degradation"**
- Usar profiler do Godot para identificar bottlenecks
- Otimizar loops e operações pesadas
- Reduzir object creation em runtime

### Logs Úteis
Habilitar logs detalhados:
```gdscript
# Em configurações do projeto
[application]
config/version="1.0.0-Sprint5"

[display]
window/size/viewport_width=1280
window/size/viewport_height=720

[rendering]
quality/driver/driver_name="opengl3"
```

### Contatos de Suporte
Para dúvidas durante testes:
1. Verificar console do Godot primeiro
2. Consultar este guia
3. Revisar documentação técnica
4. Documentar issues para revisão posterior

---

**Após concluir todos os testes:**

1. **Compilar relatório final**
2. **Priorizar correções necessárias**  
3. **Implementar fixes**
4. **Re-validar após correções**
5. **Preparar para Sprint 6**

**Status Final Esperado:** ✅ APROVADO PARA PRODUÇÃO

---

**Data de Execução:** _______________  
**Responsável pelos Testes:** _______________  
**Versão Testada:** 1.0.0 (Sprint 5)  
**Resultado:** ⬜ APROVADO ⬜ APROVADO COM RESSALVAS ⬜ REPROVADO
