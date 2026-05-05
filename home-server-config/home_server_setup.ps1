# =========================================================================
# Home Server Auto-Installer for Windows
# =========================================================================
# Kérlek futtasd ezt a fájlt rendszergazdaként (Run as Administrator)!
# Jobb klikk a fájlon -> "Run with PowerShell" (ha nem megy, nyiss egy
# Admin PowerShell-t és ".\home_server_setup.ps1")

Write-Host ">>> Tailscale telepítése (VPN a távoli eléréshez)..." -ForegroundColor Cyan
winget install Tailscale.Tailscale --accept-package-agreements --accept-source-agreements

Write-Host ""
Write-Host ">>> Ollama telepítése (Helyi LLM motor)..." -ForegroundColor Cyan
winget install Ollama.Ollama --accept-package-agreements --accept-source-agreements

Write-Host ""
Write-Host ">>> Chrome Remote Desktop Host telepítése (Képernyőmegosztás/Headless elérés)..." -ForegroundColor Cyan
winget install Google.ChromeRemoteDesktopHost --accept-package-agreements --accept-source-agreements

Write-Host ""
Write-Host ">>> WSL telepítése és beállítása (ez újraindítást igényelhet)..." -ForegroundColor Cyan
wsl --install

Write-Host ""
Write-Host ">>> OpenSSH alapértelmezett shell beállítása (WSL bash wrapper Antigravity-hez)..." -ForegroundColor Cyan
# Translator script létrehozása a wsl-nek, hogy jól kezelje a parancsokat (pl. Antigravity csatlakozásnál)
$wrapperPath = "C:\wsl-ssh-wrapper.bat"
Set-Content -Path $wrapperPath -Value "@echo off", "wsl.exe bash %*" -Encoding Ascii
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $wrapperPath -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "-c" -PropertyType String -Force
Restart-Service sshd -ErrorAction SilentlyContinue

Write-Host ""
Write-Host ">>> Telepítések befejeződtek!" -ForegroundColor Green
Write-Host ""
Write-Host "TELEPÍTÉS UTÁNI TEENDŐK:" -ForegroundColor Yellow
Write-Host "1. TAILSCALE: Keresd meg a Start menüben a 'Tailscale'-t, indítsd el, és jelentkezz be!"
Write-Host "2. VS CODE TUNNELS BEÁLLÍTÁSA:"
Write-Host "   Futtasd az alábbi parancsot EGY NORMÁL (nem admin) PowerShell ablakban:"
Write-Host "   > code tunnel"
Write-Host "   Kövesd a képernyőn megjelenő GitHub bejelentkezési linket."
Write-Host "   A Chromebook-on csak nyisd meg a https://vscode.dev/ oldalt!"
Write-Host "3. CHROME REMOTE DESKTOP BEÁLLÍTÁSA (Automatikus induláshoz):"
Write-Host "   Látogass el a https://remotedesktop.google.com/access oldalra a PC-n."
Write-Host "   Jelentkezz be Google fiókoddal, és kattints a 'Turn on' / 'Bekapcsolás' gombra."
Write-Host "   Adj meg egy számítógép nevet és egy PIN kódot."
Write-Host "   Ezután a Remote Desktop szolgáltatásként (service) fog futni, így újraindítás után"
Write-Host "   azonnal, monitor nélkül is (akár bejelentkezés előtt) be tudsz lépni Chromebookról!"
Write-Host "4. KÓDOLÓ LLM MODELL LETÖLTÉSE:"
Write-Host "   Futtasd az alábbi parancsot egy normál PowerShell ablakban:"
Write-Host "   > ollama run qwen2.5-coder:7b"
Write-Host "   (Ha a miniPC-ben kevesebb mint 16GB RAM van, használd ezt: > ollama run qwen2.5-coder:1.5b)"
Write-Host ""
Write-Host "Nyomj egy entert a kilépéshez..."
Read-Host
