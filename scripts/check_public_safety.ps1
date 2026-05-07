param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$forbidden = @(
    "FUNDING_PATHS",
    "PUBLICATION_TARGETS",
    "ACM_TQC_BENCHMARK_PAPER_DRAFT",
    "NATURE_MACHINE_INTELLIGENCE_PAPER_DRAFT",
    "OPENAI_RESEARCHER_ACCESS_APPLICATION",
    "C:\\Users\\",
    "MS_THESIS_DATASET",
    "CAREER\\ACADEMIC CAREER"
)

$files = Get-ChildItem -LiteralPath $Root -Recurse -File -Force |
    Where-Object {
        $_.FullName -notmatch "\\.git\\" -and
        $_.Name -ne "check_public_safety.ps1" -and
        $_.Extension -in @(".md", ".py", ".ps1", ".json", ".csv", ".yml", ".yaml", ".txt", ".mmd")
    }

$hits = foreach ($file in $files) {
    $text = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    foreach ($term in $forbidden) {
        if ($text -like "*$term*") {
            [PSCustomObject]@{
                File = $file.FullName
                Term = $term
            }
        }
    }
}

if ($hits) {
    $hits | Format-Table -AutoSize
    throw "Public-safety scan found forbidden terms."
}

"Public-safety scan passed for $Root"
