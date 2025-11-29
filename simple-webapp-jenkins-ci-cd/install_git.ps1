# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges to install Git."
    Write-Warning "Please right-click PowerShell and select 'Run as Administrator', then run this script again."
    exit 1
}

Write-Host "Installing Git..." -ForegroundColor Cyan
choco install git -y

Write-Host "Refreshing Environment Variables..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Verifying Git installation..." -ForegroundColor Cyan
try {
    git --version
    Write-Host "Git installed successfully!" -ForegroundColor Green
    Write-Host "NOTE: You may need to restart the Jenkins service for it to pick up the new PATH." -ForegroundColor Yellow
    Write-Host "To restart Jenkins, run: Restart-Service jenkins" -ForegroundColor Yellow
} catch {
    Write-Error "Git installation verification failed. Please check the output above."
}
