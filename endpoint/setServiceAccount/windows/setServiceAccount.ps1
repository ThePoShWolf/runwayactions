$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

<#
PowerShell 7:
$ssPw = ConvertTo-SecureString $settings.'User Password' -AsPlainText -Force
$credential = [pscredential]::New($settings.'User Name',$ssPw)

Set-Service -Name $settings.'Service Name' -Credential $credential -Verbose
#>

# Windows PowerShell:
sc.exe config `"$($settings.'Service Name')`" obj=`"$($settings.'User Name')`" password=`"$($settings.'User Password')`"