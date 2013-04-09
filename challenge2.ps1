Import-Module $PSScriptRoot\get_token.psm1 
Get-Token

#variables to create image
    $imagename = 'testimage'
    $serverID ='805f0706-d1e0-4919-af2d-18f29d7b6b54'
    $endpoint = 'https://dfw.servers.api.rackspacecloud.com/v2'
    $string = '{
    "createImage" : {
    "name" : "$imagename",
    "metadata": {
    "ImageType": "test"
    }
    }
    }'

#variables used to create server
    $flavor = 2
    $newservername = 'apitest3'
    $string2 = '{
    "server" : {
    "name" : "$newservername",
    "imageRef" : "$imageID",
    "flavorRef" : "$flavor"
    }
    }'

#reqest to create image
$string = $ExecutionContext.InvokeCommand.ExpandString($string)
$htoken = @{"X-Auth-Token" = "$token"}
$url = '$endpoint/$custDDI/servers/$serverID/action'
$url = $ExecutionContext.InvokeCommand.ExpandString($url)
$request = Invoke-WebRequest -uri $url -Method Post -Body $string -ContentType application/json -Headers $htoken
$request  |Format-List -Property RawContent

#request to get image status
$url2 = '$endpoint/$custDDI/images/detail?server=$serverID&name=$imagename'
$url2 = $ExecutionContext.InvokeCommand.ExpandString($url2)
$request2 = Invoke-RestMethod -uri  $url2 -Headers $htoken
$name = $request2.images.name
$id = $request2.images.id
$created = $request2.images.created
$status = $request2.images.status
$progress = $request2.images.progress
$imageID = $request2.images.id

'Name: ' + $name
'ID: ' + $id
'Created: ' + $created
'Status: ' + $status
'Progress: ' + $progress

#loop to check image status and then build server
$timeout = new-timespan -Minutes 60
$sw = [diagnostics.stopwatch]::StartNew()
while ($sw.elapsed -lt $timeout){
    if (($progress -eq 100) -and ($status -eq "Active")){
        "Complete"
    
    $string2 = $ExecutionContext.InvokeCommand.ExpandString($string2)
    #request to create server
    
    $url3 = '$endpoint/$custDDI/servers'
    $url3 = $ExecutionContext.InvokeCommand.ExpandString($url3)
    $request3 = Invoke-RestMethod -uri  $url3 -Method POST -Body $string2 -ContentType application/json -Headers $htoken
    $newserverid = $request3.server.id
    $adminpass = $request3.server.adminPass

    "Name: " + $newservername
    "Server ID: " + $newserverid
    "Admin Pass: " + $adminpass

    "Please wait while we get the IP"
    Start-Sleep -s 90
    #request to create server
    $url4 = '$endpoint/$custDDI/servers/$newserverID'
    $url4 = $ExecutionContext.InvokeCommand.ExpandString($url4)
    $request4 = Invoke-RestMethod -uri $url4 -Headers $htoken
    $newserver = $request4.server
    "name: "+ $newserver.name
    "status: "  + $newserver.status + " " + "progress: " + $newserver.progress
    "id: "+ $newserver.id
    "Public IP: "+ $newserver.addresses.public.addr
    "Private IP: "+ $newserver.addresses.private.addr
    "flavor: "+ $newserver.flavor.id + " metadata: " + $newserver.metadata
    return
    $sw.Stop()
        }


    else{
    
    #reqeust to get image status
    $request2 = Invoke-RestMethod -uri  $url2 -Headers $htoken

    $name = $request2.images.name
    $id = $request2.images.id
    $created = $request2.images.created
    $status = $request2.images.status
    $progress = $request2.images.progress
    write-host $status $progress}
        
    
    start-sleep -seconds 20
    }
 
write-host "Timed out"
$sw.Stop()
