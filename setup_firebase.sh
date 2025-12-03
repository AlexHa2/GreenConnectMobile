#!/bin/bash
# Script to setup Firebase configuration files
# Run this script after cloning the repository

set -e

echo "🔥 Firebase Configuration Setup"
echo "================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}Error: Please run this script from the project root directory${NC}"
    exit 1
fi

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 already exists"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1 not found"
        return 1
    fi
}

echo ""
echo "Checking Firebase configuration files..."
echo ""

# Check Android google-services.json
if ! check_file "android/app/google-services.json"; then
    echo -e "${YELLOW}Creating android/app/google-services.json from template...${NC}"
    if [ -f "android/app/google-services.json.example" ]; then
        cp android/app/google-services.json.example android/app/google-services.json
        echo -e "${GREEN}✓${NC} Template copied. Please update with your Firebase credentials."
    else
        echo -e "${RED}✗${NC} Template file not found!"
    fi
fi

# Check iOS GoogleService-Info.plist
if ! check_file "ios/Runner/GoogleService-Info.plist"; then
    echo -e "${YELLOW}Creating ios/Runner/GoogleService-Info.plist from template...${NC}"
    if [ -f "ios/Runner/GoogleService-Info.plist.example" ]; then
        cp ios/Runner/GoogleService-Info.plist.example ios/Runner/GoogleService-Info.plist
        echo -e "${GREEN}✓${NC} Template copied. Please update with your Firebase credentials."
    else
        echo -e "${RED}✗${NC} Template file not found!"
    fi
fi

# Check firebase_options.dart
if ! check_file "lib/core/config/firebase_options.dart"; then
    echo -e "${YELLOW}Creating lib/core/config/firebase_options.dart from template...${NC}"
    if [ -f "lib/core/config/firebase_options.dart.example" ]; then
        cp lib/core/config/firebase_options.dart.example lib/core/config/firebase_options.dart
        echo -e "${GREEN}✓${NC} Template copied. Please update with your Firebase credentials."
    else
        echo -e "${RED}✗${NC} Template file not found!"
    fi
fi

echo ""
echo "================================"
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo "⚠️  IMPORTANT: Please update the Firebase configuration files with your actual credentials"
echo ""
echo "Files to update:"
echo "  1. android/app/google-services.json"
echo "  2. ios/Runner/GoogleService-Info.plist"
echo "  3. lib/core/config/firebase_options.dart"
echo ""
echo "For more information, see: https://firebase.google.com/docs/flutter/setup"
