import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:GreenConnectMobile/main.dart' as app;

Future<void> startApp(WidgetTester tester) async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  await tester.pumpAndSettle();
}
