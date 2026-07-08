Invoke-WebRequest "https://nti-exponencial.github.io/gpo/scripts/selectUser.ps1" -OutFile "$env:TEMP/selectUser.ps1"
. "$PSScriptRoot\selectUser.ps1"
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS

$profilePath = selectUser
if ($null -eq $profilePath) {
    return
}
reg load HKU\TempHive "$profilePath\NTUSER.DAT"
$username = Split-Path $profilePath -Leaf
Set-LocalUser -Name $username -PasswordNeverExpires $true
net user $username /PasswordChg:No

New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\" -Force | Out-Null

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserThemeColor" -PropertyType String -Value "#1F1F1F" -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "NTPCustomBackgroundEnabled" -PropertyType DWord -Value 0 -Force

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoChangingLockScreen" -PropertyType DWord -Value 1 -Force

New-Item -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" -Name "NoChangingWallPaper" -PropertyType DWord -Value 1 -Force

[gc]::Collect()
[gc]::WaitForPendingFinalizers()
reg unload HKU\TempHive
pause
