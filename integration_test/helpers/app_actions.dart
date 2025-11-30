import 'package:flutter_test/flutter_test.dart';

import 'finders.dart';

/// Navigate to Login page from Welcome screen
Future<void> goToLoginPage(WidgetTester tester) async {
  final loginButton = find.byKey(AppKeys.goLogin);
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

/// Enter phone number in phone field
Future<void> enterPhoneNumber(WidgetTester tester, String phone) async {
  final phoneField = find.byKey(AppKeys.phoneField);
  await tester.enterText(phoneField, phone);
  await tester.pumpAndSettle();
}

/// Tap send OTP button
Future<void> tapSendOtp(WidgetTester tester) async {
  final sendButton = find.byKey(AppKeys.sendOtpButton);
  await tester.tap(sendButton);
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// Enter OTP code (auto-submits when 6 digits entered)
Future<void> enterOtp(WidgetTester tester, String otp) async {
  final otpField = find.byKey(AppKeys.otpField);
  await tester.enterText(otpField, otp);
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

/// Complete full login flow
Future<void> performLogin(
  WidgetTester tester, {
  required String phone,
  required String otp,
}) async {
  await goToLoginPage(tester);
  await enterPhoneNumber(tester, phone);
  await tapSendOtp(tester);
  await enterOtp(tester, otp);
}
