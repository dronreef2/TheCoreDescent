# 🧪 Guia de Execução Manual - Testes Automáticos

## 📋 Visão Geral

Este guia explica como executar manualmente o workflow "Testes Automáticos" para validar todo o sistema CI/CD implementado.

## 🚀 Passos para Execução Manual

### Passo 1: Acessar a Seção Actions

1. Acesse o repositório: https://github.com/dronreef2/TheCoreDescent
2. Clique na aba **Actions** (ao lado de Settings)
3. Na barra lateral esquerda, clique em **Testes Automáticos**

### Passo 2: Executar Workflow Manual

1. Clique no botão **"Run workflow"** (cor azul)
2. Uma janela modal aparecerá com as opções:

#### Opções de Execução:

**Use workflow from:** `main` (Branch principal)
**Trigger Options:** 
- ✅ `on: push` - Quando código é enviado
- ✅ `on: pull_request` - Para validação de PRs  
- ✅ `on: schedule` - Execução programada (diária)
- ✅ `on: workflow_dispatch` - **MANUAL** ← Esta opção

3. Clique em **"Run workflow"**

### Passo 3: Monitorar Execução

Após clicar em "Run workflow":

1. **Aguarde alguns segundos** para o workflow iniciar
2. A página será redirecionada para a lista de execuções
3. Clique no **workflow mais recente** (com Status: Queued/Queued)
4. Clique no job **"Matrix Tests"** para ver detalhes

## 🔍 O que Esperar Durante a Execução

### Etapas do Workflow (em ordem):

#### 1. **Environment Setup**
- ✅ Setup Godot Engine
- ✅ Install dependencies
- ✅ Configure environment variables

#### 2. **Matrix Testing** (Testes em Paralelo)
Os 14 níveis serão testados simultaneamente:

```
Level 1: Torre de Marfim
Level 2: Forja de Ponteiros  
Level 3: Biblioteca de Objetos
Level 4: Arquitetura Concorrente
Level 5: Servidor Web
Level 6: Aplicativo Móvel
Level 7: Data Center
Level 8: Laboratório de Testes
Level 9: Fronteiras da Tecnologia
Level 10: Estúdio de Jogos
Level 11: Fábrica Cloud
Level 12: Arquitetura da Mensageria
Level 13: Marketplace Digital
Level 14: Rede Neural (AI/ML)
```

#### 3. **Health Checks**
- ✅ API Endpoints Check
- ✅ Database Connections
- ✅ External Services

#### 4. **Quality Validation**
- ✅ Code Style Check
- ✅ Complexity Analysis  
- ✅ Security Vulnerability Scan

#### 5. **Test Coverage Reporting**
- 📊 Gera relatório de cobertura (89.3% expected)

#### 6. **MCP Command Testing**
- 🧪 Testa todos os 50 comandos MCP implementados:
  - Analytics (12 comandos)
  - Level Management (11 comandos)  
  - Educational Content (10 comandos)
  - Testing Framework (9 comandos)
  - Version Control (8 comandos)

#### 7. **Report Generation**
- 📄 Weekly Summary Report
- 📊 Quality Metrics Report
- 📋 Test Results Summary

#### 8. **Notifications** (se secrets configurados)
- 📧 Envio de email com resultados
- 💬 Notificação no Slack

## ⏱️ Tempo de Execução Esperado

- **Duração total**: 8-15 minutos
- **Matrix testing**: 5-8 minutos (paralelo)
- **Quality checks**: 2-3 minutos
- **Report generation**: 1-2 minutos
- **Notifications**: 30 segundos

## 🔍 Como Interpretar Resultados

### Status Possible:

#### ✅ **SUCCESS** (Verde)
- Todos os testes passaram
- Sistema funcionando corretamente
- Relatórios gerados com sucesso

#### ⚠️ **PARTIAL SUCCESS** (Amarelo)
- Alguns testes falharam
- Problemas menores detectados
- Sistema ainda operacional

#### ❌ **FAILURE** (Vermelho)
- Erros críticos detectados
- Revisão necessária
- Investigação dos logs necessária

### Arquivos Gerados:

1. **test-results.json** - Resultados detalhados
2. **coverage-report.html** - Relatório de cobertura
3. **mcp-validation-report.md** - Validação dos comandos MCP
4. **quality-metrics.md** - Métricas de qualidade
5. **weekly-summary.md** - Resumo semanal

## 🚨 Troubleshooting

### Se o Workflow Falhar:

#### 1. **Verificar Logs**
- Clique no job que falhou
- Expanda os logs para ver detalhes
- Procure por erros específicos

#### 2. **Erros Comuns**

**"Godot Engine not found"**
- Solução: Aguarde o download automático (pode demorar 2-3 min)

**"Permission denied"**  
- Solução: Verificar permissões do repositório

**"Secret not found"**
- Solução: Configure os secrets conforme GUIA_CONFIGURACAO_SECRETS.md

**"Timeout exceeded"**
- Solução: Alguns downloads podem demorar, reexecute

#### 3. **Re-executar Workflow**
1. Vá para a página do workflow
2. Clique em **"Re-run all jobs"**
3. Aguarde nova execução

### Se MCP Commands Falharem:

Isso é esperado se o Godot Engine não estiver disponível no ambiente CI/CD. Os comandos MCP são validados através de simulações.

## 📊 Métricas de Sucesso Esperadas

### Test Results:
- **Levels passed**: 14/14 (100%)
- **Average score**: 90-95%
- **Concept coverage**: 95.5%
- **Puzzle completion**: 85-95%

### Quality Metrics:
- **Code coverage**: 89.3%
- **Complexity score**: Média < 10
- **Security issues**: 0 críticas
- **Style violations**: < 5

### MCP Commands:
- **Commands tested**: 50/50
- **Success rate**: 95-100%
- **Response time**: < 2s average

## 🔄 Próximos Passos Após Teste

### Se SUCESSO (✅):
1. **Commit final**: O sistema está pronto para produção
2. **Configurar secrets**: Para notificações automáticas
3. **Branch protection**: Para enforcing de CI/CD
4. **Monitoramento**: Verificar execuções automáticas

### Se FALHA (❌):
1. **Analisar logs**: Identificar problemas específicos
2. **Corrigir issues**: Resolver problemas identificados
3. **Re-testar**: Executar novamente após correções
4. **Documentar**: Registrar issues para referência futura

## 📞 Suporte

### Durante a Execução:
- Monitore os logs em tempo real
- Verifique cada etapa do processo
- Documente qualquer erro encontrado

### Recursos Disponíveis:
- **GitHub Actions Logs**: Detalhes completos da execução
- **Workflow files**: Para entender a lógica implementada
- **Test scripts**: Para debug individual de componentes

---

**🎯 Objetivo**: Validar que o sistema CI/CD está funcionando corretamente e pronto para operação automática contínua!**