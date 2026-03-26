# Current Script Mapping

## Purpose
This document maps the existing migration script (current working implementation) to the target v1 architecture.

Rule: the existing script remains the migration behavior baseline.

## 1) What the current script does (behavioral summary)
The current script is assumed to perform these functional stages:
1. Read migration input parameters (source/destination paths and options).
2. Start migration operation.
3. Poll/track progress.
4. Apply fallback behavior when primary path is insufficient.
5. Verify completion state (including remaining item checks).
6. Emit status/error output.

This staged behavior should be preserved in runbookized form.

## 2) Mapping to future components
### A) SharePoint lists (state/config)
- Script input parameters map to **Migration Jobs** fields.
- Script runtime messages map to **Migration Logs** entries.
- Script tunables (poll interval/retry counts/max concurrency defaults) map to **Migration Settings**.

### B) Dispatcher runbook
Mapped concerns:
- Job selection and eligibility checks.
- Schedule-gate enforcement (`ScheduledStart <= now`).
- Concurrency cap enforcement from settings.
- Launch of migration execution runbook.

Not mapped here:
- Core migration mechanics from baseline script.

### C) Migration execution runbook
Mapped concerns:
- Core migration execution logic from baseline script.
- Polling loop behavior.
- Fallback behavior.
- Verification behavior.
- Final status and error propagation.

## 3) What stays in one runbook (v1)
Keep in a single migration execution runbook for simplicity:
- Start + move + polling + fallback + verify + complete stages.

Rationale:
- Matches existing script flow.
- Limits orchestration complexity.
- Reduces behavior drift risk in first implementation.

## 4) What may split later (post-v1)
Potential future splits if needed:
- Shared logging helper module.
- Verification stage extracted to a dedicated runbook/function.
- Reusable status-update helper functions.

These splits are optional and should only occur when they improve reliability/maintenance without changing behavior.

## 5) Logic that must be preserved exactly
The following semantics are baseline-critical:
- Migration execution order and stage transitions.
- Polling decision logic and interval behavior.
- Fallback trigger conditions and actions.
- Verification rules and completion checks.
- Final status assignment logic.
- Error handling outcomes (including what becomes `Failed` vs `Partial` where applicable).

Any intentional change requires explicit approval and documentation.

## 6) Setup/deployment concerns vs runtime concerns
### Setup/deployment concerns
Belong to `/provision` and `/infra`:
- Azure resource creation.
- Runbook import/publish and schedule linking.
- SharePoint list and field provisioning.
- Authentication asset setup.
- Default settings seeding.

### Runtime concerns
Belong to `/runbooks`:
- Dispatcher polling and job dispatch.
- Migration execution behavior.
- Status updates and log writes.
- Retry/attempt accounting during processing.

## 7) Migration from script to runbook without behavior drift
Recommended approach:
1. Wrap existing script logic into runbook-compatible function boundaries.
2. Keep parameter names/semantics aligned to existing script.
3. Add SharePoint read/write adapters around the core logic.
4. Validate results against known script outcomes before refactoring.
