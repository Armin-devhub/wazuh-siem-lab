# ============================================================
#  Install the Wazuh agent on this Windows PC and point it at
#  the local manager (running in Docker, ports published to
#  127.0.0.1). The agent auto-enrolls over port 1515.
#  MUST run elevated (installs a Windows service).
# ============================================================
$ErrorActionPreference = "Stop"
$msi = Join-Path $PSScriptRoot "wazuh-agent-4.14.5-1.msi"
$agentName = $env:COMPUTERNAME

Write-Host "Installing Wazuh agent -> manager 127.0.0.1, name '$agentName'..." -ForegroundColor Cyan
$p = Start-Process msiexec.exe -Wait -PassThru -ArgumentList @(
    "/i", "`"$msi`"", "/qn",
    "WAZUH_MANAGER=127.0.0.1",
    "WAZUH_REGISTRATION_SERVER=127.0.0.1",
    "WAZUH_AGENT_NAME=$agentName"
)
Write-Host "msiexec exit code: $($p.ExitCode)"

Start-Sleep 3
Write-Host "Starting Wazuh service..." -ForegroundColor Cyan
Start-Service WazuhSvc
Start-Sleep 2
Get-Service WazuhSvc | Select-Object Name, Status, StartType | Format-Table -AutoSize
Write-Host "Agent installed and started. It should appear in the dashboard (Endpoints) within ~60s." -ForegroundColor Green
Write-Host "Press any key to close..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
