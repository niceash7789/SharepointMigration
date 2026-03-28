[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 100)]
    [int]$MaxParallelTasks = 3,

    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$MigrationRunbookName = 'Invoke-MigrationJob'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-DispatcherLog {
    param(
        [string]$Message,
        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Severity = 'INFO'
    )

    $timestamp = (Get-Date).ToUniversalTime().ToString('o')
    Write-Output "[$timestamp][$Severity][Dispatcher] $Message"
}

Write-DispatcherLog -Message 'Dispatcher started.'
Write-DispatcherLog -Message "MaxParallelTasks=$MaxParallelTasks; MigrationRunbookName=$MigrationRunbookName"
Write-DispatcherLog -Message 'Job selection from SharePoint list will be added in the next increment.' -Severity 'WARN'
Write-DispatcherLog -Message 'Dispatcher completed.'
