#Requires -RunAsAdministrator
# Instala o Equalizer APO (se faltar) e aplica o preset de CS2 que esta nesta pasta.
# Uso: botao direito no PowerShell > Executar como administrador, depois:
#   powershell -ExecutionPolicy Bypass -File "<pasta>\install.ps1"

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$apoDir = 'C:\Program Files\EqualizerAPO'
$configDir = Join-Path $apoDir 'config'
$preset = Join-Path $PSScriptRoot 'cs2-preset.txt'
$apoClsids = '{EACD2258-FCAC-4FF4-B36D-419E924A6D79}', '{EC1CC9CE-FAED-4822-828A-82A81A6F018F}'

# 1. Instalar o Equalizer APO, se ainda nao estiver instalado
if (-not (Test-Path (Join-Path $apoDir 'EqualizerAPO.dll'))) {
    Write-Host 'Buscando a versao mais recente do Equalizer APO no SourceForge...'
    $rss = [xml](Invoke-WebRequest -UseBasicParsing 'https://sourceforge.net/projects/equalizerapo/rss?path=/').Content
    $item = $rss.rss.channel.item | Where-Object { $_.link -match '/EqualizerAPO-x64-[\d.]+\.exe/download$' } | Select-Object -First 1
    if (-not $item) { throw 'Nao encontrei o instalador x64 no SourceForge.' }
    $expectedMd5 = $item.content.hash.'#text'.ToUpper()

    $tmp = Join-Path $env:TEMP 'eqapo-install'
    New-Item -ItemType Directory -Force $tmp | Out-Null
    $exe = Join-Path $tmp 'EqualizerAPO-x64.exe'
    Write-Host "Baixando $($item.link)"
    Invoke-WebRequest -UseBasicParsing -UserAgent 'Wget/1.21' $item.link -OutFile $exe

    # O instalador nao e assinado, entao conferimos o MD5 publicado pelo SourceForge
    $actualMd5 = (Get-FileHash $exe -Algorithm MD5).Hash
    if ($actualMd5 -ne $expectedMd5) { throw "MD5 nao confere (esperado $expectedMd5, obtido $actualMd5). Abortando." }
    Write-Host 'MD5 conferido.'

    Write-Host ''
    Write-Host '>>> Vai abrir a janela "Device Selector".' -ForegroundColor Yellow
    Write-Host '>>> Na aba de reproducao (Playback), marque SOMENTE o seu fone. NAO marque o microfone.' -ForegroundColor Yellow
    Write-Host '>>> Clique em OK. O script continua quando a janela fechar.' -ForegroundColor Yellow
    Start-Process $exe -ArgumentList '/S' -Wait
}

# 2. Backup do config original (so na primeira vez) e aplicacao do preset
$config = Join-Path $configDir 'config.txt'
$backup = Join-Path $configDir 'config_original.txt'
if ((Test-Path $config) -and -not (Test-Path $backup)) {
    Copy-Item $config $backup
    Write-Host "Backup do config original: $backup"
}
Copy-Item $preset $config -Force
Write-Host "Preset aplicado em $config"

# 3. Conferir em quais saidas o Equalizer APO esta ativo
$renderKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render'
$attached = foreach ($ep in Get-ChildItem $renderKey) {
    $fx = Join-Path $ep.PSPath 'FxProperties'
    if (-not (Test-Path $fx)) { continue }
    $values = (Get-ItemProperty $fx).PSObject.Properties | ForEach-Object { "$($_.Value)" }
    if ($values | Where-Object { $apoClsids -contains $_.ToUpper() }) {
        $props = Get-ItemProperty (Join-Path $ep.PSPath 'Properties')
        "$($props.'{a45c254e-df1c-4efd-8020-67d146a850e0},2') ($($props.'{b3f8fa53-0004-438e-9003-51a46e139bfc},6'))"
    }
}

Write-Host ''
if ($attached) {
    Write-Host 'Equalizer APO ativo em:' -ForegroundColor Green
    $attached | ForEach-Object { Write-Host "  - $_" }
} else {
    Write-Host 'O Equalizer APO nao esta ligado a nenhuma saida de audio.' -ForegroundColor Red
    Write-Host 'Abrindo o Device Selector: marque o seu fone e clique em OK.'
    Start-Process (Join-Path $apoDir 'DeviceSelector.exe')
}

Write-Host ''
Write-Host 'Proximos passos:'
Write-Host '  1. Reinicie o PC se o Equalizer APO acabou de ser instalado ou ligado a um novo fone.'
Write-Host '  2. No CS2: Configuracoes > Audio > Perfil de EQ = "Crisp".'
Write-Host '  3. Windows: botao direito no icone de som > Som espacial > Desativado.'
