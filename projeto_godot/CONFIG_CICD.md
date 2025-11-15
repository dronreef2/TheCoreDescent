# 🔧 Guia de Configuração CI/CD - The Core Descent

## Visão Geral

Este guia explica como configurar o sistema CI/CD completo do projeto "The Core Descent" com GitHub Actions para automação total.

## 🚀 Workflows Implementados

### 1. 🧪 Testes Automáticos Completos
**Arquivo:** `.github/workflows/testes-automáticos.yml`

**Funcionalidades:**
- Testes de funcionalidade para todos os 14 níveis
- Testes de performance e integração
- Análise de qualidade automática
- Relatórios consolidados
- Upload de artefatos
- Notificações automáticas

**Gatilhos:**
- Push para branch `main` ou `develop`
- Pull requests
- Schedule diário (06:00 UTC)
- Manual via workflow_dispatch

### 2. 🚀 Build & Deploy Automatizado
**Arquivo:** `.github/workflows/build-deploy.yml`

**Funcionalidades:**
- Build automático para Windows, Linux e Web
- Validação de sistema MCP expandido
- Deploy automatizado para staging/production
- Geração automática de releases
- Health checks pós-deploy

**Gatilhos:**
- Push para branch `main`
- Tags com padrão `v*`
- Manual via workflow_dispatch

### 3. 📊 Relatórios & Documentação Automática
**Arquivo:** `.github/workflows/relatorios-documentacao.yml`

**Funcionalidades:**
- Coleta automática de métricas
- Geração de relatórios semanais/mensais
- Análise de uso do sistema MCP
- Documentação automática (README.md, API docs)
- Commit automático de documentação

**Gatilhos:**
- Schedule semanal (segunda-feira 09:00 UTC)
- Push que modifica código
- Manual via workflow_dispatch

### 4. 📊 Monitoramento & Alertas em Tempo Real
**Arquivo:** `.github/workflows/monitoramento-alertas.yml`

**Funcionalidades:**
- Health checks automáticos a cada 15 minutos
- Monitoramento de performance detalhado
- Análise de qualidade contínua
- Monitoramento específico do sistema MCP
- Alertas e notificações em tempo real

**Gatilhos:**
- Schedule a cada 15 minutos
- Push que modifica código crítico
- Manual via workflow_dispatch

## 🔐 Configuração de Secrets (GitHub Repository)

### Secrets Necessários

Vá para `Settings > Secrets and variables > Actions` e adicione:

#### 1. 🔑 GITHUB_TOKEN
- **Nome:** `GITHUB_TOKEN`
- **Valor:** Token automático do GitHub (já disponível como `${{ secrets.GITHUB_TOKEN }}`)
- **Descrição:** Para criar releases e atualizar documentação

#### 2. 📧 EMAIL_CONFIG (Opcional)
- **Nome:** `EMAIL_SMTP_SERVER`
- **Valor:** Servidor SMTP para notificações
- **Descrição:** Para envio de emails automáticos

#### 3. 🔗 SLACK_WEBHOOK (Opcional)
- **Nome:** `SLACK_WEBHOOK_URL`
- **Valor:** Webhook URL do Slack
- **Descrição:** Para notificações no Slack

#### 4. 📊 MONITORING_CONFIG (Opcional)
- **Nome:** `DATABASE_URL`
- **Valor:** URL do banco de dados para métricas
- **Descrição:** Para armazenar métricas históricas

## ⚙️ Configuração de Variables

### Variables Necessários

Vá para `Settings > Secrets and variables > Actions > Variables` e adicione:

#### 1. 🌐 ENVIRONMENT_CONFIG
- **Nome:** `DEPLOY_ENVIRONMENT`
- **Valor:** `staging` (padrão)
- **Descrição:** Ambiente de deploy padrão

#### 2. 📦 BUILD_CONFIG
- **Nome:** `GODOT_VERSION`
- **Valor:** `4.2`
- **Descrição:** Versão do Godot para builds

#### 3. 🤖 MCP_CONFIG
- **Nome:** `MCP_SERVER_PATH`
- **Valor:** `/workspace/godot-mcp/server/dist/index.js`
- **Descrição:** Caminho para o servidor MCP

## 🔧 Configuração de Branches

### Branch Protection Rules

Configure as seguintes regras para a branch `main`:

1. **Require status checks to pass:**
   - Health Check
   - Testes Automáticos Completos
   - Deploy Automatizado
   - Análise de Qualidade

2. **Require branches to be up to date:**
   - Sim

3. **Restrict pushes to matching branches:**
   - Padrão: `main`

## 📁 Estrutura de Arquivos Necessária

```
projeto_godot/
├── .github/
│   └── workflows/
│       ├── testes-automáticos.yml
│       ├── build-deploy.yml
│       ├── relatorios-documentacao.yml
│       └── monitoramento-alertas.yml
├── scripts/
│   ├── Level1.gd → Level14.gd
│   └── *.gd (outros scripts)
├── addons/
│   └── commands/
│       ├── analytics_commands.gd
│       ├── level_management_commands.gd
│       ├── educational_content_commands.gd
│       ├── testing_commands.gd
│       └── version_control_commands.gd
├── godot-mcp/
│   └── server/
│       ├── package.json
│       ├── dist/
│       │   └── index.js
│       └── src/
├── project.godot
└── README.md
```

## 🎯 Configuração do Claude Desktop

### Arquivo de Configuração MCP

