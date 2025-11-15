# 🚀 **CONFIGURAÇÃO GODOT MCP - THE CORE DESCENT**

## 📋 **Status da Implementação**
✅ Add-on MCP integrado ao projeto Godot  
✅ Servidor WebSocket configurado na porta 9080  
✅ Plugin ativo e pronto para uso  

---

## 🎯 **ETAPA 1: Ativar Add-on no Godot**

### 1.1 Abrir o Projeto no Godot
```bash
cd /workspace/projeto_godot
# Abra o projeto no Godot Engine (versão 4.x)
```

### 1.2 Ativar Plugin MCP
1. Abra o **Editor Settings**
2. Vá em **Plugins** 
3. Localize **"Godot MCP"**
4. **Ative o plugin** (marque a checkbox)
5. Clique **"OK"**

### 1.3 Verificar Status
Após ativar, você verá:
- ✅ **MCP Server iniciado na porta 9080**
- ✅ **Add-on visível no painel lateral**
- ✅ **Logs no console**: "MCP WebSocket server started"

---

## 🤖 **ETAPA 2: Configurar Claude Desktop**

### 2.1 Localizar arquivo de configuração
**macOS:**
```bash
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```bash
%APPDATA%\Claude\claude_desktop_config.json
```

**Linux:**
```bash
~/.config/Claude/claude_desktop_config.json
```

### 2.2 Fazer backup da configuração atual
```bash
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json ~/Desktop/claude_config_backup.json
```

### 2.3 Adicionar configuração MCP
Copie e cole a configuração abaixo no arquivo:

```json
{
  "mcpServers": {
    "godot-mcp-core-descent": {
      "command": "node",
      "args": ["server/index.js"],
      "env": {
        "MCP_TRANSPORT": "stdio",
        "GODOT_PROJECT_PATH": "/workspace/projeto_godot",
        "GODOT_MCP_PORT": "9080"
      }
    }
  }
}
```

---

## 🔄 **ETAPA 3: Reiniciar e Testar**

### 3.1 Reiniciar Claude Desktop
1. **Feche** o Claude Desktop completamente
2. **Aguarde** 10 segundos
3. **Reabra** o Claude Desktop

### 3.2 Testar Integração
No Claude Desktop, teste o comando:

```
@mcp godot-mcp-core-descent list-project-scripts
```

---

## ✅ **COMANDOS FUNCIONAIS**

### **Análise de Scripts:**
```bash
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/Level11.gd
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/GameManager.gd
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/LevelManager.gd
```

### **Criação de Novos Níveis:**
```bash
@mcp godot-mcp-core-descent create-script Level12 "cybersecurity"
@mcp godot-mcp-core-descent create-script Level13 "product_management"
```

### **Otimização de Código:**
```bash
@mcp godot-mcp-core-descent analyze-script /workspace/projeto_godot/scripts/Level11.gd
@mcp godot-mcp-core-descent modify-script /workspace/projeto_godot/scripts/Level11.gd
```

---

## 🎮 **PRÓXIMOS PASSOS**

### **Teste 1: Análise do Level 11**
Execute no Claude Desktop:
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/Level11.gd
```
Prompt: "Analise este código e sugira melhorias na performance"

### **Teste 2: Criar Level 12**
```
@mcp godot-mcp-core-descent create-script Level12 "cybersecurity"
```
Prompt: "Crie um level sobre Cybersecurity com 6 puzzles progressivos, target_moves 58→68"

### **Teste 3: Otimização do GameManager**
```
@mcp godot-mcp-core-descent read-script /workspace/projeto_godot/scripts/GameManager.gd
```
Prompt: "Analise a arquitetura do GameManager e sugira melhorias na organização do código"

---

## 🔍 **Troubleshooting**

### **Problema: Servidor não conecta**
✅ Verificar se o add-on está ativo no Godot  
✅ Verificar se a porta 9080 não está bloqueada  
✅ Reiniciar Claude Desktop  

### **Problema: Comandos não funcionam**
✅ Verificar se o projeto está aberto no Godot  
✅ Verificar logs no console do Godot  
✅ Verificar configuração do arquivo JSON  

### **Problema: "Command not found"**
✅ Verificar se o caminho `/workspace/projeto_godot/` existe  
✅ Verificar se o arquivo `claude_desktop_config.json` está correto  
✅ Verificar se o usuário tem permissões de escrita  

---

## 📊 **Status da Integração**

**✅ Plugin Godot MCP**: Ativo  
**✅ Servidor WebSocket**: Porta 9080  
**✅ Configuração Claude**: Preparada  
**✅ Scripts disponíveis**: 11 níveis  
**✅ Pronto para uso**: ✅ SIM  

**Próximo passo**: Execute os testes de funcionalidade acima!

