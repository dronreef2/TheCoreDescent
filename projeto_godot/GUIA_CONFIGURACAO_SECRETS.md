# 🔐 Guia de Configuração dos GitHub Secrets

## 📋 Visão Geral

Para o sistema CI/CD funcionar completamente, é necessário configurar os GitHub Secrets no repositório. Estes secrets são usados para notificações por email e alertas no Slack.

## 🛠️ Como Configurar

### Passo 1: Acessar Configurações do Repositório

1. Acesse o repositório: https://github.com/dronreef2/TheCoreDescent
2. Clique em **Settings** (na aba principal)
3. No menu lateral, clique em **Secrets and variables**
4. Selecione **Actions**

### Passo 2: Configurar Secrets

Clique em **New repository secret** e adicione cada um dos secrets abaixo:

#### 1. EMAIL_SMTP_SERVER
```
Nome: EMAIL_SMTP_SERVER
Valor: smtp.gmail.com:587
```

**Configurações adicionais necessárias:**
- `EMAIL_SMTP_USERNAME`: Seu email do Gmail
- `EMAIL_SMTP_PASSWORD`: Senha de app do Gmail (não a senha normal)

**Para Gmail:**
1. Ative a verificação em duas etapas na sua conta Google
2. Vá em Segurança → Senhas de app
3. Gere uma senha de app específica para o GitHub
4. Use: `EMAIL_SMTP_USERNAME=seuemail@gmail.com`
5. Use: `EMAIL_SMTP_PASSWORD=senhadeappgerada`

#### 2. SLACK_WEBHOOK_URL
```
Nome: SLACK_WEBHOOK_URL
Valor: https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX
```

**Como obter o Webhook do Slack:**
1. Acesse seu workspace Slack
2. Vá em **Apps** → **Incoming Webhooks**
3. Clique em **Add New Webhook to Workspace**
4. Selecione o canal onde quer receber as notificações
5. Copie a URL gerada e cole no campo **Valor**

### Passo 3: Verificar GITHUB_TOKEN

O `GITHUB_TOKEN` é criado automaticamente pelo GitHub, mas verifique se está disponível:

1. Na seção **Secrets and variables** → **Actions**
2. Clique em **Configure** ao lado de `GITHUB_TOKEN`
3. Verifique se está marcado como **Enabled**

## 🔍 Secrets Completos Necessários

### Para Notificações por Email:
- `EMAIL_SMTP_SERVER`: smtp.gmail.com:587
- `EMAIL_SMTP_USERNAME`: seuemail@gmail.com
- `EMAIL_SMTP_PASSWORD`: senha-de-app-gerada
- `EMAIL_FROM_ADDRESS`: seuemail@gmail.com
- `EMAIL_TO_ADDRESS`: destinatario@exemplo.com

### Para Alertas no Slack:
- `SLACK_WEBHOOK_URL`: URL do webhook configurado

### Automático (já configurado):
- `GITHUB_TOKEN`: Criado automaticamente pelo GitHub

## 🧪 Testando a Configuração

### Execute um Workflow de Teste:

1. Vá para a aba **Actions** no repositório
2. Clique em **Testes Automáticos**
3. Clique em **Run workflow**
4. Aguarde a execução
5. Verifique os logs para confirmar que os secrets estão sendo usados

### Verificar Notificações:

1. **Email**: Verifique sua caixa de entrada durante a execução
2. **Slack**: Verifique o canal configurado para alertas

## 📊 Workflows que Usam os Secrets

### Testes Automáticos (testes-automáticos.yml)
- **Email**: Relatório de testes diários
- **Slack**: Notificação de falhas críticas

### Build & Deploy (build-deploy.yml)
- **Email**: Notificação de deploys bem-sucedidos/falhos
- **Slack**: Alertas de problemas no build

### Relatórios & Documentação (relatorios-documentacao.yml)
- **Email**: Envio automático de relatórios semanais/mensais
- **Slack**: Confirmação de geração de relatórios

### Monitoramento & Alertas (monitoramento-alertas.yml)
- **Email**: Alertas de saúde do sistema
- **Slack**: Notificações em tempo real de problemas

## 🚨 Configurações de Segurança

### Permissões Necessárias:

1. **GITHUB_TOKEN**: Já configurado automaticamente
   - Precisa de: `actions: read`, `contents: read`

2. **Email/SMTP**: Configuração manual
   - Use **senhas de app**, nunca senhas normais
   - Ative verificação em duas etapas

3. **Slack**: Webhook público
   - Não compartilhe a URL do webhook
   - Configure permissões apropriadas no canal

## 🔧 Troubleshooting

### Problema: Emails não são enviados
**Solução:**
1. Verifique se a senha de app está correta
2. Confirme que a verificação em duas etapas está ativa
3. Verifique os logs do workflow para erros específicos

### Problema: Slack não recebe alertas
**Solução:**
1. Confirme que a URL do webhook está correta
2. Verifique se o canal permite webhooks
3. Teste o webhook manualmente com curl

### Problema: GITHUB_TOKEN não funciona
**Solução:**
1. Vá em Settings → Actions → General
2. Em "Workflow permissions", selecione "Read and write"
3. Aguarde alguns minutos para a mudança ser aplicada

## ✅ Checklist de Configuração

- [ ] EMAIL_SMTP_SERVER configurado
- [ ] EMAIL_SMTP_USERNAME configurado  
- [ ] EMAIL_SMTP_PASSWORD configurado
- [ ] EMAIL_FROM_ADDRESS configurado
- [ ] EMAIL_TO_ADDRESS configurado
- [ ] SLACK_WEBHOOK_URL configurado
- [ ] GITHUB_TOKEN está habilitado
- [ ] Workflow de teste executado
- [ ] Notificações de email funcionando
- [ ] Alertas do Slack funcionando

## 📞 Suporte

Se encontrar problemas:

1. Verifique os logs dos workflows em **Actions**
2. Confirme se todos os secrets foram configurados corretamente
3. Teste cada secret individualmente
4. Verifique permissões do repositório

---

**Uma vez configurados, os secrets permitirão o funcionamento completo do sistema de automação CI/CD!** 🚀