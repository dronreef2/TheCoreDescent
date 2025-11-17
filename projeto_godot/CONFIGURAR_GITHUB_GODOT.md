# 🔗 Como Conectar Godot ao GitHub

## 📋 Pré-requisitos

- ✅ Git instalado no sistema
- ✅ Conta GitHub configurada
- ✅ Repositório já existe: `https://github.com/dronreef2/TheCoreDescent`

---

## 🎯 Método 1: Usar Git Integrado do Godot

### **Passo 1: Ativar Plugin Git**

1. No Godot, vá em: **Editor → Configurações do Editor**
2. Na aba lateral, clique em: **Version Control → Git**
3. Marque: **☑ Enable Git Support**
4. Configure:
   - **Git executable path**: `git` (ou caminho completo se necessário)
   - **Username**: `dronreef2`
   - **Email**: seu email do GitHub

### **Passo 2: Abrir Painel Git**

1. Menu superior: **Version Control → Version Control**
2. Aparecerá o painel **Commit** na parte inferior

### **Passo 3: Fazer Commits pelo Godot**

1. Modifique arquivos no projeto
2. No painel **Commit**, verá arquivos modificados
3. Selecione arquivos para commit
4. Digite mensagem
5. Clique em **Commit**

### **Passo 4: Push para GitHub**

⚠️ **IMPORTANTE**: O Godot **não** faz push automaticamente!

**Opção A - Via VS Code (RECOMENDADO):**
```bash
# Volte para o VS Code terminal e rode:
git push origin feature/core-services-refactor
```

**Opção B - Via Terminal:**
1. Abra terminal na pasta do projeto
2. Execute:
```bash
git push origin feature/core-services-refactor
```

---

## �� Método 2: Clonar do Zero (Começar Limpo)

Se quiser um projeto totalmente sincronizado:

### **No Windows (PowerShell ou CMD):**

```powershell
# 1. Navegue para onde quer clonar
cd C:\Users\Miranda\Documents

# 2. Clone o repositório
git clone https://github.com/dronreef2/TheCoreDescent.git

# 3. Entre na pasta
cd TheCoreDescent

# 4. Mude para branch refatorada
git checkout feature/core-services-refactor

# 5. Abra no Godot
# Importe: C:\Users\Miranda\Documents\TheCoreDescent\projeto_godot\project.godot
```

### **No WSL/Linux:**

```bash
# 1. Navegue para workspace
cd ~/workspace

# 2. Clone
git clone https://github.com/dronreef2/TheCoreDescent.git

# 3. Entre na pasta
cd TheCoreDescent

# 4. Mude para branch
git checkout feature/core-services-refactor

# 5. Abra no Godot
# Importe: ~/workspace/TheCoreDescent/projeto_godot/project.godot
```

---

## 🎯 Método 3: GitHub Desktop (Mais Fácil)

### **Instalação:**

1. Baixe: https://desktop.github.com/
2. Instale
3. Faça login com sua conta GitHub

### **Usar com Projeto:**

1. **File → Clone Repository**
2. Selecione: `dronreef2/TheCoreDescent`
3. Escolha pasta local
4. Clique em **Clone**
5. Na lista de branches, selecione: `feature/core-services-refactor`
6. Agora pode fazer commits visualmente!

**Workflow:**
1. Edite no Godot
2. Vá ao GitHub Desktop
3. Veja mudanças automaticamente
4. Digite mensagem de commit
5. Clique em **Commit to feature/core-services-refactor**
6. Clique em **Push origin** (botão superior)

---

## ⚙️ Configuração Atual do Projeto

Seu projeto **JÁ ESTÁ** configurado com Git:

```bash
# Repositório remoto
origin: https://github.com/dronreef2/TheCoreDescent

# Branch atual
feature/core-services-refactor

# Status
✅ 14 commits à frente da main
✅ Todos os arquivos commitados
✅ Push feito com sucesso
```

---

## 🔄 Workflow Recomendado

### **Para Desenvolvimento:**

1. **Edite no Godot**: Faça mudanças no código
2. **Salve tudo**: Ctrl+S ou Ctrl+Shift+S
3. **Volte para VS Code/Terminal**:
   ```bash
   git status                # Ver mudanças
   git add .                 # Adicionar tudo
   git commit -m "feat: ..." # Commit
   git push origin feature/core-services-refactor
   ```

### **Alternativa com GitHub Desktop:**

1. Edite no Godot
2. Salve
3. Vá ao GitHub Desktop
4. Commit
5. Push

---

## 📍 Onde Está Seu Projeto Agora

**No GitHub (remoto):**
- URL: https://github.com/dronreef2/TheCoreDescent
- Branch: `feature/core-services-refactor`
- Commits: 14 à frente da main
- Status: ✅ Atualizado (push feito há pouco)

**No Dev Container (local):**
- Pasta: `/workspaces/TheCoreDescent/projeto_godot`
- Branch: `feature/core-services-refactor`
- Status: ✅ Limpo (nada para commitar)

**No OneDrive (DESATUALIZADO):**
- Pasta: `C:/Users/Miranda/OneDrive/Documentos/the-core-descent-main`
- Branch: Provavelmente `main` antiga
- Status: ❌ **NÃO USE ESTA PASTA!**

---

## ✅ Checklist de Verificação

Depois de abrir o projeto no Godot, confirme:

- [ ] Painel Git aparece em **Version Control** menu
- [ ] Branch mostrada é `feature/core-services-refactor`
- [ ] Arquivo `codigo/BaseLevel.gd` existe no FileSystem
- [ ] `codigo/Level1.gd` começa com `extends BaseLevel`

---

## 🆘 Problemas Comuns

### **Godot não mostra Git:**
- Vá em: Editor → Configurações → Version Control → Git
- Marque: **Enable Git Support**

### **Git não encontrado:**
```bash
# No terminal, verifique:
which git
# Copie o caminho retornado e cole em "Git executable path"
```

### **Push não funciona no Godot:**
- Normal! Godot faz **commit** mas não **push**
- Use terminal ou GitHub Desktop para push

### **Quer sincronizar com main:**
```bash
git checkout main
git pull origin main
git checkout feature/core-services-refactor
git merge main
```

---

## 🎯 Próximos Passos

1. **Abra projeto correto no Godot** (veja `RESOLVER_ERRO_GODOT.md`)
2. **Teste as mudanças** (veja `INSTRUCOES_TESTE_GODOT.md`)
3. **Faça commits** conforme edita
4. **Crie Pull Request** quando estiver pronto:
   - https://github.com/dronreef2/TheCoreDescent/pull/new/feature/core-services-refactor

---

**Resumo:** Godot faz **commits** localmente. Para sincronizar com GitHub, use **terminal**, **VS Code**, ou **GitHub Desktop** para fazer **push**.
