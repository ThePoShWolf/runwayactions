# Import the settings
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

# inf stuff
$inf = @'
Subject = <subject>
Exportable = TRUE
RequestType = CMC
[RequestAttributes]
CertificateTemplate = Web Server
'@

if ($settings.Subject -eq 'Generated') {
    # Find that website (defaults to the default name)
    $website = Get-Website -Name $settings.'Website Name'
    if ($null -ne $website) {
        $sslBinding = $website.Bindings.Collection | Where-Object {$_.Protocol -eq 'https'}
        $domain = $sslBinding.bindingInformation.Split(':')[2]
    } else {
        Throw "Website with name '$($settings.'Website Name')' not found."
    }
} else {
    $subject = $settings.Subject
}

$inf = $inf -replace '\<subject\>',"CN=$subject"
$inf
$inf | Out-File .\certreq.inf

certreq.exe -new .\certreq.inf .\results\cert.req