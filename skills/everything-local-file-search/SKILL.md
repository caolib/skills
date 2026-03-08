---
name: everything-local-file-search
description: Use Windows Everything es.exe to quickly search local files and folders.
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
- Set the terminal encoding format to UTF-8 before searching
- Do not append `| grep`, `| findstr`, `| awk`, `| sed`, or any external filter command.
- Do not add non-`es` flags or pseudo-parameters.

## Query Syntax Tokens (Search Text)

These are Everything query tokens in search text, not CLI options:

- `exact:<filename>` for exact file-name match.
- `ext:<suffix>` for extension filter.
- Type prefixes: `audio:`, `zip:`, `doc:`, `exe:`, `pic:`, `video:`.

## Critical Quoting Rule

Do not quote the whole expression when it contains query tokens.

- Wrong: `es.exe -n 200 "doki ext:exe"`
- Right: `es.exe -n 200 doki ext:exe`
- Right (phrase + token): `es.exe -n 200 "doki manga" ext:zip`

Quote only plain phrase terms that contain spaces. Keep tokens like `ext:` and `exact:` outside quotes.

## Query Rules

Use format: `es.exe [options] [search text]`

- Use wildcard text when useful: `*.md`, `*.pdf`, `report*`.
- Use multiple terms to narrow results: `invoice 2025`.
- Use `exact:<filename>` only when needed for disambiguation.
- If extension filter is needed, use `ext:<suffix>`.
- Use `-n` and `-o` together for paging.

## Search Efficiency Rules

- Minimize search calls and avoid redundant follow-up queries.
- If current results already include the target file/path, stop and report it.
- Do not run `exact:` again just to reduce results to one item.
- Do not run extra path-verification searches only to re-check slash formatting.
- Use `exact:` only when no clear hit exists, multiple hits are ambiguous, or the user explicitly asks for exact-name verification.