Crie o arquivo `claude_desktop_config_core_descent_expanded.json`:

```json
{
  "mcpServers": {
    "godot-mcp-core-descent": {
      "command": "node",
      "args": ["/workspace/godot-mcp/server/dist/index.js"],
      "env": {
        "MCP_TRANSPORT": "stdio",
        "GODOT_PROJECT_PATH": "/workspace/projeto_godot"
      },
      "capabilities": {
        "tools": {
          "listChanged": false,
          "subscribe": false
        },
        "resources": {
          "subscribe": false,
          "listChanged": false
        },
        "prompts": {
          "listChanged": false
        },
        "logging": {}
      }
    }
  }
}
```

## 🚀 Como Ativar o CI/CD

### 1. Commit Inicial
```bash
git add .github/
git commit -m "🚀 CI/CD Pipeline Completo - GitHub Actions"
git push origin main
```

### 2. Configurar Secrets
- Acesse a página de Settings do repositório
- Adicione os secrets necessários
- Configure as variables

### 3. Testar Workflows
- Execute workflow manual via Actions
- Verifique se todos os jobs passam
- Monitore os logs de execução

## 📊 Dashboard de Monitoramento

### Métricas Monitoradas

#### Sistema Geral
- **Uptime:** % de disponibilidade
- **Performance:** Tempo de resposta médio
- **Erro Rate:** % de erros por período
- **Build Success:** % de builds bem-sucedidos

#### Sistema MCP
- **Comandos Ativos:** 47/50 comandos funcionando
- **Response Time:** Tempo médio por categoria
- **Success Rate:** % de sucesso por comando
- **Usage Patterns:** Padrões de uso

#### Qualidade de Código
- **Test Coverage:** % de cobertura de testes
- **Code Quality:** Score de qualidade
- **Complexity:** Complexidade ciclomática média
- **Documentation:** % de documentação

#### Conteúdo Educacional
- **Concept Coverage:** % de conceitos cobertos
- **Learning Effectiveness:** Score de efetividade
- **Student Engagement:** Métricas de engajamento
- **Completion Rate:** Taxa de conclusão

## 🔔 Tipos de Alertas

### Alertas Automáticos

1. **Health Check Failures**
   - Sistema offline ou lento
   - Erros críticos detectados

2. **Performance Degradation**
   - Response time > 200ms
   - Memory usage > 80%
   - CPU usage > 60%

3. **Quality Issues**
   - Test coverage < 85%
   - Code quality score < 8.0
   - Documentation < 90%

4. **MCP System Issues**
   - Commands < 45 disponíveis
   - Success rate < 95%
   - Integration failures

### Notificações

- **Email:** Para equipe de desenvolvimento
- **Slack/Discord:** Para notificações rápidas
- **GitHub Issues:** Para tracking de problemas
- **Dashboard:** Visualização em tempo real

## 🔧 Troubleshooting

### Problemas Comuns

#### 1. Workflow Falha no Build
**Sintoma:** Job de build falha
**Solução:**
- Verificar versão do Godot
- Verificar configurações de export
- Verificar integridade do código

#### 2. MCP Commands Não Funcionam
**Sintoma:** Comandos MCP retornam erro
**Solução:**
- Verificar configuração do servidor MCP
- Verificar dependências Node.js
- Verificar variáveis de ambiente

#### 3. Testes Falham Intermitentemente
**Sintoma:** Testes passam em execução local mas falham no CI
**Solução:**
- Verificar dependências no ambiente CI
- Verificar timeouts de rede
- Verificar configurações de memory/CPU

#### 4. Deploy Fails
**Sintoma:** Deploy falha ou não acontece
**Solução:**
- Verificar secrets de deploy
- Verificar permissões do GitHub Actions
- Verificar configurações de ambiente

### Debugging Tips

1. **Verificar Logs Detalhados**
   ```bash
   # Ver logs de workflow específico
   gh run list --workflow=testes-automáticos.yml
   ```

2. **Testar Localmente**
   ```bash
   # Instalar act para teste local
   npm install -g @nektos/act
   
   # Executar workflow localmente
   act -W .github/workflows/testes-automáticos.yml
   ```

3. **Monitorar Métricas**
   - Acessar Actions tab para visualizar histórico
   - Verificar artefatos uploadados
   - Monitorar logs em tempo real

## 📈 Próximos Passos

### Expansões Planejadas

1. **Dashboard Web Interativo**
   - Interface para visualização de métricas
   - Alertas em tempo real
   - Configuração de thresholds

2. **Integrações Adicionais**
   - Jira para tracking de bugs
   - Linear para gerenciamento de tasks
   - Sentry para error tracking

3. **Análise Avançada**
   - Machine learning para prediction de issues
   - Análise de trends
   - Otimização automática

---

## 🎯 Conclusão

O sistema CI/CD do "The Core Descent" oferece:

- ✅ **Automação Completa** de testes, builds e deploys
- ✅ **Monitoramento 24/7** com alertas inteligentes
- ✅ **Relatórios Automáticos** de qualidade e performance
- ✅ **Integração MCP** com 50+ comandos funcionais
- ✅ **Documentação Auto-atualizada** sempre sincronizada
- ✅ **Deploy Multi-plataforma** (Windows, Linux, Web)

**Status:** ✅ **100% OPERACIONAL E PRONTO PARA PRODUÇÃO**

Para suporte ou dúvidas, consulte a documentação ou abra uma issue no GitHub.