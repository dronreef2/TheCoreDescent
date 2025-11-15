#!/bin/bash

# 🚀 Script de Setup Automático CI/CD - The Core Descent
# Este script configura automaticamente o sistema CI/CD completo

set -e  # Exit on any error

echo "🎯 === SETUP CI/CD - THE CORE DESCENT ==="
echo "Iniciando configuração automática do sistema CI/CD..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logs coloridos
log_info() {
    echo -e "${BLUE}ℹ️  INFO:${NC} $1"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
}

log_error() {
    echo -e "${RED}❌ ERROR:${NC} $1"
}

# Verificar se estamos no diretório correto
check_directory() {
    if [[ ! -f "project.godot" ]] || [[ ! -d ".github" ]]; then
        log_error "Execute este script no diretório raiz do projeto Godot"
        exit 1
    fi
    log_success "Diretório do projeto verificado"
}

# Verificar dependências
check_dependencies() {
    log_info "Verificando dependências..."
    
    if ! command -v git &> /dev/null; then
        log_error "Git não está instalado"
        exit 1
    fi
    
    if ! command -v node &> /dev/null; then
        log_warning "Node.js não encontrado - necessário para MCP server"
    else
        log_success "Node.js encontrado: $(node --version)"
    fi
    
    log_success "Dependências verificadas"
}

# Configurar estrutura de diretórios
setup_directories() {
    log_info "Configurando estrutura de diretórios..."
    
    # Verificar se .github/workflows existe
    if [[ ! -d ".github/workflows" ]]; then
        mkdir -p .github/workflows
        log_success "Diretório .github/workflows criado"
    else
        log_info "Diretório .github/workflows já existe"
    fi
    
    # Verificar se addons/commands existe
    if [[ ! -d "addons/commands" ]]; then
        log_warning "Diretório addons/commands não encontrado - sistema MCP não instalado"
    else
        log_success "Sistema MCP encontrado: $(find addons/commands -name "*.gd" | wc -l) comandos"
    fi
    
    # Verificar se scripts/ existe e tem levels
    if [[ -d "scripts" ]] && [[ $(find scripts -name "Level*.gd" 2>/dev/null | wc -l) -gt 0 ]]; then
        log_success "Níveis encontrados: $(find scripts -name "Level*.gd" | wc -l)"
    else
        log_warning "Níveis não encontrados - projeto pode não estar completo"
    fi
}

