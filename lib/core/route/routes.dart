import 'package:GreenConnectMobile/core/enum/buyer_type_status.dart';
import 'package:GreenConnectMobile/core/helper/app_router_observer.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/welcome_page.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/collector_home_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_detail_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_list_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/create_complaint_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/create_feedback_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_detail_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_list_page.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/chat_message_detail.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/message.dart';
import 'package:GreenConnectMobile/features/notification/presentation/views/notifications_page.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offer_detail_page.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offers_list_page.dart';
import 'package:GreenConnectMobile/features/package/domain/entities/package_entity.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/package_dashboard_page.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/package_detail_page.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/package_list_page.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/payment_failed_page.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/payment_success_page.dart';
import 'package:GreenConnectMobile/features/package/presentation/views/payment_webview_page.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/collector_list_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/create_post_with_ai.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/household_list_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/post_detail.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/update_recycling_post.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setup.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/upgrade_verification.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/list_history_post.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/my_rewards_page.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/reward_history_page.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/reward_store.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/rewards_page.dart';
import 'package:GreenConnectMobile/features/schedule/presentation/views/schedules_list_page.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/credit_transactions_list_page.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/payment_transactions_list_page.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/qr_code_payment_page.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transaction_detail_page_modern.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transactions_list_page.dart';
import 'package:GreenConnectMobile/shared/layouts/collector_layout.dart';
import 'package:GreenConnectMobile/shared/layouts/household_layout.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final appRouterObserver = AppRouterObserver();
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _householdShellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'householdShell',
);
final _collectorShellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'collectorShell',
);

void initDeepLinkListener() {
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null &&
        uri.scheme == 'greenconnect' &&
        uri.host == 'payment-result') {
      final status = uri.queryParameters['status'];
      if (status == 'success') {
        greenRouter.go('/payment-success');
      } else {
        greenRouter.go('/payment-failed');
      }
    }
  });
}

