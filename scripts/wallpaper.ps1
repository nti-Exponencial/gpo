Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Wallpapers = @(
    "$PSScriptRoot\..\assets\wallpaper_orange.jpeg",
    "$PSScriptRoot\..\assets\wallpaper_blue.jpeg",
    "$PSScriptRoot\..\assets\wallpaper_dark.jpg"
)

$form = New-Object Windows.Forms.Form
$form.Text = "Select Wallpaper"
$form.Size = New-Object Drawing.Size(620, 200)
$form.StartPosition = "CenterScreen"

$panel = New-Object Windows.Forms.FlowLayoutPanel
$panel.Dock = "Fill"
$panel.AutoScroll = $true

$form.Controls.Add($panel)

Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
[DllImport("user32.dll", SetLastError=true)]
public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

foreach ($file in $Wallpapers) {
    $pic = New-Object Windows.Forms.PictureBox
    $pic.Image = [Drawing.Image]::FromFile($file)
    $pic.SizeMode = "Zoom"
    $pic.Width = 180
    $pic.Height = 110
    $pic.Margin = 10
    $pic.Cursor = "Hand"

    $pic.Tag = $file
    $pic.Add_Click({
        $Wallpaper = $this.Tag
        $FileName = Split-Path $Wallpaper -Leaf
        $Destination = "C:\Windows\Web\Wallpaper\$FileName"

        Copy-Item -Path $Wallpaper -Destination $Destination

        Set-ItemProperty "HKCU:\Control Panel\Desktop" WallpaperStyle 10
        Set-ItemProperty "HKCU:\Control Panel\Desktop" TileWallpaper 0

        [Wallpaper]::SystemParametersInfo(20, 0, $Destination, 3)
    })

    $panel.Controls.Add($pic)
}

$form.ShowDialog() | Out-Null
