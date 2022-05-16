[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$objForm = New-Object System.Windows.Forms.Form
$objForm.Text = "StartSAS v2"
$objForm.Size = New-Object System.Drawing.Size(300,200)
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter")
    {$global:startSAS=$true;
            $global:AWStitle=$objTextBox.Text;
            $ALTlog=$objTextBox2.Text
            $objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape")
    {$global:startSAS=$false;$objForm.Close()}})


$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(50,140)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$global:startSAS=$true;
                     $global:AWStitle=$objTextBox.Text;
                     $ALTlog=$objTextBox2.Text;
                     $objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(175,140)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$global:startSAS=$false;$objForm.Close()})
$objForm.Controls.Add($CancelButton)


$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,10)
$objLabel.Size = New-Object System.Drawing.Size(280,20)
$objLabel.Text = "AWS title:"
$objForm.Controls.Add($objLabel)

$objTextBox = New-Object System.Windows.Forms.TextBox
$objTextBox.Location = New-Object System.Drawing.Size(10,30)
$objTextBox.Size = New-Object System.Drawing.Size(260,30)
$objForm.Controls.Add($objTextBox)


$objLabel2 = New-Object System.Windows.Forms.Label
$objLabel2.Location = New-Object System.Drawing.Size(10,70)
$objLabel2.Size = New-Object System.Drawing.Size(280,20)
$objLabel2.Text = "ALT-log:"
$objForm.Controls.Add($objLabel2)

$objTextBox2 = New-Object System.Windows.Forms.TextBox
$objTextBox2.Location = New-Object System.Drawing.Size(10,90)
$objTextBox2.Size = New-Object System.Drawing.Size(260,90)
$objForm.Controls.Add($objTextBox2)


$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate(); $objTextBox.focus()})
[void] $objForm.ShowDialog()

Write-Host $StartSAS
Write-Host $AWStitle
Write-Host $ALTlog

if ( ( $StartSAS ) )
{

    if ( ( $ALTlog ) ) { $ALTlog2 = "-altlog '${ALTlog}'" }

    $ProcessHomeDir  = (Get-Location).ToString()
<#    $processBaseDir  = "F:\database\SeSE"#>


    # Find placering af SAS udfra registrering i Windows Registry
    $sasloc                     = get-itemproperty -path "hklm:\SOFTWARE\SAS Institute Inc.\The SAS System\9.4" -name DefaultRoot | % { $_.DefaultRoot }
    $StartInfo                  = new-object System.Diagnostics.ProcessStartInfo
    $StartInfo.FileName         = "${sasloc}\sas.exe"
    $StartInfo.Arguments        = "-CONFIG 'H:\sasconfig\udvikhrtal.cfg' -AWStitle '${AWStitle}' ${ALTlog2} -rsasuser -SASINITIALFOLDER 'C:\Users\rfad0001\Documents\My SAS Files\9.4\SAS output'"
    $StartInfo.LoadUserProfile  = $false
    $StartInfo.UseShellExecute  = $false
    $StartInfo.WorkingDirectory = $ProcessHomeDir

    $job = [System.Diagnostics.Process]::Start($StartInfo)

    Write-Host $StartInfo.FileName $StartInfo.Arguments

}
