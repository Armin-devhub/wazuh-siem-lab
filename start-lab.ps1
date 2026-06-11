# ============================================================
#  Start the Wazuh SIEM lab
#  - Boots the Docker engine if it isn't running
#  - Applies the indexer's required kernel setting
#  - Brings up the 3 containers (manager + indexer + dashboard)
# ============================================================
$compose = Join-Path $PSScriptRoot "wazuh-docker\single-node"

Write-Host "Checking Docker engine..." -ForegroundColor Cyan
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker engine not running - starting Docker Desktop..." -ForegroundColor Yellow
    Start-Process 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    do { Start-Sleep 5; docker info *> $null } until ($LASTEXITCODE -eq 0)
    Write-Host "Docker engine is up." -ForegroundColor Green
}

# OpenSearch (the indexer) needs this kernel setting; harmless to re-apply.
wsl -d docker-desktop sysctl -w vm.max_map_count=262144 | Out-Null

Push-Location $compose
docker compose up -d
Pop-Location

Write-Host ""
Write-Host "Wazuh dashboard:  https://localhost" -ForegroundColor Green
Write-Host "Login:            admin / SecretPassword" -ForegroundColor Green
Write-Host "(Give it ~60s on first load, then refresh.)" -ForegroundColor DarkGray
