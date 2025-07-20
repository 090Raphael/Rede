# 🛰️ Verificador de Rota — Internet Brasil

Script em **PowerShell** com iniciador `.bat` para Windows que verifica se sua conexão com a internet está **roteando apenas por servidores no Brasil** ou passando por **outros países da América Latina** ou até **rota internacional indesejada**.

Ideal para usuários de operadoras ou provedores regionais que desejam diagnosticar rotas fora do Brasil, latência elevada ou saltos inesperados.

---

## 🎯 Funcionalidades

- 🔍 Verifica se o tráfego passa somente por servidores `.br`.
- 🌎 Detecta saltos por países da **América Latina** (ex: Argentina, Chile, etc.).
- 🌐 Identifica saltos **internacionais genéricos** fora da América Latina.
- 📍 Mostra o primeiro hop fora do Brasil.
- 📋 Saída colorida, organizada e fácil de entender.
- 🌀 Animação de carregamento enquanto `tracert` é executado.
- ✅ Interface pronta para uso: **clique duplo no `.bat` e pronto!**

---

## 📁 Estrutura dos Arquivos

verificador-rota/
├── verifica-rota.ps1 # Script principal em PowerShell
├── verifica-rota.bat # Iniciador amigável para executar o script

## 🧪 Exemplo de saída

Digite o IP ou domínio de destino (ENTER para usar 200.160.2.3 - NIC.br): **digite o ip ou qualer endereço web**

⏳ Executando tracert... /
✅ Rastreando rota finalizado.

⚠️  Sua conexão está passando por servidores na AMÉRICA LATINA (exceto Brasil)
🌐 Primeiro salto estrangeiro detectado:
  7    53 ms    58 ms    55 ms  hots-127.0.0.0 [190.30.52.1]

🧰 Requisitos
✅ Windows 10 ou superior

✅ PowerShell ativado (vem por padrão)

✅ tracert.exe disponível no sistema

🚫 Nenhuma instalação externa é necessária

🛡️ Segurança e privacidade
Este script não envia dados para a internet, nem coleta informações do usuário. Toda análise é feita localmente com base no tracert.

