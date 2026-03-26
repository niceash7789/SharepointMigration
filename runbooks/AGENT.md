# /runbooks AGENT Guide

## What belongs here
- Azure Automation runbook scripts (PowerShell 7.4).
- Shared runbook helper modules/functions used only by runbooks.
- Runtime polling, dispatch, migration execution, verification, and status update logic.

## What does not belong here
- Infrastructure provisioning templates.
- One-time setup/bootstrap scripts.
- Generic docs not directly tied to runbook behavior.

## Naming
- Use `Verb-Noun.ps1` for runbook files.
- Suggested v1 names:
  - `Invoke-MigrationDispatcher.ps1`
  - `Invoke-MigrationJob.ps1`
  - `Write-MigrationLog.ps1` (if kept as helper runbook/script)
- Helper files can use suffixes like `.helpers.ps1` or `.module.psm1`.

## Standards
- Preserve behavior of the existing migration script as baseline.
- Keep logic simple; avoid over-modularizing in v1.
- Non-interactive execution only.
- Jobs must run only when `ScheduledStart <= now`.
- Polling cadence is schedule-driven in Azure Automation (no webhooks).
- Use PnP PowerShell for SharePoint interactions.
- Emit structured, consistent log messages for SharePoint list logging.

## Environment rules
- Target PowerShell 7.4 runtime in Azure Automation.
- Assume automation identity has required SharePoint permissions for temporary-tool operation.
