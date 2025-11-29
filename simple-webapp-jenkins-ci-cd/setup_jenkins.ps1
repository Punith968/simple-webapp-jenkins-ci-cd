# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires Administrator privileges to install software."
    Write-Warning "Please right-click PowerShell and select 'Run as Administrator', then run this script again."
    exit 1
}

Write-Host "Starting Jenkins Setup..." -ForegroundColor Cyan

# 1. Install Java (OpenJDK 17)
Write-Host "Checking for Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    if ($javaVersion -match "version") {
        Write-Host "Java is already installed." -ForegroundColor Green
    } else {
        throw "Java not found"
    }
} catch {
    Write-Host "Java not found. Installing OpenJDK 17 via Chocolatey..." -ForegroundColor Yellow
    choco install openjdk17 -y
    
    # Refresh env vars
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# 2. Install Jenkins
Write-Host "Checking for Jenkins..." -ForegroundColor Yellow
if (Get-Service "jenkins" -ErrorAction SilentlyContinue) {
    Write-Host "Jenkins service is already installed." -ForegroundColor Green
} else {
    Write-Host "Installing Jenkins via Chocolatey..." -ForegroundColor Yellow
    choco install jenkins -y
}

# 3. Start Jenkins Service
Write-Host "Ensuring Jenkins service is running..." -ForegroundColor Yellow
try {
    $service = Get-Service "jenkins"
    if ($service.Status -ne 'Running') {
        Start-Service "jenkins"
        Write-Host "Jenkins service started." -ForegroundColor Green
    } else {
        Write-Host "Jenkins service is running." -ForegroundColor Green
    }
} catch {
    Write-Error "Failed to start Jenkins service. Please check logs."
}

# 4. Open Jenkins in Browser
Write-Host "Waiting for Jenkins to initialize (10 seconds)..." -ForegroundColor Cyan
Start-Sleep -Seconds 10
Write-Host "Opening Jenkins at http://localhost:8080..." -ForegroundColor Green
Start-Process "http://localhost:8080"

Write-Host "Setup Complete!" -ForegroundColor Cyan
Write-Host "If the browser doesn't load immediately, wait a minute and refresh." -ForegroundColor Yellow
