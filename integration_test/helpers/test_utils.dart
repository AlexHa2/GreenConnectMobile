// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:GreenConnectMobile/main.dart' as app;

// Future<void> startApp(WidgetTester tester) async {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   app.main();
//   await tester.pumpAndSettle();
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:GreenConnectMobile/main.dart' as app;

/// Start app for integration test (NO pumpAndSettle)
Future<void> startApp(WidgetTester tester) async {
  app.main();

  // render frame đầu tiên
  await tester.pump();

  // chờ router + DI + Firebase (nếu có)
  await tester.pump(const Duration(seconds: 2));
}

/// Chờ widget xuất hiện (thay cho pumpAndSettle)
extension PumpUntil on WidgetTester {
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
    Duration step = const Duration(milliseconds: 300),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await pump(step);
      if (finder.evaluate().isNotEmpty) return;
    }

    throw TestFailure(
      'Timeout waiting for widget: $finder',
    );
  }
}

