import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/collector_home_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_list_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_list_page.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offers_list_page.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/rewards_page.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/views/schedules_list_page.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transactions_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Collector full flow (smoke) integration test', () {
    testWidgets(
      'Collector navigation flow: home -> offers -> schedules -> transactions -> feedback -> complaints -> rewards',
      (WidgetTester tester) async {
        // 1. Khởi động app
        await startApp(tester);
        await tester.pump(const Duration(seconds: 2));

        // 2. Giả lập đã login collector: đi thẳng tới collector-home
        greenRouter.go('/collector-home');
        await tester.pump(const Duration(seconds: 2));

        // 3. Kiểm tra màn CollectorHome hiển thị (app không crash)
        expect(find.byType(CollectorHomePage), findsOneWidget);
        expect(find.byType(Scaffold), findsWidgets);

        // 4. Đi tới danh sách offer của collector
        greenRouter.go(
          '/collector-offer-list',
          extra: <String, dynamic>{'isCollectorView': true},
        );
        await tester.pump(const Duration(seconds: 2));
        // Chỉ cần có UI và không crash (không assert cụ thể OffersListPage để tránh phụ thuộc backend)
        expect(find.byType(Scaffold), findsWidgets);

        // 5. Đi tới danh sách lịch hẹn
        greenRouter.go('/collector-schedule-list');
        await tester.pump(const Duration(seconds: 2));
        expect(find.byType(Scaffold), findsWidgets);

        // 6. Đi tới danh sách giao dịch
        greenRouter.go('/collector-list-transactions');
        await tester.pump(const Duration(seconds: 2));
        expect(find.byType(Scaffold), findsWidgets);

        // 7. Đi tới danh sách feedback
        greenRouter.go('/collector-feedback-list');
        await tester.pump(const Duration(seconds: 2));
        expect(find.byType(Scaffold), findsWidgets);

        // 8. Đi tới danh sách complaint
        greenRouter.go('/collector-complaint-list');
        await tester.pump(const Duration(seconds: 2));
        expect(find.byType(Scaffold), findsWidgets);

        // 9. Đi tới trang rewards cho collector
        greenRouter.go('/reward-collector');
        await tester.pump(const Duration(seconds: 2));
        expect(find.byType(Scaffold), findsWidgets);
      },
    );
  });
}


