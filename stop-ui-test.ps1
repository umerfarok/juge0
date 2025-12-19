# PowerShell script to stop the Judge0 test environment

Write-Host "Stopping Judge0 test environment..." -ForegroundColor Yellow
docker-compose -f docker-compose-test.yml down

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Services stopped successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to stop services" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "To remove volumes (database data):" -ForegroundColor Yellow
Write-Host "  docker-compose -f docker-compose-test.yml down -v" -ForegroundColor Cyan
