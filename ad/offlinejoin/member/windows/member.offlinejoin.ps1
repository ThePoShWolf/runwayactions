# Load settings
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings
# dl previous action results
Invoke-WebRequest -Uri 'https://runwaydownloads.blob.core.windows.net/appdl/runway.exe' -OutFile .\runway.exe
$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
.\runway -N -S $settings.host download --directory $outFolder
# djoin
$zips = Get-ChildItem .\*.zip
if($zips.Count -gt 1) {
    Write-Host 'Too many zips.'
} else {
    $file = Expand-Archive $zips[0].FullName -PassThru | ?{$_.Name -eq 'blob.txt'}

    djoin /requestodj /loadfile $file.FullName /windowspath c:\windows /localos
}

# debug
Copy-Item .\std.out -Destination .\results