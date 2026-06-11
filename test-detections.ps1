# ============================================================
#  Safe attack simulation - fires the custom + built-in detections.
#  Everything here is read-only / harmless. Run it with the Wazuh
#  dashboard open at:  Threat Hunting -> Events -> Last 15 minutes
#  so you can watch the alerts appear, then refresh after ~20s.
# ============================================================

# NOTE: the *real* malicious form (certutil -urlcache -split -f <url>) is BLOCKED
# by Windows Defender as a known LOLBin attack - the process never starts, so
# Sysmon can't log it (great layered-defense result, documented in the README).
# To validate the SIEM rule itself, we run the benign cache-list form: it still
# launches certutil with "urlcache" on the command line - exactly what rule
# 100100 matches - but performs no download, so Defender lets it run.
Write-Host "[1] certutil w/ 'urlcache'    -> CUSTOM rule 100100 (MITRE T1105)" -ForegroundColor Yellow
certutil.exe -urlcache 2>&1 | Out-Null

Write-Host "[2] MITRE Discovery recon     -> built-in Discovery rules (T1087/T1082/T1016)" -ForegroundColor Yellow
whoami /all   | Out-Null
systeminfo    | Out-Null
ipconfig /all | Out-Null
net user      | Out-Null
net localgroup administrators | Out-Null
arp -a        | Out-Null

Write-Host ""
Write-Host "Done. In the dashboard (Threat Hunting -> Events), refresh after ~20s." -ForegroundColor Green
Write-Host "Look for: 'CUSTOM: certutil.exe used to download a file' (level 12)" -ForegroundColor Green
Write-Host "and several 'Discovery activity executed' alerts." -ForegroundColor Green
