# PowerShell script to start Judge0 with Web UI for testing custom compilers
# This will start a complete Judge0 environment with your custom compilers image

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Judge0 Web UI Test Environment" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker..." -ForegroundColor Yellow
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
    exit 1
}
Write-Host "✓ Docker is running" -ForegroundColor Green
Write-Host ""

# Pull the latest custom image
Write-Host "Pulling latest custom compilers image..." -ForegroundColor Yellow
docker pull ghcr.io/umerfarok/juge0:v1
Write-Host ""

# Start the services
Write-Host "Starting Judge0 services..." -ForegroundColor Yellow
Write-Host "This may take a minute on first run..." -ForegroundColor Gray
docker-compose -f docker-compose-test.yml up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to start services" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Services started successfully" -ForegroundColor Green
Write-Host ""

# Wait for services to be ready
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check if services are running
$services = docker-compose -f docker-compose-test.yml ps --services --filter "status=running"
$runningCount = ($services | Measure-Object -Line).Lines

Write-Host "Running services: $runningCount/5" -ForegroundColor Gray
Write-Host ""

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✓ Judge0 is ready!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Web UI: " -NoNewline
Write-Host "http://localhost:3000" -ForegroundColor Green
Write-Host "API:    " -NoNewline
Write-Host "http://localhost:2358" -ForegroundColor Green
Write-Host ""
Write-Host "Available Languages:" -ForegroundColor Yellow
Write-Host "  • Java (OpenJDK 21)" -ForegroundColor Gray
Write-Host "  • Python 3.12" -ForegroundColor Gray
Write-Host "  • C/C++ (GCC 11)" -ForegroundColor Gray
Write-Host "  • Node.js 22" -ForegroundColor Gray
Write-Host "  • TypeScript 5.6" -ForegroundColor Gray
Write-Host "  • C# (.NET 8.0)" -ForegroundColor Gray
Write-Host "  • Kotlin 2.0.21" -ForegroundColor Gray
Write-Host "  • Ruby 3.0" -ForegroundColor Gray
Write-Host "  • Go 1.23" -ForegroundColor Gray
Write-Host "  • Swift 6.0" -ForegroundColor Gray
Write-Host "  • PHP 8.3" -ForegroundColor Gray
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening browser..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Start-Process "http://localhost:3000"
Write-Host ""
Write-Host "To view logs: " -NoNewline
Write-Host "docker-compose -f docker-compose-test.yml logs -f" -ForegroundColor Cyan
Write-Host "To stop:      " -NoNewline
Write-Host "docker-compose -f docker-compose-test.yml down" -ForegroundColor Cyan
Write-Host ""
