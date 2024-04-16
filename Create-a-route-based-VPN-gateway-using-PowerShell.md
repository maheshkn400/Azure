# Create a route-based VPN gateway using PowerShell

This article helps you quickly create a route-based Azure VPN gateway using PowerShell. A VPN gateway is used when creating a VPN connection to your on-premises network. You can also use a VPN gateway to connect VNets.

A VPN gateway is just one part of a connection architecture to help you securely access resources within a virtual network.

### Create a resource group

`New-AzResourceGroup -Name TestRG1 -Location EastUS`

### Create a virtual network

Create a virtual network with New-AzVirtualNetwork. The following example creates a virtual network named VNet1 in the EastUS location:

`$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName TestRG1 -Location EastUS -Name VNet1 -AddressPrefix 10.1.0.0/16`

Create a subnet configuration using the New-AzVirtualNetworkSubnetConfig cmdlet.

`$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $virtualNetwork`

Set the subnet configuration for the virtual network using the Set-AzVirtualNetwork cmdlet.

`$virtualNetwork | Set-AzVirtualNetwork`

### Add a gateway subnet

The gateway subnet contains the reserved IP addresses that the virtual network gateway services use. Use the following examples to add a gateway subnet:

Set a variable for your VNet.

`$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1`

Create the gateway subnet using the Add-AzVirtualNetworkSubnetConfig cmdlet.

`Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet`

Set the subnet configuration for the virtual network using the Set-AzVirtualNetwork cmdlet.

`$vnet | Set-AzVirtualNetwork`

### Request a public IP address

The gateway configuration defines the subnet and the public IP address to use. Use the following example to create your gateway configuration:

`$vnet = Get-AzVirtualNetwork -Name VNet1 -ResourceGroupName TestRG1
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id`

## Create the VPN gateway

Creating a gateway can often take 45 minutes or more, depending on the selected gateway SKU. Once the gateway has completed, you can create a connection between your virtual network and another VNet. Or, create a connection between your virtual network and an on-premises location. Create a VPN gateway using the New-AzVirtualNetworkGateway cmdlet.

`New-AzVirtualNetworkGateway -Name VNet1GW -ResourceGroupName TestRG1 -Location "East US" -IpConfigurations $gwipconfig -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku VpnGw2 -VpnGatewayGeneration "Generation2"`

### View the VPN gateway

`Get-AzVirtualNetworkGateway -Name Vnet1GW -ResourceGroup TestRG1`

### View the public IP address

`Get-AzPublicIpAddress -Name VNet1GWIP -ResourceGroupName TestRG1`


## Configure server settings for P2S VPN certificate authentication - PowerShell

This article helps you configure a point-to-site (P2S) VPN to securely connect individual clients running Windows, Linux, or macOS to an Azure virtual network (VNet). P2S VPN connections are useful when you want to connect to your VNet from a remote location, such when you're telecommuting from home or a conference.

You can also use P2S instead of a Site-to-Site VPN when you have only a few clients that need to connect to a VNet. P2S connections don't require a VPN device or a public-facing IP address. P2S creates the VPN connection over either SSTP (Secure Socket Tunneling Protocol), or IKEv2.

### Add the VPN client address pool

After the VPN gateway finishes creating, you can add the VPN client address pool. The VPN client address pool is the range from which the VPN clients receive an IP address when connecting. Use a private IP address range that doesn't overlap with the on-premises location that you connect from, or with the VNet that you want to connect to.

1. Declare the following variables:

`$VNetName  = "VNet1"
$VPNClientAddressPool = "172.16.201.0/24"
$RG = "TestRG1"
$Location = "EastUS"
$GWName = "VNet1GW"`

2. Add the VPN client address pool:

`$Gateway = Get-AzVirtualNetworkGateway -ResourceGroupName $RG -Name $GWName
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $Gateway -VpnClientAddressPool $VPNClientAddressPool`

### Generate certificates

Open Powershell and enter the following commands to generate Root and Child SSL certificats. /br _( We can use the organization's domain certification in real time, which comes from certificates offered by services from Digicet, Godaddy, and others.)_

**Generate a Root Certificate**

`$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
`-Subject "CN=P2SRootCert" -KeyExportPolicy Exportable `
`-HashAlgorithm sha256 -KeyLength 2048 `
`-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign`

**Generate a Child Certificate**

`New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert -KeySpec Signature `
`-Subject "CN=P2SChildCert" -KeyExportPolicy Exportable `
`-HashAlgorithm sha256 -KeyLength 2048 `
`-CertStoreLocation "Cert:\CurrentUser\My" `
`-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")`

**Export root certificate**

Enter following in run command

`certmgr.msc`

After open Manage user certificates. The client certificates that you generated are, by default, located in 'Certificates - Current User\Personal\Certificates'. Right-click the root certificate that you want to export, click all tasks, and then click Export to open the Certificate Export Wizard.

![img](/img/vpn-gateway/root-cert2.png)

Click Next Button

![img](/img/vpn-gateway/root-cert3.png)

Select 'Base-64 encoded X.509 (.CER)' and click next button

![img](/img/vpn-gateway/root-cert4.png)

Choose the file name and save path as you wish. In my case, I selected 'c:\cert' as the path and 'P2SRootCert.cer' as the file name.

![img](/img/vpn-gateway/root-cert5.png)
![img](/img/vpn-gateway/root-cert6.png)

Click the Finish button to save the file.

![img](/img/vpn-gateway/root-cert7.png)

## Upload root certificate public key information

Declare the variable for your certificate name, replacing the value with your own.

`$P2SRootCertName = "P2SRootCert.cer"`

Replace the file path with your own, and then run the cmdlets.

`$filePathForCert = "C:\cert\P2SRootCert.cer"
$cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2($filePathForCert)
$CertBase64 = [system.convert]::ToBase64String($cert.RawData)`

Upload the public key information to Azure. 

`Add-AzVpnClientRootCertificate -VpnClientRootCertificateName $P2SRootCertName -VirtualNetworkGatewayname "VNet1GW" -ResourceGroupName "TestRG1" -PublicCertData $CertBase64`

**Download the VPN Client**

Go to the gateway you created in the previous section.

In the left pane, select Point-to-site configuration.

And click 'Download VPN client', install VPN client and test the connect by create VM in VNet1

![img](/img/vpn-gateway/root-cert8.png)

## Clean up resources

Delete the resource group when the resources you created are no longer needed. By doing this, the resource group and all of its resources are removed. in order to prevent overbilling.

`Remove-AzResourceGroup -Name TestRG1`
