# /docs AGENT Guide

## What belongs here
- Architecture, mapping, deployment, operations, and phase-planning documentation.
- Practical runbooks/process notes for contributors and operators.

## What does not belong here
- Executable runtime logic.
- Infrastructure templates/scripts.
- Placeholder content with no operational value.

## Naming
- Use lowercase kebab-case markdown names, e.g. `architecture.md`.
- Prefer one topic per file.

## Standards
- Be direct, technical, and concise.
- Use concrete commands, file paths, and responsibilities.
- Keep design aligned with v1 constraints (simple SharePoint + Azure Automation model).
- Document what is in scope and out of scope.
- Keep docs synchronized with actual scripts and structure.

## Environment rules
- Treat existing migration script behavior as canonical unless explicitly superseded.
- If behavior changes are approved, document exact impact and rationale.
