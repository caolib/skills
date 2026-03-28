---
name: notification
description: Show a Windows toast notification after finishing a task.
---

# Notification

## Goal

Let the agent show a desktop notification on Windows after it finishes a task.

## When To Use

- Use this skill at the end of a task when a completion notification is helpful.
- Do not use it for intermediate progress updates unless the user explicitly asks.

## Script

- PowerShell script: `skills/notification/hello.ps1`
- Current behavior: imports `BurntToast` and shows a completion toast.

## How To Run

Run the script from the repository root with PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File "C:\code\skills\skills\notification\hello.ps1"
```

Or run it with the working directory set to `C:\code\skills`:

```powershell
powershell -ExecutionPolicy Bypass -File "skills\notification\hello.ps1"
```

## Usage Rules

- Only invoke the script after the main task is complete.
- If the task fails or is blocked, do not send the completion notification.
- Prefer a single notification per completed user request.
- If PowerShell or `BurntToast` is unavailable, mention that notification could not be shown.

## Example

After finishing the requested work, run:

```powershell
powershell -ExecutionPolicy Bypass -File "skills\notification\hello.ps1"
```
