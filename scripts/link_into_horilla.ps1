Param()

Write-Host "Linking a2k_custom into Horilla..." -ForegroundColor Cyan

$envPath = ".\.env"
if (-Not (Test-Path $envPath)) {
    Write-Host "ERROR: .env not found. Create it from .env.example and set HORILLA_PATH." -ForegroundColor Red
    exit 1
}

# Read .env, strip comments after '#', trim whitespace
$envDict = @{}
Get-Content $envPath | ForEach-Object {
    $line = $_.Split('#')[0].Trim()
    if ($line -and $line.Contains('=')) {
        $kv = $line.Split('=',2)
        $key = $kv[0].Trim()
        $val = $kv[1].Trim().Trim('"').Trim("'")
        if ($key) { $envDict[$key] = $val }
    }
}

if (-Not $envDict.ContainsKey("HORILLA_PATH")) {
    Write-Host "ERROR: HORILLA_PATH not set in .env" -ForegroundColor Red
    exit 1
}

$horilla = $envDict["HORILLA_PATH"]
if (-Not (Test-Path $horilla)) {
    Write-Host "ERROR: HORILLA_PATH does not exist: $horilla" -ForegroundColor Red
    exit 1
}

$target = Join-Path $horilla "a2k_custom"
$src    = Join-Path (Get-Location) "a2k_custom"

if (Test-Path $target) {
    Write-Host "Existing a2k_custom found under Horilla. Skipping link." -ForegroundColor Yellow
} else {
    cmd /c mklink /J "$target" "$src" | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Linked $src -> $target" -ForegroundColor Green
    } else {
        Write-Host "Could not create junction. Please copy a2k_custom manually." -ForegroundColor Red
    }
}

Write-Host "Done. Ensure Django loads our settings overlay (see next step)." -ForegroundColor Cyan
