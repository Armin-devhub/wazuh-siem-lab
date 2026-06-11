# ============================================================
#  Stop the Wazuh SIEM lab
#  - Stops the 3 containers and frees the RAM they were using
#  - All data (logs, alerts, agents, rules) is kept in Docker
#    volumes, so start-lab.ps1 resumes exactly where you left off.
#  - This does NOT delete anything. To wipe the lab completely
#    you would run `docker compose down -v` (removes volumes too).
# ============================================================
$compose = Join-Path $PSScriptRoot "wazuh-docker\single-node"

Push-Location $compose
docker compose stop
Pop-Location

Write-Host ""
Write-Host "Lab stopped. RAM released. Data preserved." -ForegroundColor Green
Write-Host "Run start-lab.ps1 to bring it back up." -ForegroundColor DarkGray
