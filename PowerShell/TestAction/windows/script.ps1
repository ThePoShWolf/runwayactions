Copy-Item .\*.* -Destination .\Results
Write-Host 'Write-Host'
Write-Output 'Write-Output'
Get-LocalUser | Format-Table