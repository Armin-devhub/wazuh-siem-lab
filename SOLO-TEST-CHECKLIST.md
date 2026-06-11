# Solo Test & Screenshot Checklist

Run this **with VS Code closed** so the lab + browser get the full 7.2 GB of RAM.
Goal: watch your custom rule fire live, and capture screenshots for the portfolio.

---

## 1. Free the memory
- Close **VS Code** (this ends the Claude chat — that's fine, everything is saved).
- Close any other heavy apps. Keep only what you need: the browser, Docker.

## 2. Start the lab
Right-click `start-lab.ps1` -> **Run with PowerShell** (or in a terminal: `powershell -File start-lab.ps1`).
Wait until it prints the dashboard URL, then give it ~60s.

## 3. Load the latest rules (custom detection + tuning rule)
Right-click `load-rules.ps1` -> **Run with PowerShell**.
Wait for **"wazuh-analysisd is running"** = your rules loaded.

## 4. Open the dashboard, ready to watch
- Go to **https://localhost** -> log in (`admin` / `SecretPassword`)
- **menu (three lines) -> Threat Hunting -> Events tab**
- Set the time picker (top-right) to **Last 15 minutes**
- In the search box type:  `rule.id:100100`   (your custom certutil rule)

## 5. Fire the test
In a normal PowerShell window, run:  `powershell -File test-detections.ps1`
(or right-click `test-detections.ps1` -> Run with PowerShell)

## 6. Watch it fire + screenshot
- Wait ~20s, then **refresh** the Events view.
- You should see: **"CUSTOM: certutil.exe used to download a file"**, level **12**, MITRE **T1105**.
- Click the **>** arrow to expand it -> the command line shows certutil with `urlcache`.
- **Screenshot** this (your custom rule catching the attack). Save to `screenshots/`.

### Screenshots worth capturing
1. The agent **Active** under Endpoints
2. **Threat Hunting** overview (the dashboard with charts)
3. Your **custom rule 100100** alert, expanded
4. A **Discovery** alert from the recon (built-in detection)
5. **Server Management -> Rules** showing your `local_rules.xml` custom rules
6. (Optional) The **SCA / CIS benchmark** results

## 7. When done
Run `stop-lab.ps1` to give your RAM back. Data is preserved.

---

**Tip:** if the dashboard ever errors ("Something went wrong") or feels stuck,
that's the RAM ceiling. Close other apps, wait a few seconds, and refresh.
Run `stop-lab.ps1` whenever you're finished for the day.
