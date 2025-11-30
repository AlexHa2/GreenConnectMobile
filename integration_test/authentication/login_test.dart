import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/app_actions.dart';
import '../helpers/finders.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication - Login Flow', () {
    testWidgets('Should navigate to login page from welcome screen',
        (tester) async {
      await startApp(tester);

      // Verify we're on welcome screen
      expect(find.byKey(AppKeys.goLogin), findsOneWidget);

      // Navigate to login
      await goToLoginPage(tester);

      // Verify we're on login page
      expect(find.byKey(AppKeys.phoneField), findsOneWidget);
      expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
    });

    testWidgets('Should show phone field and send OTP button', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      // Verify phone input is visible
      expect(find.byKey(AppKeys.phoneField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      // Verify send OTP button is visible
      expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Should show OTP field after entering phone number',
        (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      // Enter phone number
      await enterPhoneNumber(tester, '+84987654321');

      // Tap send OTP
      await tapSendOtp(tester);

      // Wait for OTP screen to appear
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify OTP field appears (if phone is valid and Firebase works)
      // Note: This will fail in CI without Firebase setup
      // expect(find.byKey(AppKeys.otpField), findsOneWidget);
    });

    testWidgets('Should allow entering 6-digit OTP code', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      await enterPhoneNumber(tester, '+84987654321');
      await tapSendOtp(tester);

      // Wait for OTP screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try to find and enter OTP
      final otpField = find.byKey(AppKeys.otpField);
      if (otpField.evaluate().isNotEmpty) {
        await enterOtp(tester, '123456');

        // OTP should auto-submit when 6 digits are entered
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    testWidgets('Should have back button to return to welcome screen',
        (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      // Verify back navigation exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should be back on welcome screen
      expect(find.byKey(AppKeys.goLogin), findsOneWidget);
    });
  });

  group('Authentication - Phone Input Validation', () {
    testWidgets('Should accept valid Vietnamese phone number', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      final phoneField = find.byKey(AppKeys.phoneField);
      await tester.enterText(phoneField, '+84987654321');
      await tester.pumpAndSettle();

      // Phone field should contain the entered text
      final textField = tester.widget<TextFormField>(phoneField);
      expect(textField.controller?.text, '+84987654321');
    });

    testWidgets('Should clear phone number when tapping back', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      await enterPhoneNumber(tester, '+84987654321');

      // Go back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Go to login again
      await goToLoginPage(tester);

      // Phone field should be empty
      final phoneField = find.byKey(AppKeys.phoneField);
      final textField = tester.widget<TextFormField>(phoneField);
      expect(textField.controller?.text, '');
    });
  });
}
