[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$TenantId,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Location,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$AutomationAccountName,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^https://')]
    [string]$SharePointSiteUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$infraTemplatePath = Join-Path $repoRoot 'infra/main.bicep'
$configPath = Join-Path $repoRoot 'config/settings.default.json'

if (-not (Test-Path -Path $infraTemplatePath)) {
    throw "Infra template not found at: $infraTemplatePath"
}

if (-not (Test-Path -Path $configPath)) {
    throw "Settings file not found at: $configPath"
}

$null = Get-Command -Name New-AzResourceGroup -ErrorAction Stop
$null = Get-Command -Name New-AzResourceGroupDeployment -ErrorAction Stop

Write-Host "Selecting subscription $SubscriptionId"
Select-AzSubscription -SubscriptionId $SubscriptionId -Tenant $TenantId

Write-Host "Ensuring resource group '$ResourceGroupName' in '$Location'"
New-AzResourceGroup -Name $ResourceGroupName -Location $Location -Force | Out-Null

Write-Host 'Deploying core infrastructure from infra/main.bicep'
$deployment = New-AzResourceGroupDeployment `
    -Name "sharepoint-migration-$(Get-Date -Format 'yyyyMMddHHmmss')" `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $infraTemplatePath `
    -location $Location `
    -automationAccountName $AutomationAccountName

Write-Host 'Deployment complete. Basic environment scaffold is ready.'
[pscustomobject]@{
    ResourceGroupName     = $ResourceGroupName
    Location              = $Location
    AutomationAccountName = $deployment.Outputs.automationAccountName.value
    SharePointSiteUrl     = $SharePointSiteUrl
    SettingsPath          = $configPath
}
