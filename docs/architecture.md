# Architecture Outline (v1)

## 1) Solution overview
This solution provides a temporary, low-complexity SharePoint migration workflow:
- Operators create/manage migration jobs in SharePoint lists.
- Azure Automation polls for ready jobs and executes migration runbooks.
- Runbooks update job state and write operational logs back to SharePoint.
- The existing migration script defines the migration behavior baseline.

Design intent:
- Minimal services.
- Non-interactive automation.
- Fast deployment into a dedicated resource group.
- Simple teardown when migration work is complete.

## 2) Azure components
Required Azure components:
- **Resource Group** (dedicated to this tool instance).
- **Automation Account** (PowerShell 7.4 runtime).
- **Runbooks**:
  - Dispatcher runbook (polls and starts eligible jobs).
  - Migration execution runbook (invokes baseline migration behavior).
- **Automation schedules** for polling.
- **Automation variables/credentials/certificates** (as needed for auth and runtime settings).
- **Log Analytics (optional but recommended)** for centralized job/runbook logs.

Not included in v1:
- Logic Apps.
- Webhooks.
- Event-grid-driven orchestration.

## 3) SharePoint components
SharePoint is the operator interface and state store for v1.

Lists:
- Migration Jobs
- Migration Logs
- Migration Settings

Operators interact with jobs in SharePoint; automation updates status and logs.

## 4) Authentication model
Primary model:
- Azure Automation runbooks use non-interactive authentication.
- SharePoint access is performed via PnP PowerShell.
- Temporary tool assumption allows full-control SharePoint permissions for automation identity.

Implementation preference:
- Use app-based/auth asset approach suitable for unattended runbooks.
- Store auth materials in Automation assets, not in repo.

## 5) Deployment model
Target model is one-command setup:
1. Clone/download repository.
2. Run a deployment script from `/provision`.
3. Script deploys Azure resources into a dedicated resource group.
4. Script provisions SharePoint lists and required fields.
5. Script imports/publishes runbooks.
6. Script configures schedules and automation assets.
7. Environment is ready for operators.

## 6) Operational flow
1. Operator creates/updates a job in **Migration Jobs** with `Status=Ready`, `Enabled=true`, and valid `ScheduledStart`.
2. Dispatcher runbook runs on schedule.
3. Dispatcher selects jobs where:
   - `Enabled=true`
   - `Status` is actionable (typically `Ready`)
   - `ScheduledStart <= now`
4. Dispatcher starts migration runbook for each selected job (respecting max parallel setting).
5. Migration runbook executes baseline migration logic.
6. Migration runbook updates job fields (status, timestamps, attempts, verification fields, errors).
7. Migration runbook writes stage/severity entries to **Migration Logs**.
8. Dispatcher continues on next schedule cycle.

## 7) Runbook responsibilities
### Dispatcher runbook
- Poll Migration Jobs list.
- Enforce schedule gate (`ScheduledStart <= now`).
- Enforce enabled/status filters.
- Apply parallel limit from settings (`MaxParallelTasks`).
- Start execution runbooks with job context.
- Write dispatcher-stage logs.

### Migration execution runbook
- Load job details.
- Mark job `Running` and set `StartedOn`.
- Execute migration behavior aligned to existing script.
- Handle polling/fallback/verification behavior used by current script.
- Update `AttemptCount`, result fields, `CompletedOn`, `LastError`, `RemainingItemCount`, `FallbackUsed`.
- Set final status (`Completed`, `Failed`, `Partial`, or `Skipped` as applicable).
- Write stage-based logs.

## 8) SharePoint list design summary
Detailed field-level design is in `docs/sharepoint-list-design.md`.

High-level:
- **Migration Jobs** holds work items and runtime state.
- **Migration Logs** holds execution telemetry per stage.
- **Migration Settings** holds tunable runtime values.

## 9) Monitoring and logging
Minimum v1 monitoring:
- Runbook job history in Azure Automation.
- Structured entries in Migration Logs SharePoint list.
- Error propagation to `LastError` on Migration Jobs.

Recommended additions:
- Stream runbook logs to Log Analytics for easier query and retention.
- Basic operational dashboard (SharePoint views + optional Azure Workbook).

## 10) Teardown approach
Teardown goals:
- Remove entire dedicated resource group.
- Optionally remove SharePoint lists created for this tool.
- Export final migration job/log data before removal if needed.

Teardown should be script-driven and explicit to avoid orphaned resources.

## 11) Risks and assumptions
Assumptions:
- Existing migration script is stable and valid baseline.
- Required SharePoint permissions can be granted to automation identity.
- Operator volume is manageable with list-based coordination.

Risks:
- SharePoint list throttling or permission misconfiguration.
- Divergence from baseline script behavior during refactor.
- Incomplete cleanup if teardown is done manually.

Mitigations:
- Preserve baseline behavior and map it explicitly.
- Keep v1 architecture minimal.
- Automate setup and teardown.

## 12) Future extension points (post-v1)
Only after v1 is stable:
- Split runbooks further (e.g., verification as separate unit) if operationally justified.
- Add stronger retry/backoff policy controls.
- Add webhook/event-based triggering if polling becomes insufficient.
- Replace full-control permissions with least-privilege model.
