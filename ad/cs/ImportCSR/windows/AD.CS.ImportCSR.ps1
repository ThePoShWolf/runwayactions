$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if (-not (Get-WindowsFeature ADCS-Cert-Authority).Installed) {
    #dl previous action results
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
        $zips | %{
            Copy-Item $_.FullName -Destination C:\Temp
        }
    } else {
        Expand-Archive $zips[0].FullName -DestinationPath $outFolder

        Get-ChildItem $outFolder -Recurse
        
        $file = Get-ChildItem $outFolder -Recurse -Filter *.cer

        certreq -accept $($file.FullName)
    }
} else {
    Write-Host 'Action is only meant for non-CAs.'
}