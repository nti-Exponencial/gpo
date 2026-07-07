Invoke-WebRequest "https://cataratas.github.io/gpo/scripts/selectUser.ps1" -OutFile "$env:TEMP/selectUser.ps1"
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

# Set-LocalUser -Name 'Aluno(a)' -PasswordNeverExpires $true
#net user 'Aluno(a)' /PasswordChg:No

New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\" -Force | Out-Null

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserThemeColor" -PropertyType String -Value "#1F1F1F" -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "PasswordManagerEnabled" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserGuestModeEnabled" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserAddPersonEnabled" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserSignin" -PropertyType DWord -Value 0 -Force

New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "NTPCustomBackgroundEnabled" -PropertyType DWord -Value 0 -Force

New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "3" -PropertyType String -Value "cookies_and_other_site_data" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "4" -PropertyType String -Value "cached_images_and_files" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "5" -PropertyType String -Value "password_signin" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "6" -PropertyType String -Value "autofill" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "7" -PropertyType String -Value "site_settings" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "8" -PropertyType String -Value "hosted_app_data" -Force

Invoke-WebRequest "https://cataratas.github.io/gpo/assets/wallpaper_orange.jpeg" -OutFile "C:\Windows\Web\Wallpaper\wallpaper_orange.jpeg"
New-Item -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "Wallpaper" -PropertyType String -Value "C:\Windows\Web\Wallpaper\wallpaper_orange.jpeg" -Force

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoChangingLockScreen" -PropertyType DWord -Value 1 -Force

# (2 = stretch, 0 = center, 6 = fit, 10 = fill)
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "WallpaperStyle" -PropertyType String -Value "2" -Force


New-Item -Path "HKU:\TempHive\Software\Policies\Microsoft\Edge" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Microsoft\Edge" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 1 -Force

New-Item -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Force | Out-Null
New-ItemProperty `
    -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -Name "SettingsPageVisibility" `
    -PropertyType String `
    -Value "hide:regionlanguage;language;keyboard;screenrotation" `
    -Force

[gc]::Collect()
[gc]::WaitForPendingFinalizers()
reg unload HKU\TempHive
pause
