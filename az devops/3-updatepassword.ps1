
[CmdletBinding()]
param (
    [string]$SourceResourcegroupName,
    [string]$SourceMysqlFlexibleName,
    [string]$DestResourcegroupName,
    [string]$DestMysqlFlexibleName,
    [String]$MysqlAdminBenchPassword
)

Write-Host "Source : $SourceResourcegroupName , $SourceMysqlFlexibleName"
Write-Host "Destination : $DestResourcegroupName , $DestMysqlFlexibleName)"

$serverExists = az mysql flexible-server show --name $DestMysqlFlexibleName --resource-group $SourceResourcegroupName --query "name" --output tsv --only-show-errors
if ($serverExists) {
    # Update Admin password
    Write-Host "update admin password on new DB server ...."
    az mysql flexible-server update -g $SourceResourcegroupName -n $DestMysqlFlexibleName --admin-password  $MysqlAdminBenchPassword
    Write-Host "Successful updating Admin Password."
    }
    else {
        Write-Host "The Source MySQL flexible server $DestMysqlFlexibleName  does not exist or an error has occurred"
    }