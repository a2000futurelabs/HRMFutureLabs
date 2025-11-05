Param()

Write-Host "Sanity checks..." -ForegroundColor Cyan
if (-Not (Test-Path ".\.env")) { Write-Host "Missing .env" -ForegroundColor Yellow }
if (-Not (Test-Path ".\a2k_custom\models.py")) { Write-Host "Missing a2k_custom/models.py" -ForegroundColor Yellow }
Write-Host "Done."
