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
$zips = Get-ChildItem $outFolder\*.zip
if($zips.Count -gt 1) {
    Write-Host 'Too many zips.'
} else {
    Expand-Archive $zips[0].FullName -DestinationPath $outFolder

    Get-ChildItem $outFolder -Recurse
    
    $file = Get-ChildItem $outFolder -Recurse -Filter *.req

    certreq -submit -config SubCA1.runway.lab\LabSubCA1 $($file.FullName) .\results\cert.cer .\results\cert.pfx
}

# debug
Copy-Item .\std.out -Destination .\results