   
[CmdletBinding()]
param (
    [string]$SourceResourcegroupName,
    [string]$SourceMysqlFlexibleName,
    [string]$DestResourcegroupName,
    [string]$DestMysqlFlexibleName
)

Write-Host "Source : $SourceResourcegroupName , $SourceMysqlFlexibleName"
Write-Host "Destination : $DestResourcegroupName , $DestMysqlFlexibleName)"
$serverExistsDest = az mysql flexible-server show --name $DestMysqlFlexibleName --resource-group $DestResourcegroupName --query "name" --output tsv --only-show-errors
if ($serverExistsDest) {
    # Delete Dest Server before Restore
    Write-Host "Delete Server $DestMysqlFlexibleName"
    az mysql flexible-server delete -n $DestMysqlFlexibleName -g $DestResourcegroupName --yes
    Write-Host "Delete $DestMysqlFlexibleName successfully"
}
else {
    Write-Host "The MySQL flexible server $DestMysqlFlexibleName does not exist or an error has occurred"
}