final GoRouter greenRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  observers: [appRouterObserver],
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _householdShellNavigatorKey,
      builder: (context, state, child) => HouseholdLayout(child: child),
      routes: [
        GoRoute(
          path: '/household-home',
          name: 'household-home',
          builder: (context, state) {
            final initialData = state.extra as Map<String, dynamic>? ?? {};
            return HouseHoldHome(initialData: initialData);
          },
        ),
        GoRoute(
          path: '/rewards',
          name: 'rewards',
          builder: (context, state) => const RewardsPage(),
        ),
        GoRoute(
          path: '/household-list-message',
          name: 'household-list-message',
          builder: (context, state) =>
              const MessageListPage(key: ValueKey('household-message')),
        ),
        GoRoute(
          path: '/household-profile-settings',
          name: 'household-profile-settings',
          builder: (context, state) =>
              const ProfileSetting(key: ValueKey('household-profile')),
        ),
      ],
    ),
    ShellRoute(
      navigatorKey: _collectorShellNavigatorKey,
      builder: (context, state, child) => CollectorLayout(child: child),
      routes: [
        GoRoute(
          path: '/collector-home',
          name: 'collector-home',
          builder: (context, state) => const CollectorHomePage(),
        ),
        GoRoute(
          path: '/collector-list-post',
          name: 'collector-list-post',
          builder: (context, state) => const CollectorListPostPage(),
        ),

        GoRoute(
          path: '/collector-profile-settings',
          name: 'collector-profile-settings',
          builder: (context, state) =>
              const ProfileSetting(key: ValueKey('collector-profile')),
        ),

        GoRoute(
          path: '/list-message',
          name: 'list-message',
          builder: (context, state) =>
              const MessageListPage(key: ValueKey('collector-message')),
        ),

        // GoRoute(
        //   path: '/collector-detail-post',
        //   name: 'collector-detail-post',
        //   builder: (context, state) {
        //     final initialData = state.extra as Map<String, dynamic>? ?? {};
        //     return PostDetailsPage(initialData: initialData);
        //   },
        // ),
      ],
    ),
    GoRoute(
      path: '/collector-schedule-list',
      name: 'collector-schedule-list',
      builder: (context, state) => const SchedulesListPage(),
    ),
    GoRoute(
      path: '/collector-list-transactions',
      name: 'collector-list-transactions',
      builder: (context, state) =>
          const TransactionsListPage(key: ValueKey('collector-transactions')),
    ),

    GoRoute(
      path: '/collector-list-credit-transactions',
      name: 'collector-list-credit-transactions',
      builder: (context, state) => const CreditTransactionsListPage(
        key: ValueKey('collector-credit-transactions'),
      ),
    ),

    GoRoute(
      path: '/collector-feedback-list',
      name: 'collector-feedback-list',
      builder: (context, state) =>
          const FeedbackListPage(key: ValueKey('collector-feedback')),
    ),
    GoRoute(
      path: '/collector-complaint-list',
      name: 'collector-complaint-list',
      builder: (context, state) =>
          const ComplaintListPage(key: ValueKey('collector-complaint')),
    ),
    GoRoute(
      path: '/collector-offer-list',
      name: 'collector-offer-list',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return OffersListPage(
          key: const ValueKey('collector-offers'),
          postId: initialData['postId'] as String?,
          isCollectorView: initialData['isCollectorView'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/household-list-post',
      name: 'household-list-post',
      builder: (context, state) => const HouseholdListPostPage(),
    ),
    GoRoute(
      path: '/household-list-transactions',
      name: 'household-list-transactions',
      builder: (context, state) =>
          const TransactionsListPage(key: ValueKey('household-transactions')),
    ),
    GoRoute(
      path: '/household-feedback-list',
      name: 'household-feedback-list',
      builder: (context, state) =>
          const FeedbackListPage(key: ValueKey('household-feedback')),
    ),
    GoRoute(
      path: '/household-complaint-list',
      name: 'household-complaint-list',
      builder: (context, state) =>
          const ComplaintListPage(key: ValueKey('household-complaint')),
    ),
    GoRoute(
      path: '/detail-post',
      name: 'detail-post',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return PostDetailsPage(initialData: initialData);
      },
    ),
    GoRoute(
      path: '/create-post',
      name: 'create-post',
      builder: (context, state) => const CreateRecyclingPostPage(),
    ),
    GoRoute(
      path: '/create-post-with-ai',
      name: 'create-post-with-ai',
      builder: (context, state) => const CreateRecyclingPostWithAIPage(),
    ),
    GoRoute(
      path: '/update-post',
      name: 'update-post',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return UpdateRecyclingPostPage(initialData: initialData);
      },
    ),
    GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/setup-profile',
      name: 'setup-profile',
      builder: (context, state) => const ProfileSetupPage(),
    ),
    GoRoute(
      path: '/post-history',
      name: 'post-history',
      builder: (context, state) => const HouseholdRewardHistory(),
    ),
    GoRoute(
      path: '/credit-transaction-history',
      name: 'credit-transaction-history',
      builder: (context, state) => const CreditTransactionsListPage(),
    ),
    GoRoute(
      path: '/payment-transaction-history',
      name: 'payment-transaction-history',
      builder: (context, state) => const PaymentTransactionsListPage(),
    ),
    GoRoute(
      path: '/package-dashboard',
      name: 'package-dashboard',
      builder: (context, state) => const PackageDashboardPage(),
    ),
    GoRoute(
      name: 'chat-detail',
      path: '/chat-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return ChatDetailPage(
          key: ValueKey(initialData['chatRoomId']),
          transactionId: initialData['transactionId'] as String,
          chatRoomId: initialData['chatRoomId'] as String,
          partnerName: initialData['partnerName'] as String,
          partnerAvatar: initialData['partnerAvatar'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/offers-list',
      name: 'offers-list',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return OffersListPage(
          key: const ValueKey('general-offers'),
          postId: initialData['postId'] as String?,
          isCollectorView: initialData['isCollectorView'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/transaction-detail',
      name: 'transaction-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return TransactionDetailPageModern(
          transactionId: initialData['transactionId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/feedback-detail',
      name: 'feedback-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return FeedbackDetailPage(
          feedbackId: initialData['feedbackId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/create-feedback',
      name: 'create-feedback',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return CreateFeedbackPage(
          transactionId: initialData['transactionId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/complaint-detail',
      name: 'complaint-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return ComplaintDetailPage(
          complaintId: initialData['complaintId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/create-complaint',
      name: 'create-complaint',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return CreateComplaintPage(
          transactionId: initialData['transactionId'] as String,
        );
      },
    ),
    GoRoute(
      path: '/offer-detail',
      name: 'offer-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return OfferDetailPage(
          offerId: initialData['offerId'] as String,
          isCollectorView: initialData['isCollectorView'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/reward-store',
      name: 'reward-store',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RewardStore(),
    ),
    GoRoute(
      path: '/my-rewards',
      name: 'my-rewards',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MyRewardsPage(),
    ),
    GoRoute(
      path: '/reward-history',
      name: 'reward-history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RewardHistoryPage(),
    ),
    GoRoute(
      path: '/upgrade-verification',
      name: 'upgrade-verification',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final initialBuyerType = extra?['initialBuyerType'] as BuyerTypeStatus?;
        return UpgradeVerificationPage(initialBuyerType: initialBuyerType);
      },
    ),
    GoRoute(
      path: '/package-list',
      name: 'package-list',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PackageListPage(),
    ),
    GoRoute(
      path: '/package-detail',
      name: 'package-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        final package = initialData['package'] as PackageEntity;
        return PackageDetailPage(package: package);
      },
    ),
    GoRoute(
      path: '/payment-webview',
      name: 'payment-webview',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PaymentWebViewPage(
          paymentUrl: data['paymentUrl'] as String,
          transactionRef: data['transactionRef'] as String?,
          packageName: data['packageName'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/qr-payment',
      name: 'qr-payment',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return QRCodePaymentPage(
          transactionId: data['transactionId'] as String,
          onActionCompleted: data['onActionCompleted'] as VoidCallback,
        );
      },
    ),
    GoRoute(
      path: '/payment-success',
      name: 'payment-success',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentSuccessPage(paymentInfo: extra);
      },
    ),
    GoRoute(
      path: '/payment-failed',
      name: 'payment-failed',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentFailedPage(paymentInfo: extra);
      },
    ),
    GoRoute(
      path: '/reward-collector',
      name: 'reward-collector',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>?;

        return RewardsPage(
          isCollectorView: initialData?['isCollectorView'] as bool? ?? true,
        );
      },
    ),
  ],
);
