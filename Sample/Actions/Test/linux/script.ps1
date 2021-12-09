Write-Host 'Write-Host'
Write-Output 'Write-Output'
Get-Process | Format-Table
Get-Item blah.md

$settings = Get-Content ../settings.json | ConvertFrom-Json

<#Start-Process runway.exe -ArgumentList @('-N','-S',$settings.host,'download') -Wait

$zipFiles = Get-ChildItem ./download/*.zip
foreach ($zip in $zipFiles) {
    Expand-Archive -Path $zip.FullName -DestinationPath ./Results
}#>

Copy-Item ../*.* -Destination ./Results