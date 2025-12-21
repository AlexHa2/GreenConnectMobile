// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// import '../helpers/app_actions.dart';
// import '../helpers/finders.dart';
// import '../helpers/test_utils.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('App Startup and Basic UI', () {
//     testWidgets('Should start app successfully', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // App should start without crashing
//       expect(find.byType(MaterialApp), findsOneWidget,
//           reason: 'MaterialApp should be present');
//     });

//     testWidgets('Should show welcome screen with login button',
//         (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Should show login button on welcome screen
//       final loginButton = find.byKey(AppKeys.goLogin);
//       expect(loginButton, findsOneWidget,
//           reason: 'Login button should be visible on welcome screen');
//     });

//     testWidgets('Should navigate to login page', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Tap login button
//       await goToLoginPage(tester);

//       // Should show login page elements
//       expect(find.byKey(AppKeys.phoneField), findsOneWidget,
//           reason: 'Phone field should be visible on login page');
//       expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget,
//           reason: 'Send OTP button should be visible');
//     });

//     testWidgets('Should have back button on login page', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Should have back button
//       expect(find.byIcon(Icons.arrow_back), findsOneWidget,
//           reason: 'Back button should be present');

//       // Tap back button
//       await tester.tap(find.byIcon(Icons.arrow_back));
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // Should be back on welcome screen
//       expect(find.byKey(AppKeys.goLogin), findsOneWidget,
//           reason: 'Should navigate back to welcome screen');
//     });
//   });

//   group('Phone Input Basic Functionality', () {
//     testWidgets('Should display phone input field', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Phone field should be visible
//       expect(find.byKey(AppKeys.phoneField), findsOneWidget);
//       expect(find.byType(TextFormField), findsWidgets);
//     });

//     testWidgets('Should accept phone number input', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Enter phone number
//       await enterPhoneNumber(tester, '0987654321');
//       await tester.pumpAndSettle();

//       // Verify input was entered
//       final phoneField = find.byKey(AppKeys.phoneField);
//       final textField = tester.widget<TextFormField>(phoneField);
//       expect(textField.controller?.text, '0987654321',
//           reason: 'Phone field should contain entered text');
//     });

//     testWidgets('Should clear phone input on back navigation', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Enter phone
//       await enterPhoneNumber(tester, '0987654321');
//       await tester.pumpAndSettle();

//       // Go back
//       await tester.tap(find.byIcon(Icons.arrow_back));
//       await tester.pumpAndSettle(const Duration(seconds: 2));

//       // Return to login
//       await goToLoginPage(tester);

//       // Field should be empty
//       final phoneField = find.byKey(AppKeys.phoneField);
//       final textField = tester.widget<TextFormField>(phoneField);
//       expect(textField.controller?.text, '',
//           reason: 'Phone field should be cleared after back navigation');
//     });

//     testWidgets('Should show send OTP button', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Send OTP button should be visible
//       expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget,
//           reason: 'Send OTP button should be displayed');
//     });
//   });

//   group('UI Widgets and Layout', () {
//     testWidgets('Should find all expected widgets on login page',
//         (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));
//       await goToLoginPage(tester);

//       // Check all key widgets exist
//       expect(find.byType(Scaffold), findsWidgets);
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.byKey(AppKeys.phoneField), findsOneWidget);
//       expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
//       expect(find.byIcon(Icons.arrow_back), findsOneWidget);
//     });

//     testWidgets('Should have proper app structure', (tester) async {
//       await startApp(tester);
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Verify basic Flutter app structure
//       expect(find.byType(MaterialApp), findsOneWidget);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });

  
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_actions.dart';
import '../helpers/finders.dart';
import '../helpers/test_utils.dart';

void main() {
  group('App Startup and Navigation', () {
    testWidgets('App starts successfully', (tester) async {
      await startApp(tester);

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Welcome screen shows login button', (tester) async {
      await startApp(tester);

      expect(find.byKey(AppKeys.goLogin), findsOneWidget);
    });

    testWidgets('Navigate to login page', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      expect(find.byKey(AppKeys.phoneField), findsOneWidget);
      expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
    });

    testWidgets('Back button returns to welcome screen', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byKey(AppKeys.goLogin), findsOneWidget);
    });
  });

  group('Phone Input Behavior', () {
    testWidgets('Phone field accepts input', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      await enterPhoneNumber(tester, '0987654321');
      await tester.pumpAndSettle();

      // ✅ Correct way to read text in integration test
      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );

      expect(
        editableText.controller.text,
        '0987654321',
        reason: 'Phone input should contain entered number',
      );
    });

    testWidgets('Phone field is cleared after navigating back', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      await enterPhoneNumber(tester, '0987654321');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await goToLoginPage(tester);

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );

      expect(
        editableText.controller.text,
        '',
        reason: 'Phone field should be cleared after back navigation',
      );
    });

    testWidgets('Send OTP button is visible', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
    });
  });

  group('UI Structure Validation', () {
    testWidgets('Login page has required widgets', (tester) async {
      await startApp(tester);
      await goToLoginPage(tester);

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byKey(AppKeys.phoneField), findsOneWidget);
      expect(find.byKey(AppKeys.sendOtpButton), findsOneWidget);
    });
  });
}
