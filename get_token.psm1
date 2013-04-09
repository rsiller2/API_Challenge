#Auth return formatted
#variables used
function Get-Token {
$global:user = $env:OS_TENANT_NAME
$apikey = $env:OS_PASSWORD
$authurl = $env:OS_AUTH_URL + 'tokens'

#string
$string = '{"auth" : {"RAX-KSKEY:apiKeyCredentials" : {"username" : "$user", "apiKey" : "$apikey"}}}'

#expands variables within string
$post = $ExecutionContext.InvokeCommand.ExpandString($string) 
#sets request to variable to be used later
$request = Invoke-RestMethod -uri $authurl -Method Post -Body $post -ContentType application/json

$global:token = $request.access.token.id 
$global:custDDI = $request.access.token.tenant.id

}


