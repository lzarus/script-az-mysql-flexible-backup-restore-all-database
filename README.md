# script-az-mysql-flexible-backup-restore-all-database
## MySQL Flexible Server Restoration Script
# Automated MySQL Flexible Server Restoration

## Introduction

This guide presents a PowerShell script that automates the restoration of an Azure MySQL Flexible Server database from a production environment to a pre-production environment.
You can run this script on Azure devops pipelines

### Prerequisites

Before using this script, ensure you have the Azure CLI installed and logged in. 

### Variables

Make sure to update the following pipeline variables in your Azure Pipelines environment or provide values directly in the script:

- `SourceMysqlFlexibleName`: The name of the MySQL Flexible Server instance to restore from.
- `DestMysqlFlexibleName`: The desired name of the restored MySQL Flexible Server instance.
- `SourceResourcegroupName`: The name of the resource group where the source MySQL Flexible Server is located.
- `DestResourcegroupName`: The name of the resource group where the restored MySQL Flexible Server will be created.
- `MysqlAdminPassword`: The password for the admin user of the MySQL Flexible Server. You can update the name of the secret if the password is stored in Azure Key Vault.

### Execution 

1. Clone this repository to your local environment.
2. Navigate to the script directory.
3. Run the script using the Azure CLI (ensure you are logged in).
4. Follow the prompts to enter the required details.

### Script Workflow

1. The script checks if the destination MySQL Flexible Server exists. If it does, the script proceeds with the restoration process. Otherwise, it displays an error message.
2. The script retrieves the timestamp of the last backup from the source MySQL Flexible Server.
3. If the destination MySQL Flexible Server exists, it is deleted.
4. The script performs the restoration of the source MySQL Flexible Server to the destination MySQL Flexible Server using the specified backup timestamp.
5. The admin password of the destination MySQL Flexible Server is updated.
6. The script completes successfully.

### Outputs

- The script provides feedback on the execution, including success messages and error messages if applicable.