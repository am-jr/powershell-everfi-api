function New-EverfiUser {
    <#
.SYNOPSIS
    Creates a new user in Everfi.
.DESCRIPTION
    This function creates a new user in Everfi and allows for a single ruleset and user role to be added to the account.
.PARAMETER rule_set
    This parameter designates which ruleset the new user will use. fac_staff_learner is the basic default staff member.
.PARAMETER location_id
    An integer which designates the campus/workplace.
.PARAMETER sso_id
    The username that will be passed over by the SAML POST.
.PARAMETER role
    Designate whether the user will be a supervisor or a regular setaff member.
.PARAMETER token
    The JWT that is retrieved with the client secret and client id.
.EXAMPLE
    New-EverfiUser -rule_set 'fac_staff_learner' -first_name 'Test' -last_name 'User SR' -email 'tusersr@email.com' -employee_id '0012' -sso_id 'tusersr' -role 'non_supervisor'
.NOTES
    #>

    param (
        [parameter(mandatory = $true)]
        [string]$rule_set,
        [parameter(mandatory = $true)]
        [string]$first_name,
        [parameter(mandatory = $true)]
        [string]$last_name,
        [parameter(mandatory = $true)]
        [string]$email,
        $employee_id,
        [parameter(mandatory = $true)]
        $location_id,
        [parameter(mandatory = $true)]
        $sso_id,
        [parameter(mandatory = $true)]
        $role,
        [parameter(mandatory = $true)]
        $token,
        $url = 'https://api.fifoundry.net',
        $apiVersion = 'v1'
    )

    $headers = @{
        'Content-Type'  = 'application/json'
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $token"
    }

    $body = @{
        'data' = @{
            #Registration_sets is the default value and must be included in the body.
            'type'       = 'registration_sets'
            'attributes' = @{
                'registrations' = @{
                    #User_rule_set is the default value and must be included for user creation.
                    rule_set    = 'user_rule_set'
                    first_name  = $first_name
                    last_name   = $last_name
                    email       = $email
                    location_id = $location_id
                    employee_id = $employee_id
                    sso_id      = $sso_id
                },
                @{
                    rule_set = $rule_set
                    role     = $role
                }
            }
        }
    } | ConvertTo-Json -Depth 4

    $restArgs = @{
        'URI'     = "$url/$apiVersion/admin/registration_sets"
        'Headers' = $headers
        'Body'    = $body
        'Method'  = 'POST'
    }

    Invoke-RestMethod @RestArgs
}