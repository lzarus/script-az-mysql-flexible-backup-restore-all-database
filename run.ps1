###UPDATE VARIABLE VALUES ACCORDING TO YOUR SETUP
$SubscriptionName=""
$SourceMysqlFlexible=""
$DestMysqlFlexible=""
$SourceResourcegroup=""
$DestResourcegroup=""
$KeyVaultName=""
$AdminMySqlSecretName=""

az login
az account set --subscription $SubscriptionName

$Timelastbackup = az mysql flexible-server backup list -g $SourceResourcegroup -n $SourceMysqlFlexible  --query "[?backupType=='FULL'].{Time:completedTime} | [0]" --output tsv
Write-Host "$Timelastbackup" 
# Check server if exists
az mysql flexible-server show --name $DestMysqlFlexible --resource-group $DestResourcegroup --query "name" --output tsv --only-show-errors
# Get Secret value
$secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $AdminMySqlSecretName -AsPlainText
# Delete flexible server Destination
az mysql flexible-server delete -n $DestMysqlFlexible -g $DestResourcegroup --yes
# Restore
az mysql flexible-server restore -n $DestMysqlFlexible -g $DestResourcegroup --restore-time $Timelastbackup --source-server $SourceMysqlFlexible
#Update Admin password
az mysql flexible-server update -g $DestResourcegroup -n $DestMysqlFlexible --admin-password $secret