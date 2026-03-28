[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^https://')]
    [string]$SharePointSiteUrl,

    [switch]$RemoveSharePointArtifacts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$null = Get-Command -Name Remove-AzResourceGroup -ErrorAction Stop

if ($PSCmdlet.ShouldProcess($ResourceGroupName, 'Remove Azure resource group')) {
    Write-Host "Removing resource group '$ResourceGroupName'"
    Remove-AzResourceGroup -Name $ResourceGroupName -Force
}

if ($RemoveSharePointArtifacts) {
    Write-Warning "SharePoint artifact removal is not yet implemented. Requested site: $SharePointSiteUrl"
}

Write-Host 'Teardown command completed.'
