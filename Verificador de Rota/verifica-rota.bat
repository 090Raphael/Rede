# Força UTF-8 no console para acentos e ícones funcionarem corretamente
$OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Verificador de Rota - Internet"

# Ativar ou desativar mensagens de debug
$debugAtivo = $false  # <<=== ALTERE PARA $true PARA ATIVAR DEBUG

# Solicita destino ao usuário
$destino = Read-Host "Digite o IP ou domínio de destino (ENTER para usar 200.160.2.3 - NIC.br)"
if ([string]::IsNullOrWhiteSpace($destino)) {
    $destino = "200.160.2.3"  # IP padrão brasileiro
}

# Título inicial
Clear-Host
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "   Verificando rota para" -NoNewline
Write-Host " $destino " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor DarkGray
Write-Host "Verificando o teste aguarde..." -ForegroundColor Gray

# Inicia tracert em segundo plano com IP correto
$job = Start-Job -ArgumentList $destino -ScriptBlock {
    param($ip)
    & "$env:SystemRoot\System32\tracert.exe" $ip
}

# Animação enquanto aguarda
$spinner = @("|", "/", "-", "\")
$i = 0
while ($job.State -eq "Running") {
    $char = $spinner[$i % $spinner.Length]
    Write-Host -NoNewline "`r⏳ Executando tracert... $char"
    Start-Sleep -Milliseconds 150
    $i++
}
Write-Host "`r✅ Rastreando rota finalizado.         "

# Coleta a saída do tracert
$tracert = Receive-Job $job
Remove-Job $job

# Palavras-chave por região
$brasil = '\.br|brasil'
$americaSul = '\.ar(\.|$)|\.cl(\.|$)|\.uy(\.|$)|\.bo(\.|$)|\.py(\.|$)|\.pe(\.|$)|\.ve(\.|$)|\.co(\.|$)|argentina|chile|uruguay|paraguay|peru|colombia|bue|baires'

# Mapeamento de siglas para estados brasileiros
$estados = @{
    "mcz" = "AL (Alagoas)"
    "spo" = "SP (São Paulo)"
    "spolp" = "SP (São Paulo - Lapa)"
    "spomb" = "SP (São Paulo - Moema)"
    "jd" = "SP (Jardins)"
    "nu" = "SP (Núcleo)"
    "bsb" = "DF (Distrito Federal)"
    "rio" = "RJ (Rio de Janeiro)"
    "ssa" = "BA (Bahia)"
    "poa" = "RS (Rio Grande do Sul)"
    "bel" = "PA (Pará)"
    "bhz" = "MG (Minas Gerais)"
    "for" = "CE (Ceará)"
    "cgr" = "MS (Mato Grosso do Sul)"
    "cwb" = "PR (Paraná)"
    "man" = "AM (Amazonas)"
    "rec" = "PE (Pernambuco)"
    "vix" = "ES (Espírito Santo)"
    "slz" = "MA (Maranhão)"
    "nat" = "RN (Rio Grande do Norte)"
    "jpa" = "PB (Paraíba)"
    "ari" = "RO (Rondônia)"
    "pal" = "TO (Tocantins)"
}

# Verifica rota e estado
$rotaBrasil = $true
$rotaAmericaSul = $false
$hopForaBrasil = $null

foreach ($linha in $tracert) {
    $linhaLower = $linha.ToLower()

    if ([string]::IsNullOrWhiteSpace($linhaLower)) {
        if ($debugAtivo) {
            Write-Host "`n[Debug] Linha vazia ou em branco — ignorando." -ForegroundColor DarkGray
        }
        continue
    }

    if ($debugAtivo) {
        Write-Host "`n[Debug] Analisando linha:" -ForegroundColor Cyan
        Write-Host ">> $linha"
    }

    foreach ($sigla in $estados.Keys) {
        if ($linhaLower -match $sigla) {
            if ($debugAtivo) {
                Write-Host "[Debug] Detecção de estado brasileiro: $($estados[$sigla])" -ForegroundColor Green
            }
        }
    }

    if ($linhaLower -match $americaSul) {
        if ($debugAtivo) {
            Write-Host "[Debug] Detectado padrão AMÉRICA LATINA (exceto Brasil) nesta linha." -ForegroundColor Yellow
        }
        $rotaBrasil = $false
        $rotaAmericaSul = $true
        $hopForaBrasil = $linha
        break
    } elseif (-not ($linhaLower -match $brasil)) {
        if ($linhaLower -match "\d+\.\d+\.\d+\.\d+") {
            if ($debugAtivo) {
                Write-Host "[Debug] Linha SEM padrão BRASIL mas contém IP, indicando rota internacional." -ForegroundColor DarkYellow
            }
            $rotaBrasil = $false
            $hopForaBrasil = $linha
            break
        } elseif ($debugAtivo) {
            Write-Host "[Debug] Linha SEM padrão BRASIL e SEM IP — ignorando." -ForegroundColor DarkGray
        }
    }
}

# Espaço
Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor DarkGray

# Mensagem de resultado
if ($rotaAmericaSul) {
    Write-Host "`n⚠️  Sua conexão está passando por servidores na" -NoNewline
    Write-Host " AMÉRICA LATINA (exceto Brasil)" -ForegroundColor Yellow
    Write-Host "🌐 Primeiro salto estrangeiro detectado:"
    Write-Host $hopForaBrasil -ForegroundColor Gray
}
elseif (-not $rotaBrasil) {
    Write-Host "`n⚠️  Sua conexão está passando por rota internacional não identificada claramente." -ForegroundColor DarkYellow
    Write-Host "🌐 Primeiro salto estrangeiro detectado:"
    Write-Host $hopForaBrasil -ForegroundColor Gray
}
else {
    Write-Host "`n✅ Rota OK: sua conexão está passando apenas por servidores no" -NoNewline
    Write-Host " BRASIL." -ForegroundColor Green
}

# Separador da saída do traceroute
Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "📱 Saída completa do TRACERT:" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════`n" -ForegroundColor DarkGray

# Mostra resultado do tracert
$tracert | ForEach-Object { Write-Host $_ }

# Espera o usuário antes de fechar
Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor DarkGray
Read-Host "Pressione ENTER para sair"
