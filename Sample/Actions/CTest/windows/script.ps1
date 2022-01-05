$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

Invoke-WebRequest -Uri 'https://runwaydownloads.blob.core.windows.net/appdl/runway.exe' -OutFile .\runway.exe
$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
& .\runway.exe -N -S $settings.host download --directory $outFolder
$zips = Get-ChildItem $outFolder -Filter *.zip -Recurse -Verbose
$zips | %{
    $_
    Expand-Archive $_.fullName -DestinationPath .\results -Verbose
    Expand-Archive $_.fullName -DestinationPath C:\RunwayResults -Verbose
}