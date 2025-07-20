# 💻 FLUSHDNS - Script de Renovação de IP e Limpeza de Cache DNS

![Plataforma](https://img.shields.io/badge/plataforma-Windows-blue.svg)
![Licença](https://img.shields.io/badge/licença-MIT-green.svg)
![Status](https://img.shields.io/badge/status-Estável-brightgreen)

Script em batch (.bat) para Windows com interface simples no terminal que automatiza o processo de renovação do endereço IP e limpeza do cache DNS. Ideal para resolver problemas comuns de rede de forma rápida e segura.

---

## 📌 Objetivo

O objetivo deste script é auxiliar usuários e técnicos a:

- Corrigir falhas de DNS
- Resolver conflitos ou lentidão na rede
- Renovar o endereço IP local
- Restaurar configurações básicas da pilha de rede do Windows

---

## ⚙️ Funcionalidades

Ao ser executado com privilégios de administrador, o script realiza:

- ✅ Limpeza do cache DNS (`ipconfig /flushdns`)
- ✅ Registro DNS do host (`ipconfig /registerdns`)
- ✅ Liberação do IP atual (`ipconfig /release`)
- ✅ Renovação do IP (`ipconfig /renew`)
- ✅ Reset do Winsock (`netsh winsock reset`)
- ✅ Reset da pilha de IP (`netsh int ip reset`)
- ✅ Atualização dos nomes NetBIOS (`nbtstat -rr`)

---

## 🧰 Requisitos

- ✅ Sistema: **Windows 10, 11 ou superior**
- ✅ Executar como **Administrador**

---

## ▶️ Como usar

1. Baixe ou clone este repositório.
2. Navegue até o arquivo `flushdns.bat`.
3. Clique com o botão direito sobre ele e selecione **“Executar como administrador”**.
4. Siga as instruções do menu exibido no terminal.

---

## 📂 Estrutura do Projeto

