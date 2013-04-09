$user=""
$APIkey=""
$auth=""
$region=""
[Environment]::SetEnvironmentVariable("OS_USERNAME", "$user", "User")
[Environment]::SetEnvironmentVariable("OS_TENANT_NAME", "$user", "User")
[Environment]::SetEnvironmentVariable("OS_AUTH_SYSTEM", "rackspace", "User")
[Environment]::SetEnvironmentVariable("OS_PASSWORD", "$APIkey", "User")
[Environment]::SetEnvironmentVariable("OS_AUTH_URL", "$auth", "User")
[Environment]::SetEnvironmentVariable("OS_REGION_NAME", "$region", "User")