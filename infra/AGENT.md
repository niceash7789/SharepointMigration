# /infra AGENT Guide

## What belongs here
- Infrastructure definitions and scripts for Azure resources used by this tool.
- Resource group, Automation Account, schedules, variables, and related infra wiring.
- Reusable deployment-time helpers that are infra-specific.

## What does not belong here
- Runbook business logic.
- SharePoint runtime migration logic.
- Long-form architecture docs.

## Naming
- Use clear, purpose-based names.
- Recommended patterns:
  - `main.<ext>` for primary entry template/script
  - `automation.<area>.<ext>` for Automation-related units
  - `rg.<purpose>.<ext>` for resource-group scoped units

## Standards
- Keep infra minimal and aligned to v1 architecture (Azure Automation + required dependencies only).
- Do not add optional/advanced Azure services unless explicitly required.
- Parameterize environment-specific values; avoid hardcoded tenant/subscription details.
- Ensure idempotent deployment behavior where practical.

## Environment rules
- Assume deployment into a dedicated, temporary resource group.
- Optimize for hands-off setup and predictable teardown.
