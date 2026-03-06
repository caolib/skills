---
name: everything-local-search
description: Search local files and folders precisely with the Everything CLI `es` against a configurable Everything instance. Use when Codex needs to locate Windows files by filename tokens, path scope, parent directory, extension, or file/folder type, especially for requests that should be narrowed with path and suffix filters before opening files.
---

# Everything Local Search

## Overview

Use this skill to search the local Windows filesystem through Everything's CLI with high precision. Prefer constrained searches over broad global searches, and always target the configured Everything instance.

## Configuration

The default instance lives in [`settings.json`](./settings.json):

```json
{
  "instance": "1.5a"
}
```

Override order:

1. `scripts/invoke-es.ps1 -Instance "<name>"`
2. Environment variable `CODEX_EVERYTHING_INSTANCE`
3. [`settings.json`](./settings.json)
4. Fallback default `1.5a`

For routine use, tell users to edit [`settings.json`](./settings.json). Prefer the bundled script because it reads the configured instance automatically.

## Search Workflow

1. Translate the request into constraints before running anything.
   Extract as many of these as possible: filename terms, exact filename, extension, root path, parent path, file vs folder, and whether the path itself matters.
2. Build the narrowest viable query first.
   Prefer `-path`, `-parent-path`, or `-parent` when the user gives any directory hint.
   Add `ext:<suffix>` whenever the file type is known.
   Add `/a-d` for files or `/ad` for folders instead of searching both.
   Add `-match-path` when a path fragment is part of the request, not just the basename.
   Cap noisy searches with `-n`.
3. Refine instead of expanding.
   If results are noisy, add more filename tokens, a stricter path, an extension filter, or `-whole-word`.
   Avoid bare global queries like `es -instance "<configured-instance>" config` unless you are doing an initial reconnaissance pass.
4. Report the most relevant paths and why they matched.
   When a path restriction or extension was inferred, state that inference briefly.

## Command Rules

- Always use the configured Everything instance.
- Prefer the bundled script [`scripts/invoke-es.ps1`](./scripts/invoke-es.ps1) when combining multiple constraints or when quoting would be awkward, because it reads [`settings.json`](./settings.json) automatically.
- Use raw `es` directly for simple one-off lookups.
- When using raw `es`, read the current instance from [`settings.json`](./settings.json) or override it explicitly.
- Keep the search text compact: filename tokens plus Everything filters such as `ext:npz`.
- Treat `-path` and `-parent*` flags as stronger filters than free-text path fragments.
- Use `-match-path` only when path segments should participate in matching.

## Preferred Patterns

### Exact-ish file lookup

Use when the user knows part of the name and the suffix:

```powershell
es -instance "<configured-instance>" -path "D:\datasets" /a-d -n 20 "mnist ext:npz"
```

### Scoped folder search

Use when the user is looking for directories:

```powershell
es -instance "<configured-instance>" -path "C:\code" /ad -n 50 "checkpoints"
```

### Parent-constrained search

Use when the file must live directly under a known parent:

```powershell
es -instance "<configured-instance>" -parent "C:\code\skills\everything-local-search" /a-d -n 20 "SKILL ext:md"
```

### Scripted precise search

Use when several constraints must be combined:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\invoke-es.ps1 `
  -Path "D:\data" `
  -Token "mnist" `
  -Ext "npz" `
  -FilesOnly `
  -MaxResults 20
```

### Scripted override

Use when the current search should target a different Everything instance without editing the skill config:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\invoke-es.ps1 `
  -Instance "1.5a" `
  -Token "QQ.exe" `
  -FilesOnly `
  -MaxResults 20
```

## Refinement Heuristics

- If the user mentions a project, repo, disk, or top-level folder, convert it into `-path`.
- If the user mentions a suffix like `npz`, `json`, or `py`, convert it into `ext:<suffix>`.
- If the request is about a file "inside" or "under" a specific directory, use `-path`.
- If the request is about a file whose direct parent is known, use `-parent`.
- If the request names a folder and not a file, switch to `/ad`.
- If the first query returns too many results, do not raise `-n` first; tighten the query first.

## Script

Use [`scripts/invoke-es.ps1`](./scripts/invoke-es.ps1) to build stable queries with:

- `-Instance` to override the configured Everything instance for one call
- `-Token` for filename or path terms
- `-Ext` for extension filters
- `-Path`, `-ParentPath`, or `-Parent` for directory scoping
- `-FilesOnly` or `-FoldersOnly` for object type
- `-MatchPath`, `-WholeWord`, and `-CaseSensitive` for stricter matching
- `-Filter` for extra Everything search syntax when needed

Do not add broad wrapper logic around the script. Keep the search explicit and constrained at the call site.
