Invoke-WebRequest "https://nti-exponencial.github.io/gpo/scripts/selectUser.ps1" -OutFile "$env:TEMP/selectUser.ps1"
. "$PSScriptRoot\selectUser.ps1"
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS

$profilePath = selectUser
if ($null -eq $profilePath) {
    return
}
reg load HKU\TempHive "$profilePath\NTUSER.DAT"

New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\" -Force | Out-Null

Remove-ItemProperty -Path $chromePath -Name "BrowserThemeColor" `
    -ErrorAction SilentlyContinue

Remove-ItemProperty -Path $chromePath -Name "NTPCustomBackgroundEnabled" `
    -ErrorAction SilentlyContinue

# Remove the ActiveDesktop wallpaper restriction
$desktopPath = "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
Remove-ItemProperty -Path $desktopPath -Name "NoChangingWallPaper" `
    -ErrorAction SilentlyContinue


[gc]::Collect()
[gc]::WaitForPendingFinalizers()
reg unload HKU\TempHive
pause
