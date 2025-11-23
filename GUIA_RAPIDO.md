# 🚀 Guia Rápido - The Core Descent

**5 minutos para começar!**

---

## ⚡ Início Rápido

### Opção 1: Executar no Godot

```bash
# 1. Clone o repositório (se ainda não fez)
git clone https://github.com/dronreef2/TheCoreDescent.git
cd TheCoreDescent

# 2. Abra no Godot 4.x
godot4 projeto_godot/project.godot

# 3. Pressione F5 para jogar!
```

### Opção 2: Validar o Projeto

```bash
# Validar todos os scripts GDScript e cenas
python3 scripts/validate_godot_project.py projeto_godot

# Executar testes de integração
python3 scripts/test_godot_mcp_integration.py
```

### Opção 3: Usar o Servidor MCP

```bash
# 1. Instalar dependências
cd godot-mcp-server
npm install

# 2. Build
npm run build

# 3. Executar
npm start
```

---

## 📁 Estrutura Essencial

```
TheCoreDescent/
├── projeto_godot/          # ⭐ Projeto principal do Godot
│   ├── project.godot      # Abra este arquivo no Godot
│   ├── scenes/Main.tscn   # Cena principal
│   └── scripts/           # 47 scripts do jogo
│
├── godot-mcp-server/      # Servidor MCP (opcional)
│   └── build/index.js     # Servidor compilado
│
└── scripts/               # Scripts de automação
    ├── validate_godot_project.py      # Validador
    └── test_godot_mcp_integration.py  # Testes
```

---

## 🎮 O Que é The Core Descent?

Um jogo educativo que ensina programação através de **14 níveis progressivos**:

1. **Level 1-3**: Fundamentos (Lógica, Ponteiros, OOP)
2. **Level 4-6**: Desenvolvimento (Concorrência, Web, Mobile)
3. **Level 7-9**: Tecnologias Avançadas (Data Science, QA, IoT)
4. **Level 10-14**: Especialização (Games, DevOps, Security, Product, Marketing)

---

## 🎯 Controles Básicos

- **F** - Usar habilidade
- **Arrastar blocos** - Programar
- **Shift+F** - Modo avançado
- **F5** - Executar jogo (no editor)

---

## ✅ Status do Projeto

- ✅ **47 scripts** validados
- ✅ **14 níveis** implementados
- ✅ **0 erros** críticos
- ✅ **100% funcional** no Godot 4.x

---

## 🛠️ Comandos Úteis

```bash
# Validar projeto
python3 scripts/validate_godot_project.py projeto_godot

# Corrigir formatação
python3 scripts/fix_tabs.py projeto_godot

# Testar integração MCP
python3 scripts/test_godot_mcp_integration.py

# Executar Godot em modo headless (teste)
godot4 --headless --path projeto_godot/
```

---

## 📖 Documentação Completa

- **[INTEGRACAO_GITHUB_GODOT_MCP_COMPLETA.md](./INTEGRACAO_GITHUB_GODOT_MCP_COMPLETA.md)** - Guia completo de integração
- **[GUIA_GODOT_MCP.md](./GUIA_GODOT_MCP.md)** - Guia do MCP
- **[README.md](./README.md)** - Visão geral do projeto

---

## 🆘 Problemas Comuns

### Godot não abre o projeto?
- Verifique se tem Godot 4.x instalado
- Certifique-se de abrir `projeto_godot/project.godot`

### Scripts com erros?
```bash
# Execute a validação
python3 scripts/validate_godot_project.py projeto_godot
```

### Servidor MCP não funciona?
```bash
cd godot-mcp-server
npm install
npm run build
```

---

## 🎉 Pronto!

Agora você pode:
- ✅ Jogar o The Core Descent
- ✅ Desenvolver novos níveis
- ✅ Usar o MCP para assistência por IA
- ✅ Validar mudanças automaticamente

**Divirta-se aprendendo programação! 🚀**

---

*Para mais detalhes, veja [INTEGRACAO_GITHUB_GODOT_MCP_COMPLETA.md](./INTEGRACAO_GITHUB_GODOT_MCP_COMPLETA.md)*
