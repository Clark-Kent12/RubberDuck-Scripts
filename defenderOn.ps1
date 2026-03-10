# Включить Windows Defender и основные службы
Write-Host "Turning On Windows Defender..." -ForegroundColor Cyan
try {
    # Убираем отключение realtime protection
    Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue

    # Включаем службу Defender
    Set-Service -Name WinDefend -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service -Name WinDefend -ErrorAction SilentlyContinue

    # Включаем firewall
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction SilentlyContinue

    Write-Host "Ready. Windows Defender and Firewall turned On." -ForegroundColor Green
} catch {
    Write-Host "Couldn't fully turn on Defender. Probably, it turned off from system politics or different antivirus." -ForegroundColor Red
}

# --- Функция для отправки уведомления в Discord ---
function Upload-Discord {
    [CmdletBinding()]
    param (
        [parameter(Position=0, Mandatory=$False)] [string]$file,
        [parameter(Position=1, Mandatory=$False)] [string]$text
    )

    $hookurl = "$dc"
    $Body = @{
        'username' = $env:username
        'content' = $text
    }
    if (-not ([string]::IsNullOrEmpty($text))) {
        Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl -Method Post -Body ($Body | ConvertTo-Json)
    }
    if (-not ([string]::IsNullOrEmpty($file))) {
        curl.exe -F "file1=@$file" $hookurl
    }
}

# Пример использования: Отправляем сообщение в Discord
# Upload-Discord -text "Windows Defender and Firewall turned On!"

# Проверка, включен ли Defender и отправка уведомления в Discord
if (Get-Service WinDefend.exe | Where-Object {$_.Status -eq "Running"}) {
    Upload-Discord -text "Windows Defender and Firewall turned On."
} else {
    Write-Host "Windows Defender is not running." -ForegroundColor Yellow
}
