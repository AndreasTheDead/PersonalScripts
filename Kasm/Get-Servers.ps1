$Settings = Import-PowerShellDataFile .\Kasm\Settings.psd1
#Docu = https://docs.kasm.com/docs/reference/developer-api
function Get-KASMServers {
    param (
        $apikey,
        $apikeysecret,
        $sortby = "hostname",
        $HostName,
        $filter = @(
            @{  "id"= "enabled"
                "value"= $true
            },
            @{
                "id"= "server_type"
                "value"= "Desktop" 
            }
        )
    )
    $page = 1
    $body = @{
        "api_key" = "$apikey"
        "api_key_secret"= "$apikeysecret"
        "page"= $page
        "page_size"= 20
        "sort_by"= "$sortby"
        "sort_direction"= "asc"
        "filters"= $filter
    }
    $headers = @{
        "content-type" = "application/json"
    }
    $res = Invoke-RestMethod -Method Post -Uri "$HostName/api/public/get_servers" -Body ($body | ConvertTo-Json -Compress) -Headers $headers
    return $res.servers
}

$Servers = Get-KASMServers -apikey $Settings.ApiKey -apikeysecret $Settings.ApiKeySecret -HostName $Settings.BaseURL
$Servers[0]