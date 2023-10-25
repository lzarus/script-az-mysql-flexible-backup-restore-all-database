# ### UPDATE NAME AND VALUE IN PIPELINE VARIABLES OR LOCALS VALUES
# SourceMysqlFlexibleName
# DestMysqlFlexibleName
# SourceResourcegroupName
# DestResourcegroupName
# MysqlAdminPassword #Update name secret if from keyvault

function Get-LastBackupTime ($ResourceGroup,$ServerName){
    $backupTime = az mysql flexible-server backup list -g $ResourceGroup -n $ServerName --query "[?backupType=='FULL'].{Time:completedTime} | [0]" --output tsv
    return $backupTime
}
Write-Host "Source : $(SourceResourcegroupName) , $(SourceMysqlFlexibleName)"
Write-Host "Destination : $(DestResourcegroupName) , $(DestMysqlFlexibleName)"
$serverExists = az mysql flexible-server show --name $(DestMysqlFlexibleName) --resource-group $(DestResourcegroupName) --query "name" --output tsv --only-show-errors

if ($serverExists) {
    Write-Host "The destination MySQL flexible server exists. Attempt to delete... Run restore script and update administrator password."
    # GET last time backup
    $Timelastbackup = Get-LastBackupTime -ResourceGroup $(SourceResourcegroupName) -ServerName $(SourceMysqlFlexibleName)
    Write-Host "Last backup was run at $Timelastbackup"
    # Delete Dest Server
    az mysql flexible-server delete -n $(DestMysqlFlexibleName) -g $(DestResourcegroupName) --yes
    Write-Host "Delete successfully"
    # Restore
    Write-Host "Run restore ...."
    Write-Host "Restore source-server $SourceMysqlFlexibleName backuptime $Timelastbackup to $DestMysqlFlexibleName at $SourceResourcegroupName "
    Write-Host "az mysql flexible-server restore -n $DestMysqlFlexibleName -g $SourceResourcegroupName --restore-time $Timelastbackup --source-server $SourceMysqlFlexibleName"
    az mysql flexible-server restore -n $DestMysqlFlexibleName -g $SourceResourcegroupName --restore-time $Timelastbackup --source-server $SourceMysqlFlexibleName
    # If you have a problem on ZoneAvailbility, set directly a Zone, comment line above and run decomment this 
    # az mysql flexible-server restore -n $DestMysqlFlexibleName -g $SourceResourcegroupName --restore-time $Timelastbackup --source-server $SourceMysqlFlexibleName  --zone 2
    Write-Host "Restore successfully"

    # Update Admin password
    Write-Host "update admin password on new DB server ...."
    az mysql flexible-server update -g $SourceResourcegroupName -n $DestMysqlFlexibleName --admin-password  $MysqlAdminBenchPassword
    Write-Host "Successful updating Admin Password."

} else {
    Write-Host "The destination MySQL flexible server does not exist or an error has occurred"
}
