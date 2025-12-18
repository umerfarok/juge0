# PowerShell script to pull and test the Judge0 custom compilers image from GHCR
# Usage: .\test-local.ps1

$IMAGE_NAME = "ghcr.io/umerfarok/juge0:v1"
$CONTAINER_NAME = "judge0-test-$(Get-Random)"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Judge0 Custom Compilers - Local Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Pull the image from GHCR
Write-Host "Step 1: Pulling image from GHCR..." -ForegroundColor Yellow
Write-Host "Image: $IMAGE_NAME" -ForegroundColor Gray
docker pull $IMAGE_NAME

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to pull image from GHCR" -ForegroundColor Red
    Write-Host "Make sure:" -ForegroundColor Yellow
    Write-Host "  1. The GitHub Action has completed successfully" -ForegroundColor Yellow
    Write-Host "  2. The package is set to public in GitHub settings" -ForegroundColor Yellow
    Write-Host "  3. You have internet connection" -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Image pulled successfully" -ForegroundColor Green
Write-Host ""

# Step 2: Start a container
Write-Host "Step 2: Starting test container..." -ForegroundColor Yellow
docker run -d --name $CONTAINER_NAME $IMAGE_NAME sleep infinity

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to start container" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Container started: $CONTAINER_NAME" -ForegroundColor Green
Write-Host ""

# Step 3: Copy test script into container
Write-Host "Step 3: Copying test script to container..." -ForegroundColor Yellow
$scriptPath = Join-Path $PSScriptRoot "test-languages.sh"
docker cp $scriptPath "$($CONTAINER_NAME):/tmp/test-languages.sh"

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to copy test script" -ForegroundColor Red
    docker rm -f $CONTAINER_NAME | Out-Null
    exit 1
}

Write-Host "✓ Test script copied" -ForegroundColor Green
Write-Host ""

# Step 4: Run tests
Write-Host "Step 4: Running language tests..." -ForegroundColor Yellow
Write-Host ""
docker exec $CONTAINER_NAME bash /tmp/test-languages.sh

$testExitCode = $LASTEXITCODE

Write-Host ""

# Step 5: Cleanup
Write-Host "Step 5: Cleaning up..." -ForegroundColor Yellow
docker rm -f $CONTAINER_NAME | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Container removed" -ForegroundColor Green
} else {
    Write-Host "⚠ Warning: Failed to remove container" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan

if ($testExitCode -eq 0) {
    Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host "Your custom Judge0 compilers image is ready to use." -ForegroundColor Green
} else {
    Write-Host "⚠ Some tests failed. Review the output above." -ForegroundColor Yellow
}

Write-Host "=========================================" -ForegroundColor Cyan

exit $testExitCode
