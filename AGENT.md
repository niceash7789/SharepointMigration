# Repository AGENT Guide

## Purpose
This repository hosts a temporary, script-led SharePoint migration tool.

Primary goals:
- Keep migration behavior aligned with the existing PowerShell migration script.
- Provide a simple operator experience in SharePoint.
- Use Azure Automation for non-interactive backend processing.
- Support fast deploy/use/decommission in a dedicated resource group.

## Solution Shape (v1)
- **Front end/operator interface:** SharePoint lists and views.
- **Backend execution:** Azure Automation runbooks on a schedule.
- **Configuration/state:** SharePoint lists (jobs, logs, settings) plus minimal config files in repo.
- **Provisioning/deployment:** PowerShell scripts in `/provision` and IaC/scripts in `/infra`.

Out of scope for v1:
- Logic Apps
- Webhooks
- Additional orchestration services unless required by a validated gap

## Baseline Behavior Rule (Critical)
The existing migration script is the behavioral baseline.

Contributors must:
- Preserve migration semantics unless explicitly approved to change them.
- Treat differences from baseline as defects unless documented and approved.
- Document any intentional behavior deviation in `docs/current-script-mapping.md` and changelog/PR notes.

## Coding Standards
General:
- Keep designs simple and implementation-focused.
- Prefer explicit scripts over abstraction-heavy frameworks.
- Avoid placeholders and pseudo-code when real examples can be provided.

PowerShell:
- Target **PowerShell 7.4**.
- Use approved verbs, strict parameter validation, and `Set-StrictMode -Version Latest` where practical.
- Write non-interactive automation-safe code (no prompts, no manual confirmation flows).
- Favor deterministic error handling and clear exit/log behavior.
- Use UTF-8 encoding and consistent formatting.

SharePoint:
- Use **PnP PowerShell only** for SharePoint operations.
- v1 can assume full-control permissions for the automation identity due to temporary tool scope.

## Deployment Philosophy
- One-command setup from a fresh clone.
- Deploy into a dedicated resource group.
- Configure all required assets (Automation, schedules, auth assets, SharePoint lists) automatically.
- Keep teardown straightforward and complete.

## Contributor Workflow
1. Read this file and relevant folder-level `AGENT.md` before editing.
2. Keep changes scoped to the current phase/task.
3. Update docs with concrete values/commands, not vague descriptions.
4. Validate scripts where possible before committing.
5. Keep PRs focused and operationally safe.

## Repository Layout (Target)
- `/infra` for infrastructure definitions/helpers.
- `/provision` for setup/bootstrap scripts.
- `/runbooks` for Azure Automation runbook scripts.
- `/config` for versioned configuration artifacts.
- `/docs` for architecture, mapping, deployment, and operations documentation.

## Non-goals for Contributors
- Do not introduce enterprise-pattern complexity for this temporary tool.
- Do not migrate to different service stacks without explicit approval.
- Do not rewrite core migration logic during architecture/setup phases.
