<#
.DESCRIPTION
This is a Powershell script that builds a devops cli container. The built container includes azure-cli, terraform, kubectl and helm.
.PARAMETER ALPINE_VERSION
The Alpine linux container version to use when building terraform.
.PARAMETER TERRAFORM_VERSION
The version of terraform to build and include in the image.
.PARAMETER AZURE_CLI_VERSION
The version of the Azure cli to build and include in the image.
\
#>

[CmdletBinding()]
Param(
    [string]$ALPINE_VERSION = "3.11.6",
    [string]$TERRAFORM_VERSION = "0.12.24",
    [string]$AZURE_CLI_VERSION = "2.5.1",
    [Parameter(Position=0,Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

Write-Host "Running build script..."

docker build -f Dockerfile --build-arg ALPINE_VERSION=$ALPINE_VERSION --build-arg TERRAFORM_VERSION=$TERRAFORM_VERSION --build-arg AZURE_CLI_VERSION=$AZURE_CLI_VERSION -t ryanmcafee/devops-cli .

Write-Host "Completed building container!"

exit $LASTEXITCODE