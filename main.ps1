$ScriptUrl = "$PSScriptRoot/main.ps1"

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell.exe `
        -Verb RunAs `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptUrl`""
    return
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Scripts = @(
    @{ Name = "Lab. Informatica | Aluno(a)"; Url = "$PSScriptRoot/scripts/lab.ps1" }
    @{ Name = "Lab. Informatica | Professor(a)"; Url = "$PSScriptRoot/scripts/lab2.ps1" }
    @{ Name = "Wallpapers"; Url = "$PSScriptRoot/scripts/wallpaper.ps1" }
)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Colegio Exponencial - GPO"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

$y = 20

foreach ($script in $Scripts) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $script.Name
    $button.Size = New-Object System.Drawing.Size(320, 40)
    $button.Location = New-Object System.Drawing.Point(30, $y)

    $button.Tag = $script.Url

    $button.Add_Click({
        try {
            & $this.Tag
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show($_.Exception.Message)
        }
    })

    $form.Controls.Add($button)
    $y += 50
}

$form.Add_FormClosing({
    [System.Windows.Forms.Application]::Exit()
})
$form.ShowDialog()
