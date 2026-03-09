. "$PSScriptRoot\selectUser.ps1"
New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS

$profilePath = selectUser
if ($null -eq $profilePath) {
    return
}
reg load HKU\TempHive "$profilePath\NTUSER.DAT"

New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\" -Force | Out-Null
# Browser History
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 0 -Force

# Guest mode
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserGuestModeEnabled" -PropertyType DWord -Value 0 -Force

# Browser Signin
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserSignin" -PropertyType DWord -Value 0 -Force

# Clear Data on Exit
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "3" -PropertyType String -Value "cookies_and_other_site_data" -Force
New-ItemProperty -Path "HHKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "4" -PropertyType String -Value "cached_images_and_files" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "5" -PropertyType String -Value "password_signin" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "6" -PropertyType String -Value "autofill" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "7" -PropertyType String -Value "site_settings" -Force
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
    -Name "8" -PropertyType String -Value "hosted_app_data" -Force

# Set Wallpaper
Invoke-WebRequest "https://nti-exponencial.github.io/gpo/assets/wallpaper_orange.jpg" -OutFile "C:\Windows\Web\Wallpaper\wallpaper_orange.jpg"
New-Item -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "Wallpaper" -PropertyType String -Value "C:\Windows\Web\Wallpaper\wallpaper_orange.jpg" -Force

# (2 = stretch, 0 = center, 6 = fit, 10 = fill)
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "WallpaperStyle" -PropertyType String -Value "2" -Force

# Delete data on exit (IE)
New-Item -Path "HKU:\TempHive\Software\Policies\Microsoft\Internet Explorer\Control Panel" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Microsoft\Internet Explorer\Control Panel" `
    -Name "AllowDeletingBrowserHistory" -Value 1 -Type DWord -Force

# Delete data on exit (Edge)
New-Item -Path "HKU:\TempHive\Software\Policies\Microsoft\Edge" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Microsoft\Edge" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 1 -Force

[gc]::Collect()
[gc]::WaitForPendingFinalizers()
reg unload HKU\TempHive
pause
