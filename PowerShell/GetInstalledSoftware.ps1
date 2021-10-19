$localpath = ".\results"

$searchKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall","SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$hives = @{}
$hives['CurrentUser'] = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::CurrentUser,[Microsoft.Win32.RegistryView]::Default)
$hives['LocalMachine'] = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,[Microsoft.Win32.RegistryView]::Default)
$masterKeys = & {
    foreach ($key in $searchKeys) {
        foreach ($hive in $hives.Keys) {
            $regKey = $hives[$hive].OpenSubkey($key)
            if ($regKey -ne $null) {
                foreach ($subName in $regKey.GetSubkeyNames()) {
                    foreach($sub in $regKey.OpenSubkey($subName)) {
                        [pscustomobject]@{
                            "Name" = $sub.GetValue("displayname")
                            "SystemComponent" = $sub.GetValue("systemcomponent")
                            "ParentKeyName" = $sub.GetValue("parentkeyname")
                            "Version" = $sub.GetValue("DisplayVersion")
                            "UninstallCommand" = $sub.GetValue("UninstallString")
                            "InstallDate" = $sub.GetValue("InstallDate")
                            "RegPath" = $sub.ToString()
                        }
                    }
                }
            }
        }
    }
}

$woFilter = {$null -ne $_.name -AND $_.SystemComponent -ne "1" -AND $null -eq $_.ParentKeyName}
$props = 'Name','Version','ComputerName','Installdate','UninstallCommand','RegPath'

$masterKeys = ($masterKeys | Where-Object $woFilter | Select-Object $props | Sort-Object Name)
$masterKeys | Export-Csv "$localpath\$($env:computername)-installedsw.csv" -Encoding UTF8