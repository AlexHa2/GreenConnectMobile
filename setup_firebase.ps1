# PowerShell script to setup Firebase configuration files
# Run this script after cloning the repository

Write-Host "🔥 Firebase Configuration Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check if running in the right directory
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "Error: Please run this script from the project root directory" -ForegroundColor Red
    exit 1
}

# Function to check if file exists
function Test-ConfigFile {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        Write-Host "✓ $FilePath already exists" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ $FilePath not found" -ForegroundColor Yellow
        return $false
    }
}

Write-Host ""
Write-Host "Checking Firebase configuration files..." -ForegroundColor Cyan
Write-Host ""

# Check Android google-services.json
if (-not (Test-ConfigFile "android/app/google-services.json")) {
    $templatePath = "android/app/google-services.json.example"
    if (Test-Path $templatePath) {
        Copy-Item $templatePath "android/app/google-services.json"
        Write-Host "✓ Template copied. Please update with your Firebase credentials." -ForegroundColor Green
    } else {
        Write-Host "✗ Template file not found!" -ForegroundColor Red
    }
}

# Check iOS GoogleService-Info.plist
if (-not (Test-ConfigFile "ios/Runner/GoogleService-Info.plist")) {
    $templatePath = "ios/Runner/GoogleService-Info.plist.example"
    if (Test-Path $templatePath) {
        Copy-Item $templatePath "ios/Runner/GoogleService-Info.plist"
        Write-Host "✓ Template copied. Please update with your Firebase credentials." -ForegroundColor Green
    } else {
        Write-Host "✗ Template file not found!" -ForegroundColor Red
    }
}

# Check firebase_options.dart
if (-not (Test-ConfigFile "lib/core/config/firebase_options.dart")) {
    $templatePath = "lib/core/config/firebase_options.dart.example"
    if (Test-Path $templatePath) {
        Copy-Item $templatePath "lib/core/config/firebase_options.dart"
        Write-Host "✓ Template copied. Please update with your Firebase credentials." -ForegroundColor Green
    } else {
        Write-Host "✗ Template file not found!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  IMPORTANT: Please update the Firebase configuration files with your actual credentials" -ForegroundColor Yellow
Write-Host ""
Write-Host "Files to update:" -ForegroundColor Cyan
Write-Host "  1. android/app/google-services.json"
Write-Host "  2. ios/Runner/GoogleService-Info.plist"
Write-Host "  3. lib/core/config/firebase_options.dart"
Write-Host ""
Write-Host "For more information, see: https://firebase.google.com/docs/flutter/setup" -ForegroundColor Cyan
