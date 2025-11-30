# Integration Tests

This directory contains integration tests for the GreenConnect Mobile application.

## Structure

```
integration_test/
├── authentication/
│   └── login_test.dart          # Login flow tests
├── helpers/
│   ├── app_actions.dart         # Reusable test actions
│   ├── finders.dart             # Widget keys for finding elements
│   └── test_utils.dart          # Test utilities
```

## Running Tests Locally

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Chrome browser (for web testing)
- Android Emulator or iOS Simulator (for mobile testing)

### Run all integration tests
```bash
# On Chrome (Web)
flutter test integration_test/ --platform chrome

# On specific device
flutter test integration_test/ -d <device_id>
```

### Run specific test file
```bash
flutter test integration_test/authentication/login_test.dart
```

### Run with Flutter Drive (for better control)
```bash
# Start the app and run tests
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/authentication/login_test.dart \
  -d chrome
```

## Test Keys

All UI elements have keys defined in `helpers/finders.dart`:

- `goLogin` - Login button on welcome screen
- `phoneField` - Phone number input field
- `sendOtpButton` - Send OTP button
- `otpField` - OTP input field (Pinput widget)

## Adding New Tests

1. Create a new test file in the appropriate directory
2. Import necessary helpers:
   ```dart
   import 'package:flutter_test/flutter_test.dart';
   import 'package:integration_test/integration_test.dart';
   import '../helpers/app_actions.dart';
   import '../helpers/test_utils.dart';
   ```

3. Add new keys to `helpers/finders.dart` if needed
4. Create reusable actions in `helpers/app_actions.dart`
5. Write your tests using `testWidgets`

## CI/CD

Integration tests run automatically on GitHub Actions for:
- Push to main, develop, or feature branches
- Pull requests to main or develop

See `.github/workflows/flutter_integration_test.yml` for details.

## Notes

- Tests run on web platform in CI due to environment constraints
- Firebase authentication may not work in CI without proper setup
- Some tests use `continue-on-error: true` for graceful failures
- Tests verify UI elements and navigation flow, not actual API calls

## Troubleshooting

### Test not finding widgets
- Ensure the widget has a key defined in `finders.dart`
- Use `await tester.pumpAndSettle()` to wait for animations
- Check if the widget is actually visible on screen

### Firebase errors in tests
- Integration tests with Firebase require proper configuration
- Consider mocking Firebase in tests or using test credentials
- Use `continue-on-error: true` for tests that require Firebase

### Chrome driver issues
- Ensure ChromeDriver is installed and running
- Use `flutter drive` instead of `flutter test` for web tests
- Check Chrome version compatibility with ChromeDriver
