# Azure using Powershell Create a virtual machine with both private and public IP addresses assigned to a single NIC interface.

## Creating Resource Group

`$rg =@{
    Name = 'myResourceGroup'
    Location = 'eastus2'
}
New-AzResourceGroup @rg`

## Create backend subnet config

`$subnet = @{
    Name = 'myBackendSubnet'
    AddressPrefix = '10.1.0.0/24'
}
$subnetConfig = New-AzVirtualNetworkSubnetConfig @subnet`

## Create the virtual network

`$vnet = @{
    Name = 'myVNet'
    ResourceGroupName = 'myResourceGroup'
    Location = 'eastus2'
    AddressPrefix = '10.1.0.0/16'
    Subnet = $subnetConfig
}
New-AzVirtualNetwork @vnet`

## Create a primary public IP address

`$ip1 = @{
    Name = 'myPublicIP-1'
    ResourceGroupName = 'myResourceGroup'
    Location = 'eastus2'
    Sku = 'Standard'
    AllocationMethod = 'Static'
    IpAddressVersion = 'IPv4'
    Zone = 1,2,3
}
New-AzPublicIpAddress @ip1`

## Create rule for network security group and place in variable.
*If using Windows VM allow 3389 port*

`$nsgrule1 = @{
    Name = 'myNSGRuleSSH'
    Description = 'Allow SSH'
    Protocol = '*'
    SourcePortRange = '*'
    DestinationPortRange = '22'
    SourceAddressPrefix = 'Internet'
    DestinationAddressPrefix = '*'
    Access = 'Allow'
    Priority = '200'
    Direction = 'Inbound'
}
$rule1 = New-AzNetworkSecurityRuleConfig @nsgrule1`

## Create network security group

`$nsg = @{
    Name = 'myNSG'
    ResourceGroupName = 'myResourceGroup'
    Location = 'eastus2'
    SecurityRules = $rule1
}
New-AzNetworkSecurityGroup @nsg`

## Place the virtual network into a variable.

`$net = @{
    Name = 'myVNet'
    ResourceGroupName = 'myResourceGroup'
}
$vnet = Get-AzVirtualNetwork @net`

## Place the network security group into a variable.

`$ns = @{
    Name = 'myNSG'
    ResourceGroupName = 'myResourceGroup'
}
$nsg = Get-AzNetworkSecurityGroup @ns`

## Place the primary public IP address into a variable.

`$pub1 = @{
    Name = 'myPublicIP-1'
    ResourceGroupName = 'myResourceGroup'
}
$pubIP1 = Get-AzPublicIPAddress @pub1`

## Create a primary IP configuration for the network interface.

`$IP1 = @{
    Name = 'ipconfig1'
    Subnet = $vnet.Subnets[0]
    PrivateIpAddressVersion = 'IPv4'
    PublicIPAddress = $pubIP1
}
$IP1Config = New-AzNetworkInterfaceIpConfig @IP1 -Primary`

## Create a secondary IP configuration for the network interface.

`$IP3 = @{
    Name = 'ipconfig3'
    Subnet = $vnet.Subnets[0]
    PrivateIpAddressVersion = 'IPv4'
    PrivateIpAddress = '10.1.0.6'
}
$IP3Config = New-AzNetworkInterfaceIpConfig @IP3`

## Command to create a network interface.

`$nic = @{
    Name = 'myNIC1'
    ResourceGroupName = 'myResourceGroup'
    Location = 'eastus2'
    NetworkSecurityGroup = $nsg
    IpConfiguration = $IP1Config,$IP3Config
}
New-AzNetworkInterface @nic`

## Create a virtual machine

`$cred = Get-Credential`

### Place network interface into a variable.

`$nic = @{
    Name = 'myNIC1'
    ResourceGroupName = 'myResourceGroup'
}
$nicVM = Get-AzNetworkInterface @nic`

### Create a virtual machine configuration for VMs

`$vmsz = @{
    VMName = 'myVM'
    VMSize = 'Standard_DS1_v2'
}
$vmos = @{
    ComputerName = 'myVM'
    Credential = $cred
}
$vmimage = @{
    PublisherName = 'Debian'
    Offer = 'debian-11'
    Skus = '11'
    Version = 'latest'
}
$vmConfig = New-AzVMConfig @vmsz | Set-AzVMOperatingSystem @vmos -Linux | Set-AzVMSourceImage @vmimage | Add-AzVMNetworkInterface -Id $nicVM.Id`

### Create the virtual machine for VMs

`$vm = @{
    ResourceGroupName = 'myResourceGroup'
    Location = 'eastus2'
    VM = $vmConfig
    SshKeyName = 'mySSHKey'
    }
New-AzVM @vm -GenerateSshKey`