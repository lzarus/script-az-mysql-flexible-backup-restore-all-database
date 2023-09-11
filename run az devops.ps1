# ### UPDATE NAME AND VALUE IN PIPELINE VARIABLES
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
    az mysql flexible-server restore -n $(DestMysqlFlexibleName) -g $(DestResourcegroupName) --restore-time $Timelastbackup --source-server $(SourceMysqlFlexibleName)
    Write-Host "Restore successfully"
    # Update Admin password
    az mysql flexible-server update -g $(DestResourcegroupName) -n $(DestMysqlFlexibleName) --admin-password  $(MysqlAdminPassword)
    Write-Host "Successful updating Admin Password."

} else {
    Write-Host "The destination MySQL flexible server does not exist or an error has occurred"
}
