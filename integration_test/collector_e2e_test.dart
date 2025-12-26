
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_actions.dart';
import 'helpers/finders.dart';
import 'helpers/test_utils.dart';

import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/collector_home_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/create_feedback_page.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offer_detail_page.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transaction_detail_page_modern.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Core E2E Flow (hybrid: UI login + API actions)', () {
    testWidgets(
      'Household creates post -> Collector creates offer -> Household accepts -> Collector check-in & input details -> Household completes -> feedback page',
      (WidgetTester tester) async {
        const String collectorPhone = '0367355275';
        const String collectorOtp = '123456';
        const String householdPhone = '0779646337';
        const String householdOtp = '123456';

        const double latitude = 10.776889;
        const double longitude = 106.700806;

        late final ApiClient apiClient;
        late final TokenStorageService tokenStorage;

        Future<void> logoutToWelcome() async {
          await tokenStorage.clearAuthData();
          try {
            await FirebaseAuth.instance.signOut();
          } catch (_) {}
          greenRouter.go('/');
          await tester.pump(const Duration(seconds: 2));
          await tester.pumpUntilFound(
            find.byKey(AppKeys.goLogin),
            timeout: const Duration(seconds: 30),
          );
        }

        Future<void> loginAs({
          required String phone,
          required String otp,
          required Type expectedHome,
        }) async {
          await logoutToWelcome();
          await performLogin(tester, phone: phone, otp: otp);
          await tester.pump(const Duration(seconds: 2));
          await tester.pumpUntilFound(
            find.byType(expectedHome),
            timeout: const Duration(seconds: 60),
          );
          expect(
            find.byType(expectedHome),
            findsOneWidget,
          );
        }

        Future<T> retry<T>(
          Future<T> Function() fn, {
          Duration timeout = const Duration(seconds: 60),
          Duration interval = const Duration(seconds: 2),
          bool Function(T value)? until,
        }) async {
          final endAt = DateTime.now().add(timeout);
          T lastValue = await fn();
          while (DateTime.now().isBefore(endAt)) {
            if (until != null && until(lastValue)) {
              return lastValue;
            }
            await Future<void>.delayed(interval);
            lastValue = await fn();
          }
          return lastValue;
        }

        String normalizeStatus(String? status) {
          if (status == null) return '';
          return status.trim().toLowerCase().replaceAll('_', '');
        }

        String? extractIdFromResponse(
          dynamic data,
          List<String> candidateKeys,
        ) {
          if (data is Map) {
            for (final key in candidateKeys) {
              final value = data[key];
              if (value is String && value.isNotEmpty) return value;
            }
            if (data['data'] is Map) {
              for (final key in candidateKeys) {
                final value = (data['data'] as Map)[key];
                if (value is String && value.isNotEmpty) return value;
              }
            }
          }
          return null;
        }

        Future<int> getAnyScrapCategoryId() async {
          final res = await apiClient.get(
            '/v1/scrap-categories',
            queryParameters: {'pageNumber': 1, 'pageSize': 1},
          );
          final data = res.data;
          if (data is Map && data['data'] is List && (data['data'] as List).isNotEmpty) {
            final first = (data['data'] as List).first;
            if (first is Map && first['scrapCategoryId'] is int) {
              return first['scrapCategoryId'] as int;
            }
            if (first is Map && first['id'] is int) {
              return first['id'] as int;
            }
          }
          throw StateError('Could not fetch scrapCategoryId from /v1/scrap-categories');
        }

        Future<String> createPost({
          required int scrapCategoryId,
          required String title,
        }) async {
          final body = {
            'title': title,
            'description': 'E2E auto post',
            'address': 'E2E Address',
            'availableTimeRange': 'E2E time range',
            'location': {'longitude': longitude, 'latitude': latitude},
            'mustTakeAll': false,
            'scrapPostDetails': [
              {
                'scrapCategoryId': scrapCategoryId,
                'amountDescription': '1 kg',
                'imageUrl': 'https://media.vietnamplus.vn/images/fbc23bef0d088b23a8965bce49f85a61cd286afccaf9606b44256f5d7ef5d5fefff6aa780c9464f6499f791f5dd6f3de1d175058d9a59d4e21100ddb41c54c45/ngaymoitruong_12.jpg',
              },
            ],
          };

          final res = await apiClient.post('/v1/posts', data: body);
          final postId = extractIdFromResponse(res.data, ['scrapPostId', 'id']);
          if (postId != null) return postId;

          final lookup = await apiClient.get(
            '/v1/posts/my-posts',
            queryParameters: {
              'title': title,
              'pageNumber': 1,
              'pageSize': 5,
            },
          );
          final lookupData = lookup.data;
          if (lookupData is Map && lookupData['data'] is List) {
            for (final item in (lookupData['data'] as List)) {
              if (item is Map) {
                final id = item['scrapPostId'];
                if (id is String && id.isNotEmpty) return id;
              }
            }
          }

          throw StateError('Post created but scrapPostId could not be resolved');
        }

        Future<String> createOffer({
          required String postId,
          required int scrapCategoryId,
        }) async {
          final body = {
            'offerDetails': [
              {
                'scrapCategoryId': scrapCategoryId,
                'pricePerUnit': 1000.0,
                'unit': 'kg',
              },
            ],
            'scheduleProposal': {
              'proposedTime': DateTime.now().add(const Duration(hours: 1)).toUtc().toIso8601String(),
              'responseMessage': 'E2E schedule proposal',
            },
          };

          final res = await apiClient.post(
            '/v1/posts/$postId/offers',
            data: body,
          );
          final offerId = extractIdFromResponse(
            res.data,
            ['collectionOfferId', 'offerId', 'id'],
          );
          if (offerId == null) {
            throw StateError('Offer created but offerId could not be resolved');
          }
          return offerId;
        }

        Future<void> acceptOffer({required String offerId}) async {
          await apiClient.patch('/v1/offers/$offerId/process?isAccepted=true');
        }

        Future<Map<String, dynamic>> getFirstTransactionByOfferId(
          String offerId,
        ) async {
          final res = await apiClient.get(
            '/v1/offers/$offerId/transactions',
            queryParameters: {'pageNumber': 1, 'pageSize': 10},
          );
          final data = res.data;
          if (data is Map && data['data'] is List && (data['data'] as List).isNotEmpty) {
            final first = (data['data'] as List).first;
            if (first is Map<String, dynamic>) return first;
            if (first is Map) return Map<String, dynamic>.from(first);
          }
          return <String, dynamic>{};
        }

        Future<Map<String, dynamic>> getTransactionDetail(String transactionId) async {
          final res = await apiClient.get('/v1/transactions/$transactionId');
          final data = res.data;
          if (data is Map<String, dynamic>) return data;
          if (data is Map) return Map<String, dynamic>.from(data);
          return <String, dynamic>{};
        }

        Future<void> checkIn({required String transactionId}) async {
          await apiClient.patch(
            '/v1/transactions/$transactionId/check-in',
            data: {'longitude': longitude, 'latitude': latitude},
          );
        }

        Future<void> inputDetails({
          required String transactionId,
          required int scrapCategoryId,
        }) async {
          await apiClient.post(
            '/v1/transactions/$transactionId/details',
            data: [
              {
                'scrapCategoryId': scrapCategoryId,
                'pricePerUnit': 1000.0,
                'unit': 'kg',
                'quantity': 1.0,
              },
            ],
          );
        }

        Future<void> completeTransaction({required String transactionId}) async {
          await apiClient.patch(
            '/v1/transactions/$transactionId/process?isAccepted=true',
          );
        }

        // ===================== START APP =====================
        await startApp(tester);

        apiClient = sl<ApiClient>();
        tokenStorage = sl<TokenStorageService>();

        // ===================== HOUSEHOLD: LOGIN & CREATE POST =====================
        await loginAs(
          phone: householdPhone,
          otp: householdOtp,
          expectedHome: HouseHoldHome,
        );

        final scrapCategoryId = await getAnyScrapCategoryId();
        final uniqueTitle = 'E2E Post ${DateTime.now().millisecondsSinceEpoch}';
        final postId = await createPost(
          scrapCategoryId: scrapCategoryId,
          title: uniqueTitle,
        );

        // ===================== COLLECTOR: LOGIN & CREATE OFFER =====================
        await loginAs(
          phone: collectorPhone,
          otp: collectorOtp,
          expectedHome: CollectorHomePage,
        );

        final offerId = await createOffer(
          postId: postId,
          scrapCategoryId: scrapCategoryId,
        );

        greenRouter.go(
          '/offer-detail',
          extra: {'offerId': offerId, 'isCollectorView': true},
        );
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpUntilFound(
          find.byType(OfferDetailPage),
          timeout: const Duration(seconds: 60),
        );

        // ===================== HOUSEHOLD: LOGIN & ACCEPT OFFER =====================
        await loginAs(
          phone: householdPhone,
          otp: householdOtp,
          expectedHome: HouseHoldHome,
        );
        await acceptOffer(offerId: offerId);

        final tx = await retry<Map<String, dynamic>>(
          () => getFirstTransactionByOfferId(offerId),
          timeout: const Duration(seconds: 90),
          interval: const Duration(seconds: 3),
          until: (value) => (value['transactionId'] is String) && (value['transactionId'] as String).isNotEmpty,
        );
        final transactionId = tx['transactionId'] as String?;
        expect(transactionId, isNotNull);

        // ===================== COLLECTOR: LOGIN, CHECK-IN & INPUT DETAILS =====================
        await loginAs(
          phone: collectorPhone,
          otp: collectorOtp,
          expectedHome: CollectorHomePage,
        );

        await checkIn(transactionId: transactionId!);
        await retry<Map<String, dynamic>>(
          () => getTransactionDetail(transactionId),
          timeout: const Duration(seconds: 90),
          interval: const Duration(seconds: 3),
          until: (value) => normalizeStatus(value['status'] as String?) == 'inprogress',
        );

        await inputDetails(
          transactionId: transactionId,
          scrapCategoryId: scrapCategoryId,
        );

        // ===================== HOUSEHOLD: LOGIN & COMPLETE TRANSACTION =====================
        await loginAs(
          phone: householdPhone,
          otp: householdOtp,
          expectedHome: HouseHoldHome,
        );

        await completeTransaction(transactionId: transactionId);
        await retry<Map<String, dynamic>>(
          () => getTransactionDetail(transactionId),
          timeout: const Duration(seconds: 90),
          interval: const Duration(seconds: 3),
          until: (value) => normalizeStatus(value['status'] as String?) == 'completed',
        );

        // ===================== VERIFY UI: TRANSACTION DETAIL -> CREATE FEEDBACK =====================
        greenRouter.go(
          '/transaction-detail',
          extra: {'transactionId': transactionId},
        );
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpUntilFound(
          find.byType(TransactionDetailPageModern),
          timeout: const Duration(seconds: 60),
        );

        greenRouter.go(
          '/create-feedback',
          extra: {'transactionId': transactionId},
        );
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpUntilFound(
          find.byType(CreateFeedbackPage),
          timeout: const Duration(seconds: 60),
        );
      },
    );
  });
}
