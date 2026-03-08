$ScriptUrl = "https://cataratas.github.io/Exponencial-GPO/main.ps1"

$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin -or $env:GPO_LAUNCH -ne "1") {
    Start-Process powershell.exe `
        -Verb RunAs `
        -ArgumentList "-ExecutionPolicy Bypass -Command `$env:GPO_LAUNCH='1'; irm $ScriptUrl | iex"
    return
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Scripts = @(
    @{ Name = "Lab. Informatica | Aluno(a)"; Url = "cataratas.github.io/Exponencial-GPO/scripts/lab.ps1" }
    @{ Name = "Lab. Informatica | Professor(a)"; Url = "cataratas.github.io/Exponencial-GPO/scripts/lab2.ps1" }
    @{ Name = "Wallpapers"; Url = "cataratas.github.io/Exponencial-GPO/scripts/wallpaper.ps1" }
)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Colegio Exponencial - GPO"
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen"

$y = 20

foreach ($script in $Scripts) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $script.Name
    $button.Size = New-Object System.Drawing.Size(320,40)
    $button.Location = New-Object System.Drawing.Point(30,$y)

    $button.Tag = $script.Url

    $button.Add_Click({
        try {
            $url = $this.Tag
            $temp = Join-Path $env:TEMP ("deploy_" + [guid]::NewGuid() + ".ps1")
            Invoke-WebRequest $url -OutFile $temp

            Start-Process powershell.exe `
                -ArgumentList "-ExecutionPolicy Bypass -File `"$temp`"" `
                -WindowStyle Normal

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
