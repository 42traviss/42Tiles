# 42Tiles - manual plugin installer for GameMaker LTS 2026.
# Run from this folder (build\), which has the .dll/.gmplugin sitting
# right next to this script.
# Run: powershell -ExecutionPolicy Bypass -File manual-install.ps1

$ErrorActionPreference = "Stop"

$pluginName   = "42Tiles"
$legacyName   = "AutotileFill"
$author       = "traviss42"
$gmDataRoot   = "C:\ProgramData\GameMakerStudio2-LTS2026"
$pluginsRoot  = Join-Path $gmDataRoot "Plugins"
$targetDir    = Join-Path $pluginsRoot $pluginName
$manifestPath = Join-Path $pluginsRoot "plugins.json"
$sourceDir    = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== $pluginName installer ===" -ForegroundColor Cyan

# 1. Is GameMaker LTS 2026 installed?
if (-not (Test-Path $gmDataRoot)) {
    Write-Host "ERROR: $gmDataRoot not found" -ForegroundColor Red
    Write-Host "This plugin requires GameMaker LTS 2026. Install the IDE and try again."
    exit 1
}

# The Plugins folder only exists once the IDE has loaded at least one
# plugin - a fresh install may not have it yet.
if (-not (Test-Path $pluginsRoot)) {
    New-Item -ItemType Directory -Force $pluginsRoot | Out-Null
    Write-Host "Created $pluginsRoot" -ForegroundColor Yellow
}

# 2. GameMaker must not be running. Steam LTS is GameMaker.exe (process
# GameMaker); the standalone installer uses GameMaker-LTS2026.
$gmProcess = Get-Process -Name "GameMaker-LTS2026","GameMaker" -ErrorAction SilentlyContinue
if ($gmProcess) {
    Write-Host "ERROR: GameMaker is running. Close it and run the installer again." -ForegroundColor Red
    exit 1
}

# 3. Check for required files
foreach ($file in @("$pluginName.dll", "$pluginName.gmplugin")) {
    if (-not (Test-Path (Join-Path $sourceDir $file))) {
        Write-Host "ERROR: Missing file $file next to the installer." -ForegroundColor Red
        exit 1
    }
}

# 3b. Version - read from the DLL's own metadata (FileVersion, set
# automatically by the SDK from <Version> in the .csproj), not from a
# separate constant here - keeps the installer from drifting out of sync
# with the actual build. FileVersion has 4 parts (e.g. "0.1.0.0" - the SDK
# always appends a fourth ".0"), plugins.json expects plain SemVer without
# that tail, so only the first three parts are used.
$dllPath = Join-Path $sourceDir "$pluginName.dll"
$fileVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($dllPath).FileVersion
$version = ($fileVersion -split '\.')[0..2] -join '.'
Write-Host "Version read from $pluginName.dll: $version" -ForegroundColor Cyan

# 4. Drop the old AutotileFill folder so both plugins do not load.
$oldDir = Join-Path $pluginsRoot $legacyName
if (Test-Path $oldDir) {
    Remove-Item -Recurse -Force $oldDir
    Write-Host "Removed leftover $legacyName" -ForegroundColor Yellow
}

# 5. Copy files
New-Item -ItemType Directory -Force $targetDir | Out-Null
Copy-Item (Join-Path $sourceDir "$pluginName.dll")      $targetDir -Force
Copy-Item (Join-Path $sourceDir "$pluginName.gmplugin") $targetDir -Force
$imagesDir = Join-Path (Split-Path -Parent $sourceDir) "images"
if (Test-Path $imagesDir) {
    $destImages = Join-Path $targetDir "images"
    New-Item -ItemType Directory -Force $destImages | Out-Null
    Copy-Item (Join-Path $imagesDir "*") $destImages -Force
}
Write-Host "Copied files to $targetDir" -ForegroundColor Green

# 6. Register in plugins.json
$entry = [ordered]@{
    '$PluginToLoad' = "v1"
    'Author'        = $author
    'Name'          = $pluginName
    'Version'       = $version
}

if (Test-Path $manifestPath) {
    # plugins.json may use trailing commas (same JSON5-ish style as .yy/.yyp),
    # which ConvertFrom-Json rejects - strip them before parsing.
    $manifestRaw = (Get-Content $manifestPath -Raw) -replace ',(\s*[}\]])', '$1'
    $json = $manifestRaw | ConvertFrom-Json
    $json.Plugins = @($json.Plugins) | Where-Object {
        -not ($_.Name -eq $legacyName -and $_.Author -eq $author)
    }
    $existing = @($json.Plugins) | Where-Object { $_.Name -eq $pluginName -and $_.Author -eq $author }
    if ($existing) {
        if ($existing.Version -ne $version) {
            $existing.Version = $version
            Write-Host "Updated version in plugins.json to $version" -ForegroundColor Green
        } else {
            Write-Host "Entry already exists in plugins.json - no changes." -ForegroundColor Yellow
        }
    } else {
        $json.Plugins = @($json.Plugins) + @([pscustomobject]$entry)
        Write-Host "Added entry to plugins.json" -ForegroundColor Green
    }
    # ConvertTo-Json via the pipeline unwraps a single-element array into
    # a bare object, corrupting plugins.json when only one plugin is
    # registered - pass -InputObject instead to keep the array intact.
    $out = ConvertTo-Json -InputObject $json -Depth 5
    [System.IO.File]::WriteAllText($manifestPath, $out, (New-Object System.Text.UTF8Encoding($false)))
} else {
    $manifest = [ordered]@{
        '$PluginLoadCollection' = "v1"
        'Plugins'               = @([pscustomobject]$entry)
    }
    $out = ConvertTo-Json -InputObject ([pscustomobject]$manifest) -Depth 5
    [System.IO.File]::WriteAllText($manifestPath, $out, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Created plugins.json with the plugin entry" -ForegroundColor Green
}

Write-Host ""
Write-Host "DONE. Launch GameMaker LTS 2026 to use the plugin." -ForegroundColor Cyan
