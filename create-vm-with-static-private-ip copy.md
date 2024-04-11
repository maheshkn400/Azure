# Azure Powershell command to creation VM with static Private IP

## Create resource group.
$rg =@{
    Name = 'myResourceGroup'
    Location = 'eastus2'
}
New-AzResourceGroup @rg

## Create virtual machine. 

*By default, a Windows VM will be created with a new virtual network named myVM and a subnet named myVM with a Private IP address segment of 192.168.1.0/24.*

$vm = @{
    ResourceGroupName = 'myResourceGroup'
    Location = 'East US 2'
    Name = 'myVM'
    PublicIpAddressName = 'myPublicIP'
}
New-AzVM @vm

## Place virtual network configuration into a variable.
$net = @{
    Name = 'myVM'
    ResourceGroupName = 'myResourceGroup'
}
$vnet = Get-AzVirtualNetwork @net

## Place subnet configuration into a variable.
$sub = @{
    Name = 'myVM'
    VirtualNetwork = $vnet
}
$subnet = Get-AzVirtualNetworkSubnetConfig @sub

## Get name of network interface and place into a variable

$int1 = @{
    Name = 'myVM'
    ResourceGroupName = 'myResourceGroup'
}
$vm = Get-AzVM @int1

## Place network interface configuration into a variable

$nic = Get-AzNetworkInterface -ResourceId $vm.NetworkProfile.NetworkInterfaces.Id

## Set interface configuration.
$config =@{
    Name = 'myVM'
    PrivateIpAddress = '192.168.1.10'
    Subnet = $subnet
}
$nic | Set-AzNetworkInterfaceIpConfig @config -Primary

## Save interface configuration

$nic | Set-AzNetworkInterface