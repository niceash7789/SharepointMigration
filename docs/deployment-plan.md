# Deployment Plan (One-Command Model)

## Objective
Provide a hands-off deployment that creates a ready-to-use temporary migration environment in its own resource group.

## Expected operator flow
1. Download/clone repository.
2. Run one setup command.
3. Wait for completion.
4. Open SharePoint lists and start creating jobs.

## Proposed entry point
Primary setup command (target):

```powershell
pwsh ./provision/Deploy-Environment.ps1 \
  -SubscriptionId <subscription-id> \
  -TenantId <tenant-id> \
  -ResourceGroupName <rg-name> \
  -Location <azure-region> \
  -AutomationAccountName <automation-name> \
  -SharePointSiteUrl <sharepoint-site-url>
```

## What the setup script must do
### 1) Prerequisite checks
- PowerShell version is 7.4.
- Required modules are available (including PnP PowerShell and Azure modules used by scripts).
- Caller has required Azure and SharePoint permissions.

### 2) Deploy infra into dedicated resource group
- Create/validate resource group.
- Create/validate Automation Account.
- Create/validate supporting assets (variables/schedules/log settings as required).

### 3) Configure authentication assets
- Configure non-interactive auth assets for runbooks.
- Store auth material in Automation assets (not in repository).
- Validate SharePoint connectivity using PnP PowerShell.

### 4) Provision SharePoint artifacts
- Create/validate lists:
  - Migration Jobs
  - Migration Logs
  - Migration Settings
- Create/validate all required fields.
- Seed required settings values.

### 5) Upload/import/publish runbooks
- Import runbook scripts from `/runbooks`.
- Publish runbooks.
- Validate runtime version targets (PowerShell 7.4 where applicable).

### 6) Configure schedules and links
- Create dispatcher polling schedule.
- Link schedule to dispatcher runbook.
- Set default polling cadence from settings (`PollIntervalSeconds`).

### 7) Post-deployment validation
- Confirm runbooks exist and are published.
- Confirm SharePoint lists/fields/settings exist.
- Execute a non-destructive connectivity/health check.

## Output from setup
On success, output at minimum:
- Resource group name
- Automation account name
- SharePoint site URL
- Dispatcher schedule details
- Next operational steps for operators

## Failure handling expectations
- Fail fast with explicit error context.
- Do not leave ambiguous partial state without reporting created assets.
- Support safe rerun after corrective action.

## Decommission path
Provide teardown command (target):

```powershell
pwsh ./provision/Remove-Environment.ps1 \
  -ResourceGroupName <rg-name> \
  -SharePointSiteUrl <sharepoint-site-url> \
  -RemoveSharePointArtifacts
```

Teardown removes dedicated Azure resources and optionally removes SharePoint artifacts.
