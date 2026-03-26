# SharePoint List Design (v1)

This design is intentionally simple and supports the temporary migration tool workflow.

## 1) Migration Jobs
### List name
`Migration Jobs`

### Fields
| Field | Type | Required | Notes |
|---|---|---:|---|
| Title | Single line of text | Yes | Human-readable job name |
| SourceSiteUrl | Hyperlink or Single line text | Yes | Source site URL |
| SourceLibrary | Single line of text | Yes | Source document library |
| SourceFolder | Single line of text | No | Source folder/path |
| DestinationSiteUrl | Hyperlink or Single line text | Yes | Destination site URL |
| DestinationLibrary | Single line of text | Yes | Destination document library |
| DestinationFolder | Single line of text | No | Destination folder/path |
| ScheduledStart | Date and time | Yes | Job eligible when `ScheduledStart <= now` |
| Status | Choice | Yes | See status choices |
| Notes | Multiple lines of text | No | Operator notes |
| RequestedBy | Person or Single line text | No | Requestor identity |
| RequestedOn | Date and time | No | Request timestamp |
| StartedOn | Date and time | No | Runtime set |
| CompletedOn | Date and time | No | Runtime set |
| LastError | Multiple lines of text | No | Last runtime error |
| AttemptCount | Number (integer) | Yes | Increment per execution attempt |
| VerifiedEmpty | Yes/No | Yes | Verification result flag |
| RemainingItemCount | Number (integer) | No | Remaining items after run |
| FallbackUsed | Yes/No | Yes | Whether fallback path used |
| Enabled | Yes/No | Yes | Dispatcher eligibility switch |

### Status choices
- Draft
- Ready
- Running
- Completed
- Failed
- Partial
- Skipped

### Suggested defaults
- Status = `Draft`
- AttemptCount = `0`
- VerifiedEmpty = `No`
- FallbackUsed = `No`
- Enabled = `Yes`

## 2) Migration Logs
### List name
`Migration Logs`

### Fields
| Field | Type | Required | Notes |
|---|---|---:|---|
| Title | Single line of text | Yes | Short log title |
| JobId | Number or Single line text | Yes | Related Migration Jobs item ID |
| JobTitle | Single line of text | No | Snapshot of job title |
| Timestamp | Date and time | Yes | Event timestamp (UTC preferred) |
| Severity | Choice | Yes | INFO/WARN/ERROR |
| Message | Multiple lines of text | Yes | Log message |
| Stage | Choice | Yes | Processing stage |
| SourceUrl | Hyperlink or Single line text | No | Source context |
| DestinationUrl | Hyperlink or Single line text | No | Destination context |
| Runbook | Single line of text | No | Runbook name |

### Severity choices
- INFO
- WARN
- ERROR

### Stage choices
- Dispatcher
- Start
- Move
- Polling
- Fallback
- Verify
- Complete

## 3) Migration Settings
### List name
`Migration Settings`

### Fields
| Field | Type | Required | Notes |
|---|---|---:|---|
| Title | Single line of text | Yes | Setting key |
| SettingValue | Single line of text | Yes | Setting value |

### Seed settings
- `MaxParallelTasks = 3`
- `PollIntervalSeconds = 60`
- `VerificationRetryCount = 6`
- `VerificationRetryDelaySeconds = 10`
- `DefaultMaxAttempts = 3`

## 4) Runtime usage rules
- Dispatcher only runs jobs where `Enabled = Yes`, `Status = Ready`, and `ScheduledStart <= now`.
- Migration runbook owns updates to runtime-managed fields (status/timestamps/errors/attempts/verification).
- Logs are append-only; do not edit historical entries except for administrative correction.
