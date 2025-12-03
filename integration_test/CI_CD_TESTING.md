# Integration Test CI/CD Configuration

## Overview

This document explains how integration tests work in CI/CD environment without real Firebase credentials.

## Strategy

### 1. **Mock Firebase Configuration**
- Use template files (`.example`) as mock configs in CI
- These contain placeholder values that allow app to build but won't connect to real Firebase

### 2. **Skip Firebase-Dependent Tests**
- Tests that require Firebase authentication are marked with `skip: true`
- These tests are verified manually or in staging environment

### 3. **UI-Only Tests**
- Tests that verify UI rendering and navigation work without Firebase
- These tests run successfully in CI

## Test Categories

### ✅ Tests that run in CI:
- Navigation flow (Welcome → Login)
- UI element rendering (buttons, fields)
- Form input validation (phone format)
- Back navigation and form clearing
- Error handling UI

### ⏭️ Tests skipped in CI:
- OTP sending (requires Firebase)
- OTP verification (requires real OTP code)
- Full authentication flow (requires backend connection)

## GitHub Actions Workflow

```yaml
# Key steps:
1. Create mock Firebase configs from templates
2. Create .env file with test values
3. Run tests with continue-on-error for Firebase tests
4. Upload test results as artifacts
```

## Running Tests Locally

### With Real Firebase (Full Tests):
```bash
# Setup real Firebase configs first
.\setup_firebase.ps1

# Run all tests
flutter test integration_test
```

### Without Firebase (UI Only):
```bash
# Use mock configs
flutter test integration_test

# Tests requiring Firebase will be skipped
```

## Test Results Interpretation

### CI/CD Environment:
- ✅ **PASS**: UI tests, navigation, validation
- ⏭️ **SKIP**: Firebase-dependent tests
- ⚠️ **EXPECTED**: Some tests may show warnings about Firebase

### Local Development:
- ✅ **ALL PASS**: With proper Firebase setup
- Should test manually:
  - OTP sending
  - OTP verification
  - Full login flow

## Best Practices

1. **UI Tests**: Should not depend on external services
2. **Integration Tests**: Can be skipped in CI, tested in staging
3. **E2E Tests**: Should run against staging environment with real services

## Troubleshooting

### "Firebase not initialized" error in CI
- **Expected**: Mock configs don't connect to Firebase
- **Solution**: Tests are designed to handle this gracefully

### Tests timing out
- **Check**: Timeout values in tests
- **Adjust**: Add longer `pumpAndSettle` durations if needed

### All tests failing
- **Check**: Mock config files were created properly
- **Verify**: GitHub Actions logs show "Firebase config files created"

## Future Improvements

1. **Mock Firebase Services**: Use packages like `firebase_auth_mocks`
2. **Separate Test Suites**: 
   - `test_ui/` - UI only, runs in CI
   - `test_integration/` - Requires services, runs in staging
3. **Test Environment**: Setup dedicated test Firebase project
