New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS
reg load HKU\TempHive "C:\Users\User\NTUSER.DAT"

# Browser History
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\AllowDeletingBrowserHistory" -Force | Out-Null
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome" `
-Name "AllowDeletingBrowserHistory" `
-PropertyType DWord `
-Value 0 `
-Force

# Clear Data on Exit
New-Item -Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" -Force | Out-Null
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "3" `
-PropertyType String `
-Value "cookies_and_other_site_data" `
-Force
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "4" `
-PropertyType String `
-Value "cached_images_and_files" `
-Force
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "5" `
-PropertyType String `
-Value "password_signin" `
-Force
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "6" `
-PropertyType String `
-Value "autofill" `
-Force
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "7" `
-PropertyType String `
-Value "site_settings" `
-Force
New-ItemProperty `
-Path "HKU:\TempHive\Software\Policies\Google\Chrome\ClearBrowsingDataOnExitList" `
-Name "8" `
-PropertyType String `
-Value "hosted_app_data" `
-Force

# Set Wallpaper
New-ItemProperty `
-Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
-Name "Wallpaper" `
-PropertyType String `
-Value "C:\Windows\Web\Wallpaper\wallpaper1.jpeg" `
-Force

# (2 = stretch, 0 = center, 6 = fit, 10 = fill)
New-ItemProperty `
-Path "HKU:\TempHive\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
-Name "WallpaperStyle" `
-PropertyType String `
-Value "2" `
-Force

reg unload HKU\TempHive