# Verificar arquivos de workflow
check_workflow_files() {
    log_info "Verificando arquivos de workflow..."
    
    local workflows=(
        "testes-automáticos.yml"
        "build-deploy.yml"
        "relatorios-documentacao.yml"
        "monitoramento-alertas.yml"
    )
    
    local missing_workflows=()
    
    for workflow in "${workflows[@]}"; do
        if [[ -f ".github/workflows/$workflow" ]]; then
            log_success "Workflow encontrado: $workflow"
        else
            missing_workflows+=("$workflow")
            log_warning "Workflow ausente: $workflow"
        fi
    done
    
    if [[ ${#missing_workflows[@]} -gt 0 ]]; then
        log_error "Workflows ausentes: ${missing_workflows[*]}"
        return 1
    fi
    
    log_success "Todos os workflows estão presentes"
}

# Gerar arquivo de configuração de exemplo
generate_config_files() {
    log_info "Gerando arquivos de configuração..."
    
    # Gerar example secrets
    cat > GITHUB_SECRETS_EXAMPLE.txt << 'EOF'
# 🔐 GitHub Secrets Configuration Example
# Adicione estes secrets no repositório: Settings > Secrets and variables > Actions

# GITHUB_TOKEN (já disponível automaticamente)
# Nome: GITHUB_TOKEN
# Valor: (automatico do GitHub)

# EMAIL SMTP (opcional)
# Nome: EMAIL_SMTP_SERVER
# Valor: smtp.gmail.com:587

# SLACK WEBHOOK (opcional)
# Nome: SLACK_WEBHOOK_URL
# Valor: https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK

# DATABASE URL (opcional)
# Nome: DATABASE_URL
# Valor: postgresql://user:password@localhost:5432/dbname
EOF
    log_success "Arquivo GITHUB_SECRETS_EXAMPLE.txt gerado"
    
    # Gerar example variables
    cat > GITHUB_VARIABLES_EXAMPLE.txt << 'EOF'
# ⚙️ GitHub Variables Configuration Example
# Adicione estas variáveis no repositório: Settings > Secrets and variables > Actions > Variables

# DEPLOY_ENVIRONMENT
# Nome: DEPLOY_ENVIRONMENT
# Valor: staging

# GODOT_VERSION
# Nome: GODOT_VERSION
# Valor: 4.2

# MCP_SERVER_PATH
# Nome: MCP_SERVER_PATH
# Valor: /workspace/godot-mcp/server/dist/index.js
EOF
    log_success "Arquivo GITHUB_VARIABLES_EXAMPLE.txt gerado"
    
    # Gerar configurações de branch protection
    cat > BRANCH_PROTECTION_SETUP.md << 'EOF'
# 🌿 Branch Protection Rules Setup

## Instruções para configurar proteção da branch main:

1. Vá para Settings > Branches no repositório
2. Clique em "Add rule"
3. Configure:
   - Branch name pattern: `main`
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date before merging
   - ✅ Restrict pushes to matching branches

## Status Checks necessários:
- Health Check
- Testes Automáticos Completos
- Deploy Automatizado
- Análise de Qualidade

## Additional settings:
- ✅ Dismiss stale reviews
- ✅ Require review from code owners
EOF
    log_success "Arquivo BRANCH_PROTECTION_SETUP.md gerado"
}

# Gerar script de teste local
generate_test_script() {
    log_info "Gerando script de teste local..."
    
    cat > test_local_ci.sh << 'EOF'
#!/bin/bash
# 🧪 Script de Teste Local CI/CD

echo "🧪 Testando configuração CI/CD localmente..."

# Verificar se act está instalado
if ! command -v act &> /dev/null; then
    echo "ℹ️ Instalando act para teste local..."
    npm install -g @nektos/act
fi

# Testar workflow de testes
echo "🧪 Testando workflow de testes..."
act -W .github/workflows/testes-automáticos.yml

echo "✅ Teste local concluído!"
EOF
    
    chmod +x test_local_ci.sh
    log_success "Script test_local_ci.sh gerado"
}

# Validar configuração do projeto
validate_project() {
    log_info "Validando configuração do projeto..."
    
    local validation_errors=0
    
    # Verificar project.godot
    if [[ ! -f "project.godot" ]]; then
        log_error "project.godot não encontrado"
        validation_errors=$((validation_errors + 1))
    fi
    
    # Verificar scripts dos levels
    local level_count=$(find scripts -name "Level*.gd" 2>/dev/null | wc -l)
    if [[ $level_count -eq 0 ]]; then
        log_warning "Nenhum level encontrado (scripts/Level*.gd)"
    elif [[ $level_count -lt 14 ]]; then
        log_warning "Apenas $level_count/14 levels encontrados"
    else
        log_success "$level_count/14 levels encontrados"
    fi
    
    # Verificar sistema MCP
    local mcp_commands=$(find addons/commands -name "*.gd" 2>/dev/null | wc -l)
    if [[ $mcp_commands -eq 0 ]]; then
        log_warning "Sistema MCP não encontrado"
    elif [[ $mcp_commands -lt 50 ]]; then
        log_warning "Apenas $mcp_commands/50+ comandos MCP encontrados"
    else
        log_success "Sistema MCP com $mcp_commands comandos"
    fi
    
    # Verificar node_modules se existir
    if [[ -d "godot-mcp/server" ]]; then
        if [[ ! -d "godot-mcp/server/node_modules" ]]; then
            log_warning "Dependências MCP não instaladas - execute 'cd godot-mcp/server && npm install'"
        else
            log_success "Dependências MCP instaladas"
        fi
        
        if [[ ! -f "godot-mcp/server/dist/index.js" ]]; then
            log_warning "MCP server não buildado - execute 'cd godot-mcp/server && npm run build'"
        else
            log_success "MCP server buildado"
        fi
    fi
    
    if [[ $validation_errors -gt 0 ]]; then
        log_error "Validação falhou com $validation_errors erros"
        return 1
    else
        log_success "Validação do projeto concluída com sucesso"
    fi
}

# Gerar relatório de setup
generate_setup_report() {
    log_info "Gerando relatório de setup..."
    
    local report_file="CI_CD_SETUP_REPORT.md"
    
    cat > "$report_file" << EOF
# 🚀 Relatório de Setup CI/CD - The Core Descent

**Data:** $(date '+%Y-%m-%d %H:%M:%S')
**Projeto:** The Core Descent

## 📊 Status da Configuração

### ✅ Componentes Verificados

EOF
    
    # Adicionar informações sobre components
    local level_count=$(find scripts -name "Level*.gd" 2>/dev/null | wc -l)
    local mcp_commands=$(find addons/commands -name "*.gd" 2>/dev/null | wc -l)
    local workflow_count=$(find .github/workflows -name "*.yml" 2>/dev/null | wc -l)
    
    cat >> "$report_file" << EOF
- **Níveis Implementados:** $level_count/14
- **Comandos MCP:** $mcp_commands/50+
- **Workflows CI/CD:** $workflow_count/4
- **Scripts do Projeto:** $(find scripts -name "*.gd" 2>/dev/null | wc -l)
- **Arquivos de Documentação:** $(find . -name "*.md" 2>/dev/null | wc -l)

## 📝 Próximos Passos

### 1. Configurar GitHub Secrets
\`\`\`bash
# Adicione no GitHub > Settings > Secrets and variables > Actions:
- GITHUB_TOKEN (automático)
- EMAIL_SMTP_SERVER (opcional)
- SLACK_WEBHOOK_URL (opcional)
- DATABASE_URL (opcional)
\`\`\`

### 2. Configurar GitHub Variables
\`\`\`bash
# Adicione no GitHub > Settings > Secrets and variables > Actions > Variables:
- DEPLOY_ENVIRONMENT: staging
- GODOT_VERSION: 4.2
- MCP_SERVER_PATH: /workspace/godot-mcp/server/dist/index.js
\`\`\`

### 3. Configurar Branch Protection
- Habilitar protection na branch 'main'
- Requerir status checks para merge
- Configurar reviewers obrigatórios

### 4. Testar CI/CD
\`\`\`bash
# Teste local (se act estiver instalado)
./test_local_ci.sh

# Push para testar no GitHub
git add .
git commit -m "🚀 Configuração CI/CD completa"
git push origin main
\`\`\`

## 🔧 Comandos Úteis

\`\`\`bash
# Verificar status dos workflows
gh run list --workflow=testes-automáticos.yml

# Executar workflow manualmente
gh workflow run testes-automáticos.yml

# Monitorar logs
gh run view <run-id> --log
\`\`\`

## 📈 Monitoring

Após o setup, monitore:
- Actions tab no GitHub para ver workflows executando
- Artefatos gerados automaticamente
- Relatórios de qualidade e performance
- Alertas de problemas

---

**Status:** $([ $workflow_count -eq 4 ] && echo "✅ COMPLETO" || echo "⚠️ PARCIAL")
**CI/CD:** $([ $workflow_count -eq 4 ] && echo "PRONTO" || echo "REQUER ATENÇÃO")
EOF
    
    log_success "Relatório gerado: $report_file"
}

# Função principal
main() {
    echo ""
    echo "🚀 Iniciando configuração automática do CI/CD..."
    echo ""
    
    # Executar todas as verificações
    check_directory
    check_dependencies
    setup_directories
    check_workflow_files || {
        log_error "Configure os workflows primeiro"
        exit 1
    }
    
    generate_config_files
    generate_test_script
    validate_project || {
        log_warning "Algumas validações falharam, mas CI/CD pode funcionar"
    }
    
    generate_setup_report
    
    echo ""
    log_success "=== SETUP CI/CD CONCLUÍDO ==="
    echo ""
    echo "📋 Próximos passos:"
    echo "1. Configure GitHub Secrets (ver GITHUB_SECRETS_EXAMPLE.txt)"
    echo "2. Configure GitHub Variables (ver GITHUB_VARIABLES_EXAMPLE.txt)"
    echo "3. Configure Branch Protection (ver BRANCH_PROTECTION_SETUP.md)"
    echo "4. Teste localmente com: ./test_local_ci.sh"
    echo "5. Commit e push para ativar CI/CD automático"
    echo ""
    echo "📊 Para mais detalhes, consulte:"
    echo "   • CI_CD_SETUP_REPORT.md"
    echo "   • CONFIG_CICD.md"
    echo "   • GitHub > Actions (para monitorar workflows)"
    echo ""
    log_success "Sistema CI/CD pronto para uso!"
}

# Executar função principal
main "$@"