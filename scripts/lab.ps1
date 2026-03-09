New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
reg load HKU\TempHive "$env:USERPROFILE\NTUSER.DAT"

# Browser History
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\AllowDeletingBrowserHistory" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 0 -Force

# Guest mode
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\BrowserGuestModeEnabled" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserGuestModeEnabled" -PropertyType DWord -Value 0 -Force

# Browser Signin
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\BrowserSignin" -Force | Out-Null
New-ItemProperty -Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
    -Name "BrowserSignin" -PropertyType DWord -Value 0 -Force

# Clear Data on Exit
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

# Set Wallpaper
Invoke-WebRequest "https://nti-exponencial.github.io/gpo/assets/wallpaper_orange.jpeg" -OutFile "C:\Windows\Web\Wallpaper\wallpaper_orange.jpeg"
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "Wallpaper" -PropertyType String -Value "C:\Windows\Web\Wallpaper\wallpaper_orange.jpeg" -Force

# (2 = stretch, 0 = center, 6 = fit, 10 = fill)
New-ItemProperty -Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
    -Name "WallpaperStyle" -PropertyType String -Value "2" -Force

# Delete data on exit (IE)
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Internet Explorer\Control Panel" `
    -Name "AllowDeletingBrowserHistory" -Value 1 -Type DWord -Force

# Delete data on exit (Edge)
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Edge" `
    -Name "AllowDeletingBrowserHistory" -PropertyType DWord -Value 1 -Force

reg unload HKU\TempHive
pause
