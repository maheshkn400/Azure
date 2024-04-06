# Install Azure Powershell

The Az PowerShell module is a rollup module. Installing the Az PowerShell module downloads the generally available modules and makes their cmdlets available for use.

# Table of Content

[Install on Windows](#install-azure-powershell-on-windows)

[Install on Linux](#install-azure-powershell-on-linux)

[Install on macOS](#install-azure-powershell-on-macos)

## Install Azure PowerShell on Windows

The current version of Azure PowerShell is 11.5.0. For information about the latest release, see the

Prerequisites

Run the following command from PowerShell to determine your PowerShell version: minimum 5.1 or later require3d

`$PSVersionTable.PSVersion`

Or

Download Powershell from [Microsoft Official website](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#installing-the-msi-package)

### Installation

Launch Windows PowerShell 5.1 elevated as an administrator and run the following command to update PowerShellGet:

`Install-Module -Name PowerShellGet -Force`

### Set the PowerShell execution policy to remote signed or less restrictive

Check the PowerShell execution policy:

`Get-ExecutionPolicy -List`

Set the PowerShell execution policy to remote signed:

`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

Use the Install-Module cmdlet to install the Az PowerShell module:

`Install-Module -Name Az -Repository PSGallery -Force`

It will take 10 - 15 minutes

### Update the Azure PowerShell module

Use Update-Module to update to the latest version of the Az PowerShell module:

`Update-Module -Name Az -Force`


## Install Azure PowerShell on Linux

### Prerequisites

Install a supported version of [PowerShell version 7 or higher](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux)

Open the Terminal or other shell host application and run pwsh to start PowerShell.

### Installation

Use the Install-Module cmdlet to install the Az PowerShell module:

`Install-Module -Name Az -Repository PSGallery -Force`

### Update the Az PowerShell module

Use Update-Module to update to the latest version of the Az PowerShell module:

`Update-Module -Name Az -Force`


## Install Azure PowerShell on macOS

### Prerequisites

Install a supported version of [PowerShell version 7 or higher](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos)

### Installation

Open the Terminal or other shell host application and run pwsh to start PowerShell.

Use the Install-Module cmdlet to install the Az PowerShell module:

`Install-Module -Name Az -Repository PSGallery -Force`

### Update the Azure PowerShell module

Use the Update-Module cmdlet to update to the latest version of the Az PowerShell module.

`Update-Module -Name Az -Force`


## After Installion try to Sign in

To start managing your Azure resources with the Az PowerShell module, launch a PowerShell session and run Connect-AzAccount to sign in to Azure:

`Connect-AzAccount`

Use your Azure account login credentials to log into the browser window that opens.