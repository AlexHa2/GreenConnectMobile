import 'package:GreenConnectMobile/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'finders.dart';

Future<void> performLogin(
  WidgetTester tester, {
  required String phone,
  required String otp,
}) async {
  await tester.pumpWidget(const GreenConnectApp());
  await tester.pump(const Duration(seconds: 2));

  /// Chuyển sang trang Login
  final fab = find.byKey(const ValueKey(AppKeys.goLogin));
  await tester.tap(fab);
  await tester.pump(const Duration(seconds: 2));

  /// Nhập số điện thoại
  final phoneField = find.byKey(const ValueKey(AppKeys.phoneField));
  await tester.enterText(phoneField, phone);

  /// Bấm gửi OTP
  await tester.tap(find.byKey(const ValueKey(AppKeys.sendOtpButton)));
  await tester.pump(const Duration(seconds: 2));

  /// Sau khi OTP form hiển thị, nhập mã OTP
  await tester.enterText(find.byKey(const ValueKey(AppKeys.otpField)), otp);

  /// Bấm nút Login
  await tester.tap(find.byKey(const ValueKey(AppKeys.loginButton))); // nếu có
  await tester.pump(const Duration(seconds: 2));
}
