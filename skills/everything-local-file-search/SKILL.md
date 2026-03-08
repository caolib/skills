---
name: everything-local-file-search
description: Use Windows Everything es.exe to quickly search local files and folders
---

# Everything Local File Search

## Goal

Use `es.exe` for fast local search on Windows while keeping compatibility with older Everything versions.

## Allowed CLI Options

Use only these options:

- `-r` or `-regex`: regex search.
- `-i` or `-case`: case-sensitive match.
- `-w`, `-ww`, `-whole-word`, `-whole-words`: whole-word match.
- `-p` or `-match-path`: match full path and file name.
- `-o <offset>` or `-offset <offset>`: zero-based offset for paging.
- `-n <num>` or `-max-results <num>`: max number of returned results.
- `-s`: sort by full path.
- `-h` or `-help`: print help.

## Command Purity Rules

- Build commands as pure `es.exe` invocations only.
- Do not append `| grep`, `| findstr`, `| awk`, `| sed`, or any external filter command.
- Do not add non-`es` flags or pseudo-parameters.
- `exact:<filename>` in search text is allowed
- `ext:<suffix>` in search text is allowed
- File-type search prefixes in search text are allowed: `audio:`, `zip:`, `doc:`, `exe:`, `pic:`, `video:`.

## Query Rules

Use this format: `es.exe [options] [search text]`

- Use wildcard search text: `*.md`, `*.pdf`, `report*`.
- Use quotes for phrases: `"annual report"`.
- Use multiple terms to narrow results: `invoice 2025`.
- If the full file name is known, prefer `exact:<filename>` to avoid partial matches.
- If extension filtering is needed, use `ext:<suffix>` (for example `ext:md`, `ext:exe`).
- If a broad type filter is needed, use query prefixes: `audio:`, `zip:`, `doc:`, `exe:`, `pic:`, `video:`.
- Add `-p` when path fragments should match.
- Use `-n` and `-o` together for paging.

## Practical Patterns

1. Basic keyword search:

```powershell
es.exe -n 50 "project plan"
```

2. Find by extension:

```powershell
es.exe ext:md path:docs
```

3. Find by built-in type prefix:

```powershell
es.exe audio:
es.exe video: "tutorial"
```

4. Exact file-name search (preferred when name is known):

```powershell
es.exe exact:code.exe
```

5. Case-sensitive whole-word search:

```powershell
es.exe -i -w -n 50 API
```

6. Regex search:

```powershell
es.exe -r -n 100 "^readme(\..+)?$"
```

7. Path-aware search:

```powershell
es.exe -p -n 100 "C:\\code\\skills\\docs\\es.md"
```

8. Pagination:

```powershell
es.exe -n 100 -o 0 "log"
es.exe -n 100 -o 100 "log"
```

9. Folder-targeted workflow without 1.4-only flags:

```powershell
# Use folder-name/path keywords directly in es query
es.exe -p -n 200 "node_modules"
```
