## Connect, login and logout to az 

Connect-AzAccount

Login-AzAccount

Logout-AzAccount

## List all subscriptions in all tenants the account can access

Get-AzSubscription

## List / show resourcegroups

Get-AzResourceGroup 

## Get a specific resource group by name

Get-AzResourceGroup -Name "rg-proj1”

## Get resource groups where the name begins with "Production"

Get-AzResourceGroup | Where ResourceGroupName -like rg-proj*

## Show resource groups by location

Get-AzResourceGroup | Sort Location,ResourceGroupName | Format-Table -GroupBy Location ResourceGroupName,ProvisioningState,Tags

### Resources within RGs

## Find resources of a type in resource groups with a specific name

Get-AzResource -ResourceGroupName "myResourceGroup"

## Find resources of a type matching against the resource name string

Get-AzResource -ResourceType
"microsoft.web/sites" -ResourceGroupName
"myResourceGroup"


### Resource Group Provisioning & Management

## Create a new Resource Group

New-AzResourceGroup -Name 'RG-PROJ1' -Location 'eastus'

## Delete a Resource Group

Remove-AzResourceGroup -Name "RG-PROJ1"

### Lock the resource group

## Get all resource groups lock details

Get-AzResourceLock

## read only 

New-AzResourceLock -LockName "pscmdrglock" -LockLevel ReadOnly -LockNotes "Creating RG lock via PS shell cmd" -ResourceGroupName "RG-PROJ2"

## modify / change above lock 

Set-AzResourceLock -LockName pscmdrglock -LockLevel CanNotDelete -LockNotes "set the lock from ps shell cmd modified from readonly to delete" -ResourceGroupName RG-PROJ2

### Moving Resources from One Resource Group to Another

## Step 1: Retrieve existing Resource

$Resource = Get-AzResource -ResourceType
"Microsoft.ClassicCompute/storageAccounts" - #Retrieves a storage account called  "myStorageAccount"
ResourceName "myStorageAccount" 


## Step 2: Move the Resource to the New Group

Move-AzResource -ResourceId
$Resource.ResourceId -DestinationResourceGroupName " "

## get all type resources in resourcegroup

Get-AzResource -ResourceGroupName rg-proj1


### Create storage account

## Create storage account method one

New-AzStorageAccount -ResourceGroupName
“RG-PROJ1” -Name “mknsa1” -Location
“eastus” -SkuName “Standard_LRS”

## method 2 create storageaccount 

$ResourceGroupName="rg-proj2"
$Name="mknsa4"
$Location="eastus"

New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $Name -Location $Location -SkuName Standard_LRS


## list / show storageaccounts in resourcegroup

Get-AzStorageAccount -ResourceGroupName rg-proj1

## Delete a storage account

Remove-AzStorageAccount -ResourceGroupName "RG-PROJ1" -Name "mknsa1"


