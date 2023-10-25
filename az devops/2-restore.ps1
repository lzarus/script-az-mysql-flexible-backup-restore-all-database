[CmdletBinding()]
param (
    [string]$SourceResourcegroupName,
    [string]$SourceMysqlFlexibleName,
    [string]$DestResourcegroupName,
    [string]$DestMysqlFlexibleName
)
function Get-LastBackupTime ($ResourceGroup,$ServerName){
    $backupTime = az mysql flexible-server backup list -g $ResourceGroup -n $ServerName --query "[?backupType=='FULL'].{Time:completedTime} | [0]" --output tsv
    return $backupTime
}
Write-Host "Source : $SourceResourcegroupName , $SourceMysqlFlexibleName"
Write-Host "Destination : $DestResourcegroupName , $DestMysqlFlexibleName)"
$serverExistsSource = az mysql flexible-server show --name $SourceMysqlFlexibleName --resource-group $SourceResourcegroupName --query "name" --output tsv --only-show-errors
$serverExistsRestore = az mysql flexible-server show --name $DestMysqlFlexibleName --resource-group $SourceResourcegroupName --query "name" --output tsv --only-show-errors
if ($serverExistsSource -And !$serverExistsRestore) {
    Write-Host "The Source MySQL flexible server exists. Attempt to restore."
    # GET last time backup
    $Timelastbackup = Get-LastBackupTime -ResourceGroup $SourceResourcegroupName -ServerName $SourceMysqlFlexibleName
    Write-Host "Last backup was run at $Timelastbackup"

    # Restore
    Write-Host "Run restore ...."
    Write-Host "Restore source-server $SourceMysqlFlexibleName backuptime $Timelastbackup to $DestMysqlFlexibleName at $SourceResourcegroupName "
    az mysql flexible-server restore -n $DestMysqlFlexibleName -g $SourceResourcegroupName --restore-time $Timelastbackup --source-server $SourceMysqlFlexibleName  --zone 2
    Write-Host "Restore successfully"


} else {
    Write-Host "The Source MySQL flexible server $DestMysqlFlexibleName  already exist or an error has occurred"
    exit 1
}