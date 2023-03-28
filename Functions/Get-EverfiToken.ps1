function Get-EverfiToken {
    <#
.SYNOPSIS
    Creates a JWT.
.DESCRIPTION
    This function uses a client id and a client secret to create a JWT.
.EXAMPLE
    Get-EverfiToken -client_id $client_id -client_secret $client_secret
.PARAMETER client_id
    The client_id is provided by the Data Integration settings on Everfi.
.PARAMETER client_secret
    The client_secret is provided by the Data Integration settings on Everfi. This parameter must be a securestring.
.NOTES
    The JWT provided by this function expires 2 hours after creation. It can be reused as often as the api throttle limit allows.
    #>

    [CmdletBinding()]
    param (
        [string]$client_id,
        [securestring]$client_secret,
        $url = 'https://api.fifoundry.net'
    )

    $headers = @{
        'Content-Type' = 'application/json'
        'Accept'       = 'application/json'
    }

    $body = "grant_type=client_credentials&client_id=$client_id&client_secret=$([Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($client_secret)))"

    $restArgs = @{
        'URI'     = "$url/oauth/token?$body"
        'Headers' = $headers
        'Method'  = 'POST'
    }

    $response = Invoke-RestMethod @RestArgs
    Return $response.access_token
}