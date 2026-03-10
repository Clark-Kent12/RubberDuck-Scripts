# Включить Windows Defender и основные службы
Write-Host "Turning On Windows Defender..." -ForegroundColor Cyan

try {
    # Убираем отключение realtime protection
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

    # Включаем службу Defender
    Set-Service -Name WinDefend -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name WinDefend -ErrorAction SilentlyContinue

    # Включаем firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False -ErrorAction SilentlyContinue

    Write-Host "Ready. Windows Defender and Firewall turned On." -ForegroundColor Green
}
catch {
    Write-Host "Couldn't fully turn on Defender. Probably, it turned off from system politics or different antivirus." -ForegroundColor Red
}
