Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Scripts = @(
    @{ Name = "Lab. Informática | Aluno(a)"; Url = "cataratas.github.io/GPO/scripts/lab.ps1" }
    @{ Name = "Wallpapers"; Url = "cataratas.github.io/GPO/scripts/wallpaper.ps1" }
)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Lab Deployment Tool"
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen"

$y = 20

foreach ($script in $Scripts) {

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $script.Name
    $button.Size = New-Object System.Drawing.Size(320,40)
    $button.Location = New-Object System.Drawing.Point(30,$y)

    $url = $script.Url

    $button.Add_Click({
        try {
            irm $url | iex
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to run script")
        }
    })

    $form.Controls.Add($button)

    $y += 50
}

$form.ShowDialog()
