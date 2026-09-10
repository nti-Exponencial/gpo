$url = "nti-exponencial.github.io/gpo"
# $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Scripts = @(
    @{ Name = "Lab. Informatica | Aluno(a)"; Url = "$url/gpo/scripts/lab.ps1" }
    @{ Name = "Lab. Informatica | Professor(a)"; Url = "$url/scripts/lab2.ps1" }
    @{ Name = "Salas de Aula"; Url = "$url/scripts/classroom.ps1" }
    @{ Name = "Wallpapers"; Url = "$url/scripts/wallpaper.ps1" }
)
$Rollbacks = @(
    @{ Name = "Rollback | Salas de Aula"; Url = "$url/scripts/rollback/rev_classroom.ps1"}
)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Colegio Exponencial - GPO"
$form.Size = New-Object System.Drawing.Size(620,320)
$form.StartPosition = "CenterScreen"

$y = 20
foreach ($script in $Scripts) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $script.Name
    $button.Size = New-Object System.Drawing.Size(250, 40)
    $button.Location = New-Object System.Drawing.Point(30, $y)

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

$y = 20
foreach ($script in $Rollbacks) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $script.Name
    $button.Size = New-Object System.Drawing.Size(250, 40)
    $button.Location = New-Object System.Drawing.Point(300, $y)

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
