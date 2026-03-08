Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Wallpapers = @(
"https://cataratas.github.io/GPO/assets/wallpaper_orange.jpeg",
"https://cataratas.github.io/GPO/assets/wallpaper_blue.jpeg"
)

$form = New-Object Windows.Forms.Form
$form.Text = "Select Wallpaper"
$form.Size = New-Object Drawing.Size(600,400)
$form.StartPosition = "CenterScreen"

$panel = New-Object Windows.Forms.FlowLayoutPanel
$panel.Dock = "Fill"
$panel.AutoScroll = $true

$form.Controls.Add($panel)

# Windows API for wallpaper change
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
[DllImport("user32.dll", SetLastError=true)]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

foreach ($url in $Wallpapers) {

$file = Join-Path $env:TEMP (Split-Path $url -Leaf)

# Download preview image
Invoke-WebRequest $url -OutFile $file

$pic = New-Object Windows.Forms.PictureBox
$pic.Image = [Drawing.Image]::FromFile($file)
$pic.SizeMode = "Zoom"
$pic.Width = 180
$pic.Height = 110
$pic.Margin = 10

$pic.Tag = $url

$pic.Add_Click({

$Wallpaper = $this.Tag
$FileName = Split-Path $Wallpaper -Leaf
$Destination = "C:\Windows\Web\Wallpaper\$FileName"

Invoke-WebRequest $Wallpaper -OutFile $Destination

Set-ItemProperty "HKCU:\Control Panel\Desktop" WallpaperStyle 10
Set-ItemProperty "HKCU:\Control Panel\Desktop" TileWallpaper 0

[Wallpaper]::SystemParametersInfo(20,0,$Destination,3)

})

$panel.Controls.Add($pic)
}

$form.Add_FormClosing({
    [System.Environment]::Exit(0)
})
$form.ShowDialog()
