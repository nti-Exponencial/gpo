Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


function selectUser {
    $profiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" |
            Where-Object { $_.ProfileImagePath -like "C:\Users\*" }

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select User Profile"
    $form.Size = New-Object System.Drawing.Size(350,150)
    $form.StartPosition = "CenterScreen"

    $combo = New-Object System.Windows.Forms.ComboBox
    $combo.Location = New-Object System.Drawing.Point(20,20)
    $combo.Size = New-Object System.Drawing.Size(290,20)

    foreach ($p in $profiles) {
        $name = Split-Path $p.ProfileImagePath -Leaf
        $combo.Items.Add($name) | Out-Null
    }
    $form.Controls.Add($combo)

    $button = New-Object System.Windows.Forms.Button
    $button.Text = "Load"
    $button.Location = New-Object System.Drawing.Point(110,60)
    $form.Controls.Add($button)

    $script:path = $null
    $button.Add_Click({
        $selected = $combo.SelectedIndex
        if ($selected -ge 0) {
            $script:path = $profiles[$selected].ProfileImagePath
            $form.Close()
        }
    })
    $form.ShowDialog() | Out-Null
    return $script:path
}
