param(
    [string]$MmdcPath = "",
    [string]$BrowserPath = "",
    [string]$OutputDir = "",
    [string]$MermaidConfig = "",
    [int]$Scale = 2
)

$ErrorActionPreference = "Stop"

$FigureDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $OutputDir) {
    $OutputDir = $FigureDir
}
if (-not [System.IO.Path]::IsPathRooted($OutputDir)) {
    $OutputDir = Join-Path $FigureDir $OutputDir
}
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

if (-not $MermaidConfig) {
    $MermaidConfig = Join-Path $FigureDir "mermaid_render_config.json"
}

if (-not $MmdcPath) {
    $MmdcCommand = Get-Command mmdc -ErrorAction SilentlyContinue
    if ($MmdcCommand) {
        $MmdcPath = $MmdcCommand.Source
    }
}

if (-not $MmdcPath -or -not (Test-Path $MmdcPath)) {
    throw "Mermaid CLI was not found. Install @mermaid-js/mermaid-cli or pass -MmdcPath."
}

if (-not $BrowserPath -and $env:PUPPETEER_EXECUTABLE_PATH) {
    $BrowserPath = $env:PUPPETEER_EXECUTABLE_PATH
}

if (-not $BrowserPath) {
    $Candidates = @(
        (Join-Path $env:USERPROFILE ".cache\puppeteer\chrome\*\chrome-win64\chrome.exe"),
        (Join-Path $env:PUBLIC "Documents\Wondershare\CreatorTemp\puppeteer-cache\chrome\*\chrome-win64\chrome.exe"),
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        "C:\Program Files\Microsoft\Edge\Application\msedge.exe"
    )
    foreach ($Candidate in $Candidates) {
        $Resolved = Get-ChildItem -Path $Candidate -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($Resolved) {
            $BrowserPath = $Resolved.FullName
            break
        }
    }
}

$PuppeteerArgs = @()
if ($BrowserPath) {
    $PuppeteerConfig = Join-Path $env:TEMP "pqid_mermaid_puppeteer_config.json"
    $PuppeteerObject = @{
        executablePath = $BrowserPath
        headless = "new"
        args = @(
            "--headless=new",
            "--no-sandbox",
            "--disable-setuid-sandbox",
            "--disable-dev-shm-usage",
            "--disable-gpu"
        )
    }
    $PuppeteerJson = $PuppeteerObject | ConvertTo-Json -Depth 4
    [System.IO.File]::WriteAllText(
        $PuppeteerConfig,
        $PuppeteerJson,
        [System.Text.UTF8Encoding]::new($false)
    )
    $PuppeteerArgs = @("-p", $PuppeteerConfig)
}

Get-ChildItem -Path $FigureDir -Filter "*.mmd" | Sort-Object Name | ForEach-Object {
    $Svg = Join-Path $OutputDir ($_.BaseName + ".svg")
    $Png = Join-Path $OutputDir ($_.BaseName + ".png")
    & $MmdcPath -i $_.FullName -o $Svg -c $MermaidConfig @PuppeteerArgs -b white
    & $MmdcPath -i $_.FullName -o $Png -c $MermaidConfig @PuppeteerArgs -b white --scale $Scale
    [PSCustomObject]@{
        source = $_.Name
        svg = Split-Path $Svg -Leaf
        png = Split-Path $Png -Leaf
    }
}
