# ============================================================
#  Load the custom detection rules onto the Wazuh manager.
#  Copies rules/local_rules.xml into the manager container and
#  restarts the detection engine so the new rules take effect.
#  Run this after editing rules/local_rules.xml.
# ============================================================
$rules = Join-Path $PSScriptRoot "rules\local_rules.xml"

Write-Host "Copying custom rules to the manager..." -ForegroundColor Cyan
docker cp $rules single-node-wazuh.manager-1:/var/ossec/etc/rules/local_rules.xml
docker exec single-node-wazuh.manager-1 chown wazuh:wazuh /var/ossec/etc/rules/local_rules.xml
docker exec single-node-wazuh.manager-1 chmod 660 /var/ossec/etc/rules/local_rules.xml

Write-Host "Restarting the manager to load rules (~30-45s)..." -ForegroundColor Cyan
docker exec single-node-wazuh.manager-1 /var/ossec/bin/wazuh-control restart | Out-Null

Write-Host "Verifying the rule engine started (= rules parsed cleanly):" -ForegroundColor Cyan
docker exec single-node-wazuh.manager-1 /var/ossec/bin/wazuh-control status | Select-String "analysisd"
Write-Host "If you see 'wazuh-analysisd is running', your rules loaded successfully." -ForegroundColor Green
