import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/list_history_post.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transactions_list_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_list_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_list_page.dart';
import 'package:GreenConnectMobile/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:GreenConnectMobile/core/config/firebase_options.dart';

void main() {
  // Khởi tạo binding cho integration test
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Household full flow integration test', () {
    setUpAll(() async {
      // Chuẩn bị môi trường giống như hàm main() của app
      await dotenv.load(fileName: ".env");
      await initDependencies();
      initDeepLinkListener();

      FlutterError.demangleStackTrace = (stack) => stack;

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets(
      'Household navigation flow: home -> create post -> history & lists',
      (WidgetTester tester) async {
        // 1. Khởi động app
        await tester.pumpWidget(
          const ProviderScope(
            child: GreenConnectApp(),
          ),
        );
        await tester.pump(const Duration(seconds: 1));

        // 2. Điều hướng thẳng tới Household Home (giả lập sau khi login)
        //    Truyền fullName trong extra giống như login thực tế.
        greenRouter.go(
          '/household-home',
          extra: <String, dynamic>{'fullName': 'Test Household'},
        );
        await tester.pump(const Duration(seconds: 1));

        // 3. Kiểm tra đã điều hướng tới đúng route household-home
        expect(greenRouter.location, '/household-home');
        // Và có widget trang chủ household xuất hiện
        expect(find.byType(HouseHoldHome), findsOneWidget);

        // 4. Điều hướng tới màn tạo bài đăng (create-post)
        greenRouter.go('/create-post');
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(CreateRecyclingPostPage), findsOneWidget);

        // 5. Điều hướng tới lịch sử bài đăng / phần thưởng hộ gia đình
        greenRouter.go('/post-history');
        await tester.pump(const Duration(seconds: 1));
        expect(find.byType(HouseholdRewardHistory), findsOneWidget);

        // 6. Điều hướng tới danh sách giao dịch của household
        greenRouter.go('/household-list-transactions');
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is TransactionsListPage &&
                w.key == const ValueKey('household-transactions'),
          ),
          findsOneWidget,
        );

        // 7. Điều hướng tới danh sách feedback của household
        greenRouter.go('/household-feedback-list');
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is FeedbackListPage &&
                w.key == const ValueKey('household-feedback'),
          ),
          findsOneWidget,
        );

        // 8. Điều hướng tới danh sách complaint của household
        greenRouter.go('/household-complaint-list');
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.byWidgetPredicate(
            (w) =>
                w is ComplaintListPage &&
                w.key == const ValueKey('household-complaint'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}


