# Azure Powershell command to Create VirtualNetwork Peering

## Creating resource group name 'rg1' at location 'eastus' 

New-AzResourceGroup -name rg1 -location eastus

## Creating virtual network name vnet1 with addressprefix '10.0.0.0/16'

$vnet1 = New-AzVirtualNetwork -ResourceGroupName rg1 -Location EastUS -Name vnet1 -AddressPrefix 10.0.0.0/16

## Creating subnet for vnet1 with addressprefix '10.0.0.0/24'

$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name vnet1-subnet1 -AddressPrefix 10.0.0.0/24 -VirtualNetwork $vnet1

## Write the subnet configuration to the virtual network vnet1

$vnet1 | Set-AzVirtualNetwork

## Creating virtual network name vnet2 with addressprefix '10.1.0.0/16'

$vnet2 = New-AzVirtualNetwork -ResourceGroupName rg1 -Location EastUS -Name vnet2 -AddressPrefix 10.1.0.0/16

## Creating subnet for vnet2 with addressprefix '10.1.0.0/24'

$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name vnet2-subnet1 -AddressPrefix 10.1.0.0/24 -VirtualNetwork $vnet2

## Write the subnet configuration to the virtual network vnet2

$vnet2 | Set-AzVirtualNetwork

## Checking resources in 'rg1' resource group

Get-AzResource -ResourceGroupName rg1

## Creating Peering

Add-AzVirtualNetworkPeering -Name vnet1-vnet2 -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.Id

Add-AzVirtualNetworkPeering -Name vnet2-vnet1 -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.Id

## Checking Peering status

Get-AzVirtualNetworkPeering -ResourceGroupName rg1 -VirtualNetworkName vnet1 | Select PeeringState

Get-AzVirtualNetworkPeering -ResourceGroupName rg1 -VirtualNetworkName vnet2 | Select PeeringState

## Creating VM 

New-AzVm -ResourceGroupName "rg1" -Location "East US" -VirtualNetworkName "vnet1" -SubnetName "vnet1-subnet1" -ImageName "Ubuntu2204" -Name "vm-vnet1-subnet1"

New-AzVm -ResourceGroupName "rg1" -Location "East US" -VirtualNetworkName "vnet2" -SubnetName "vnet2-subnet1" -ImageName "Ubuntu2204" -Name "vm-vnet2-subnet1"

*Create VM's in each VirtualNetwork's and try to ping each other*

remove-azresourcegroup -name rg1 ; remove-azresourcegroup -name NetworkwatcherRG