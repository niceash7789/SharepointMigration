# Implementation Phases

This plan keeps scope controlled and aligned to the baseline script behavior.

## Phase 1: Architecture and documentation
Deliverables:
- AGENT guidance files.
- Architecture and mapping docs.
- SharePoint list design.
- Deployment and phased implementation plan.

Exit criteria:
- Repo guidance is clear.
- v1 scope boundaries are explicit.
- Baseline behavior preservation rule is documented.

## Phase 2: Provisioning foundation
Deliverables:
- `/infra` assets for required Azure resources.
- `/provision/Deploy-Environment.ps1` orchestration script.
- `/provision/Remove-Environment.ps1` teardown script.

Exit criteria:
- One-command deployment creates Azure foundation in dedicated resource group.
- Teardown removes deployed Azure resources reliably.

## Phase 3: Auth and setup
Deliverables:
- Non-interactive auth setup for Automation -> SharePoint access using PnP PowerShell.
- SharePoint list/field provisioning scripts.
- Migration Settings seed script.

Exit criteria:
- Runbook context can authenticate to SharePoint without prompts.
- Required lists and fields exist and are validated.

## Phase 4: Runbooks
Deliverables:
- Dispatcher runbook.
- Migration execution runbook wrapping baseline script behavior.
- Shared helper functions/modules only where they reduce duplication safely.

Exit criteria:
- Dispatcher runs on schedule and selects only eligible jobs (`ScheduledStart <= now`).
- Migration execution reproduces baseline behavior for core scenarios.
- Job status and logs update correctly in SharePoint.

## Phase 5: Monitoring and operations
Deliverables:
- Standardized log schema usage in Migration Logs.
- Automation job monitoring guidance.
- Optional Log Analytics integration scripts/config.

Exit criteria:
- Operators can diagnose job outcomes from SharePoint and Automation history.
- Failures provide actionable context.

## Phase 6: Teardown and closure
Deliverables:
- Finalized teardown script behavior.
- Data export guidance (if required before decommission).
- Decommission checklist.

Exit criteria:
- Environment can be cleanly decommissioned.
- No required runtime components remain orphaned.

## Change-control rule across all phases
If a phase introduces behavior changes relative to the existing migration script, those changes must be:
1. Explicitly approved.
2. Documented in mapping docs.
3. Validated against representative migration scenarios.
