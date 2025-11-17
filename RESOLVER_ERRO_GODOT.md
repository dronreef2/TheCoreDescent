# 🔧 Como Resolver o Erro "Scene not found"

## ❌ Problema

Ao abrir o projeto no Godot, aparece:
```
A cena selecionada 'res://scenes/Main.tscn' não existe.
```

---

## 🔍 Causa

Você está tentando abrir um projeto **DIFERENTE** do que foi refatorado:

- ❌ **Projeto errado**: `C:/Users/Miranda/OneDrive/Documentos/the-core-descent-main`
- ✅ **Projeto correto**: `/workspaces/TheCoreDescent/projeto_godot`

O projeto do OneDrive é provavelmente uma versão antiga da branch `main`, **não** a branch refatorada `feature/core-services-refactor`.

---

## ✅ Solução

### **Opção 1: Fechar e Importar Projeto Correto**

1. **Clique em "Cancelar"** na mensagem de erro
2. **Feche o Godot completamente**
3. **Abra novamente** o Godot Project Manager
4. **Clique em "Importar"**
5. **Navegue até o caminho CORRETO**:

**Se estiver usando WSL/Dev Container:**
```
\\wsl.localhost\Ubuntu\workspaces\TheCoreDescent\projeto_godot
```

**Se estiver em Linux/Mac:**
```
/workspaces/TheCoreDescent/projeto_godot
```

6. Selecione o arquivo `project.godot`
7. Clique em **"Importar e Editar"**

---

### **Opção 2: Criar a Cena Manualmente (se quiser testar o projeto antigo)**

Se você realmente quer abrir o projeto do OneDrive (branch `main` antiga):

1. Clique em **"Selecionar"**
2. Crie uma cena simples temporária
3. **MAS ATENÇÃO**: Este NÃO é o projeto refatorado!

**O projeto refatorado está em**: `feature/core-services-refactor`

---

## 📂 Como Encontrar o Projeto Correto

### **Windows com WSL:**

1. Abra o **Explorador de Arquivos**
2. Na barra de endereço, digite:
   ```
   \\wsl.localhost\Ubuntu\workspaces\TheCoreDescent\projeto_godot
   ```
3. Copie esse caminho
4. No Godot, cole ao importar

### **Verificar Conteúdo Correto:**

O projeto correto deve ter:
- ✅ `codigo/BaseLevel.gd` (novo arquivo)
- ✅ `codigo/services/GameStateService.gd` (novo)
- ✅ `codigo/Level1.gd` com `extends BaseLevel`

Se não tiver esses arquivos, **está no projeto errado!**

---

## 🎯 Resumo Rápido

**Problema**: Projeto errado aberto  
**Solução**: Importar de `/workspaces/TheCoreDescent/projeto_godot`

**Onde está a refatoração?**
- Branch: `feature/core-services-refactor`
- Pasta: `/workspaces/TheCoreDescent/projeto_godot`

**Onde NÃO está?**
- ❌ OneDrive/Documentos
- ❌ Downloads
- ❌ Qualquer pasta fora de `workspaces/TheCoreDescent`

---

## 📞 Verificação

Depois de importar o projeto correto, confirme:

1. Abra `codigo/Level1.gd` no FileSystem
2. Linha 1 deve ser: `extends BaseLevel`
3. Se for `extends Node2D`, está no projeto errado!

---

**Importou o projeto correto?** Ótimo! Agora siga: `INSTRUCOES_TESTE_GODOT.md`
