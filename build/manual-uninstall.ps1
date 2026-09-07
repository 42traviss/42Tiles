# 42Tiles - manual uninstall from GameMaker LTS 2026.
# Run: powershell -ExecutionPolicy Bypass -File manual-uninstall.ps1

$ErrorActionPreference = "Stop"

$pluginName   = "42Tiles"
$legacyName   = "AutotileFill"
$author       = "traviss42"
$pluginsRoot  = "C:\ProgramData\GameMakerStudio2-LTS2026\Plugins"
$manifestPath = Join-Path $pluginsRoot "plugins.json"

Write-Host "=== Uninstalling $pluginName ===" -ForegroundColor Cyan

$gmProcess = Get-Process -Name "GameMaker-LTS2026","GameMaker" -ErrorAction SilentlyContinue
if ($gmProcess) {
    Write-Host "ERROR: GameMaker is running. Close it and run uninstall again." -ForegroundColor Red
    exit 1
}

# 1. Remove the plugin folder plus leftover AutotileFill
foreach ($name in @($pluginName, $legacyName)) {
    $dir = Join-Path $pluginsRoot $name
    if (Test-Path $dir) {
        Remove-Item -Recurse -Force $dir
        Write-Host "Removed $dir" -ForegroundColor Green
    }
}

# 2. Remove entry from plugins.json
if (Test-Path $manifestPath) {
    # plugins.json may use trailing commas (same JSON5-ish style as .yy/.yyp),
    # which ConvertFrom-Json rejects - strip them before parsing.
    $manifestRaw = (Get-Content $manifestPath -Raw) -replace ',(\s*[}\]])', '$1'
    $json = $manifestRaw | ConvertFrom-Json
    $drop = @($pluginName, $legacyName)
    $filtered = @($json.Plugins) | Where-Object {
        -not ($drop -contains $_.Name -and $_.Author -eq $author)
    }
    $json.Plugins = @($filtered)
    # ConvertTo-Json via the pipeline unwraps a single-element (or empty)
    # array into a bare object/nothing, corrupting plugins.json - pass
    # -InputObject instead to keep the array intact.
    $out = ConvertTo-Json -InputObject $json -Depth 5
    [System.IO.File]::WriteAllText($manifestPath, $out, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "Removed entry from plugins.json" -ForegroundColor Green
}

Write-Host ""
Write-Host "DONE. Plugin $pluginName uninstalled." -ForegroundColor Cyan
