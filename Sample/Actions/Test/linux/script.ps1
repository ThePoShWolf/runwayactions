Write-Host $ErrorActionPreference

$ErrorActionPreference = 'Continue'

Write-Host 'Write-Host'
Write-Output 'Write-Output'
Get-Process | Format-Table
Get-Item blah.md -ErrorAction Continue

$settings = Get-Content ./settings.json | ConvertFrom-Json

<#Start-Process runway.exe -ArgumentList @('-N','-S',$settings.host,'download') -Wait

$zipFiles = Get-ChildItem ./download/*.zip
foreach ($zip in $zipFiles) {
    Expand-Archive -Path $zip.FullName -DestinationPath ./Results
}#>

Get-Item ./

Get-Item ./Results

Get-Item ./*.*

Copy-Item ./*.* -Destination ./results -Verbose

Write-Host 'End'