# /config AGENT Guide

## What belongs here
- Versioned configuration artifacts consumed by provisioning and runbooks.
- Default settings, environment templates, and static mappings.

## What does not belong here
- Secrets or credentials.
- Large operational datasets that belong in SharePoint lists.
- Script logic better placed in `/runbooks` or `/provision`.

## Naming
- Prefer descriptive kebab-case file names.
- Suggested patterns:
  - `settings.default.json`
  - `settings.<environment>.json`
  - `runbook-parameters.<environment>.json`

## Standards
- Keep schema simple and close to SharePoint list/runtime needs.
- Include explicit property names; avoid ambiguous short keys.
- Document expected consumers in file header/comments where applicable.
- Keep defaults safe and operationally practical.

## Environment rules
- No secret material in this folder.
- Environment-specific overrides must remain deployable in automation without manual edits.
