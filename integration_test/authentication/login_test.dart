import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/app_actions.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Auth - Login Flow', () {
    testWidgets('Should login successfully with valid credentials', (
      tester,
    ) async {
      await startApp(tester);

      await performLogin(tester, phone: '+840987654321', otp: '123456');

      expect(find.text('Welcome back!'), findsOneWidget);
    });

    testWidgets('Should show error with invalid credentials', (tester) async {
      await startApp(tester);

      await performLogin(
        tester,
        phone: '+840987654321',
        otp: 'wrongotp',
      );

      expect(find.text('Invalid phone number or OTP'), findsOneWidget);
    });
  });
}
