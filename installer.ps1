$ErrorActionPreference = 'Stop'

function Clear-Screen { Clear-Host }

function Show-Art {
    Write-Host ""
    $art = "         ███             ███             ███             ███             ███          ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░          ██░            ███░            ███░            ███░            ███░            ░            ███░            ███░            ███░            ███░            ██            ░░░             ░░░             ░░░             ░░░             ░░░     █░▒▓███████▓▒░ ░▒▓███████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓███████▓▒░▒▓████████▓▒░          ███░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░        ███░ ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░       ██░   ░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░       ░     ░▒▓█▓▒░███░         ░▒▓█▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░     ██      ░▒▓█▓▒░█░           ░▒▓█▓▒░  ░▒▓█▓▒░ ██░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░   ███░      ░▒▓█▓▒░      ░▒▓███████▓▒░   ░▒▓█▓▒░██░ ░▒▓██████▓▒░░▒▓████████▓▒░ ███░          ░░░             ░░░             ░░░             ░░░             ░░░     ███             ███             ███             ███             ███           ██░            ███░            ███░            ███░            ███░            ░            ███░            ███░            ███░            ███░            ██           ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░         ███░            ███░            ███░            ███░            ███░          ░░░             ░░░             ░░░             ░░░             ░░░                     ███             ███             ███             ███             ██"
    Write-Host $art -ForegroundColor Cyan
    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host " Developer: PSYCHOWHO / SIFAT"
    Write-Host " Project: PSY-60-FORZA-SHADER-LOADER"
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
}

Clear-Screen
Show-Art

$reshadeAns = Read-Host "Do you have ReShade installed? (Y/N)"
if ($reshadeAns -match "^[Nn]") {
    Write-Host "[*] Downloading ReShade Setup..." -ForegroundColor Yellow
    $reshadeUrl = "https://reshade.me/downloads/ReShade_Setup_6.7.3.exe"
    $reshadePath = "$env:TEMP\ReShade_Setup.exe"
    Invoke-WebRequest -Uri $reshadeUrl -OutFile $reshadePath
    Write-Host "[+] Download complete! Launching ReShade installer..." -ForegroundColor Green
    Start-Process -FilePath $reshadePath -Wait
    Write-Host "[+] ReShade installation finished." -ForegroundColor Green
}

$gamePath = Read-Host "`nPlease enter the specific path where the game is installed"
$gamePath = $gamePath.Trim("`"").Trim("'")

if (-Not (Test-Path $gamePath)) {
    Write-Host "[-] The specified path does not exist. Please run the script again." -ForegroundColor Red
    exit
}

Write-Host "[*] Downloading shaders from GitHub..." -ForegroundColor Yellow
$zipUrl = "https://github.com/psycodess/PSY-60-FORZA-SHADER-LOADER/archive/refs/heads/main.zip"
$zipPath = "$env:TEMP\psy60_shaders.zip"
$extractPath = "$env:TEMP\psy60_extract"

Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath
if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

$repoFolder = "$extractPath\PSY-60-FORZA-SHADER-LOADER-main\reshade-shaders"

if (Test-Path $repoFolder) {
    Write-Host "[*] Copying shaders to $gamePath..." -ForegroundColor Yellow
    $dstReshade = "$gamePath\reshade-shaders"
    if (Test-Path $dstReshade) { Remove-Item $dstReshade -Recurse -Force }
    
    Copy-Item -Path $repoFolder -Destination $gamePath -Recurse -Force
    
    # Copy .ini files to game root
    Get-ChildItem -Path $repoFolder -Filter "*.ini" | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $gamePath -Force
    }
    
    Write-Host "`n=====================================================" -ForegroundColor Green
    Write-Host " SUCCESS! Everything has been installed successfully. " -ForegroundColor Green
    Write-Host "=====================================================`n" -ForegroundColor Green
} else {
    Write-Host "[-] Failed to extract shaders." -ForegroundColor Red
}

# Clean up
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "[*] Opening Instagram..." -ForegroundColor Magenta
Start-Sleep -Seconds 2
Start-Process "https://www.instagram.com/psychowhoqustionmark/"
