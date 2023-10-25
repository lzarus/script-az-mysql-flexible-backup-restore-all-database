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
if (!$serverExistsDest) {
    Write-Host "The destination MySQL flexible server not exists. Attempt to move"
    Write-Host "Get ID server"

    # GetID newDB
    $DestMysqlFlexibleNameID = $(az resource show --resource-group $SourceResourcegroupName --name $DestMysqlFlexibleName --resource-type "Microsoft.DBforMySQL/flexibleServers" --query id --output tsv)
    Write-Host "ID : $DestMysqlFlexibleNameID"

    # Move server
    az resource move --destination-group $DestResourcegroupName --ids $DestMysqlFlexibleNameID

}
else {
    Write-Host "The destination MySQL flexible server already exist or an error has occurred"
    exit 1
}