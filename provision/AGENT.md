# /provision AGENT Guide

## What belongs here
- Operator-facing setup scripts to prepare a usable environment.
- Scripts that orchestrate infra deployment, runbook import/publish, schedule setup, and SharePoint artifact provisioning.
- Teardown helpers for decommissioning.

## What does not belong here
- Core migration runtime logic.
- Detailed infra resource definitions better kept in `/infra`.
- General-purpose docs.

## Naming
- Use `Verb-Noun.ps1` naming.
- Recommended entry points:
  - `Deploy-Environment.ps1`
  - `Initialize-SharePointArtifacts.ps1`
  - `Register-AutomationRunbooks.ps1`
  - `Remove-Environment.ps1`

## Standards
- Scripts must be non-interactive by default and automation-friendly.
- Expose parameters for tenant/environment specifics.
- Validate prerequisites early and fail clearly.
- Keep deployment as hands-off as possible.
- Prefer re-runnable setup with safe idempotent checks.

## Environment rules
- Default deployment target is a dedicated resource group.
- Assume this tool is temporary: setup should be fast and teardown complete.
