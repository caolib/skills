[CmdletBinding()]
param(
    [Parameter()]
    [string]$Instance,

    [Parameter()]
    [string[]]$Token,

    [Parameter()]
    [string[]]$Ext,

    [Parameter()]
    [string[]]$Filter,

    [Parameter()]
    [string]$Path,

    [Parameter()]
    [string]$ParentPath,

    [Parameter()]
    [string]$Parent,

    [Parameter()]
    [ValidateSet(
        "name",
        "path",
        "size",
        "extension",
        "date-created",
        "date-modified",
        "date-accessed",
        "attributes",
        "file-list-file-name",
        "run-count",
        "date-recently-changed",
        "date-run"
    )]
    [string]$Sort = "path",

    [Parameter()]
    [int]$MaxResults = 50,

    [Parameter()]
    [int]$Offset = 0,

    [Parameter()]
    [int]$TimeoutMs = 5000,

    [Parameter()]
    [switch]$FilesOnly,

    [Parameter()]
    [switch]$FoldersOnly,

    [Parameter()]
    [switch]$MatchPath,

    [Parameter()]
    [switch]$WholeWord,

    [Parameter()]
    [switch]$CaseSensitive
)

if ($FilesOnly -and $FoldersOnly) {
    throw "Use either -FilesOnly or -FoldersOnly, not both."
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$settingsPath = Join-Path (Split-Path -Parent $scriptRoot) "settings.json"
$configuredInstance = $null

if (Test-Path -LiteralPath $settingsPath) {
    try {
        $settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
    }
    catch {
        throw "Failed to read settings from $settingsPath. $_"
    }

    if ($settings.instance -is [string]) {
        $configuredInstance = $settings.instance.Trim()
    }
}

$effectiveInstance = $Instance
if ([string]::IsNullOrWhiteSpace($effectiveInstance)) {
    $effectiveInstance = $env:CODEX_EVERYTHING_INSTANCE
}
if ([string]::IsNullOrWhiteSpace($effectiveInstance)) {
    $effectiveInstance = $configuredInstance
}
if ([string]::IsNullOrWhiteSpace($effectiveInstance)) {
    $effectiveInstance = "1.5a"
}

$searchTokens = New-Object System.Collections.Generic.List[string]

foreach ($value in $Token) {
    if ([string]::IsNullOrWhiteSpace($value)) {
        continue
    }

    if ($value.Contains('"')) {
        throw "Token values must not contain double quotes: $value"
    }

    if ($value -match "\s") {
        $searchTokens.Add('"' + $value + '"')
    }
    else {
        $searchTokens.Add($value)
    }
}

foreach ($value in $Ext) {
    if ([string]::IsNullOrWhiteSpace($value)) {
        continue
    }

    $normalized = $value.Trim().TrimStart(".")
    if (-not $normalized) {
        continue
    }

    $searchTokens.Add("ext:$normalized")
}

foreach ($value in $Filter) {
    if ([string]::IsNullOrWhiteSpace($value)) {
        continue
    }

    $searchTokens.Add($value.Trim())
}

if ($searchTokens.Count -eq 0) {
    throw "Provide at least one search constraint with -Token, -Ext, or -Filter."
}

$arguments = New-Object System.Collections.Generic.List[string]
$arguments.Add("-instance")
$arguments.Add($effectiveInstance)
$arguments.Add("-timeout")
$arguments.Add($TimeoutMs.ToString())
$arguments.Add("-n")
$arguments.Add($MaxResults.ToString())
$arguments.Add("-sort")
$arguments.Add($Sort)
$arguments.Add("-full-path-and-name")

if ($Offset -gt 0) {
    $arguments.Add("-offset")
    $arguments.Add($Offset.ToString())
}

if ($Path) {
    $arguments.Add("-path")
    $arguments.Add($Path)
}

if ($ParentPath) {
    $arguments.Add("-parent-path")
    $arguments.Add($ParentPath)
}

if ($Parent) {
    $arguments.Add("-parent")
    $arguments.Add($Parent)
}

if ($FilesOnly) {
    $arguments.Add("/a-d")
}

if ($FoldersOnly) {
    $arguments.Add("/ad")
}

if ($MatchPath) {
    $arguments.Add("-match-path")
}

if ($WholeWord) {
    $arguments.Add("-whole-word")
}

if ($CaseSensitive) {
    $arguments.Add("-case")
}

$arguments.Add(($searchTokens -join " "))

& es @arguments
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
    exit $exitCode
}
