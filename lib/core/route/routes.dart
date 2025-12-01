import 'package:GreenConnectMobile/core/helper/app_router_observer.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/welcome_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_detail_screen.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/complaint_list_page.dart';
import 'package:GreenConnectMobile/features/complaint/presentation/views/create_complaint_screen.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/create_feedback_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_detail_page.dart';
import 'package:GreenConnectMobile/features/feedback/presentation/views/feedback_list_page.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/chat_message_detail.dart';
import 'package:GreenConnectMobile/features/message/presentation/views/message.dart';
import 'package:GreenConnectMobile/features/notification/presentation/views/widgets/notification.dart';
import 'package:GreenConnectMobile/features/offer/presentation/views/offers_list_page.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/collector_list_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/household_list_post.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/post_detail.dart';
import 'package:GreenConnectMobile/features/post/presentation/views/update_recycling_post.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setup.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/upgrade_verification.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/list_history_post.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/reward_store.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transaction_detail_page_modern.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transactions_list_page.dart';
import 'package:GreenConnectMobile/shared/layouts/collector_layout.dart';
import 'package:GreenConnectMobile/shared/layouts/household_layout.dart';
import 'package:go_router/go_router.dart';

final appRouterObserver = AppRouterObserver();

final GoRouter greenRouter = GoRouter(
  observers: [appRouterObserver],
  initialLocation: '/',
  routes: [
    ShellRoute(
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
          path: '/household-notifications',
          name: 'household-notifications',
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: '/household-profile-settings',
          name: 'household-profile-settings',
          builder: (context, state) => const ProfileSetting(),
        ),
        GoRoute(
          path: '/household-list-transactions',
          name: 'household-list-transactions',
          builder: (context, state) => const TransactionsListPage(),
        ),
        GoRoute(
          path: '/household-feedback-list',
          name: 'household-feedback-list',
          builder: (context, state) => const FeedbackListPage(),
        ),
        GoRoute(
          path: '/household-complaint-list',
          name: 'household-complaint-list',
          builder: (context, state) => const ComplaintListPage(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) => CollectorLayout(child: child),
      routes: [
        GoRoute(
          path: '/collector-list-post',
          name: 'collector-list-post',
          builder: (context, state) => const CollectorListPostPage(),
        ),
        GoRoute(
          path: '/collector-profile-settings',
          name: 'collector-profile-settings',
          builder: (context, state) => const ProfileSetting(),
        ),
        GoRoute(
          path: '/collector-list-transactions',
          name: 'collector-list-transactions',
          builder: (context, state) => const TransactionsListPage(),
        ),
        GoRoute(
          path: '/collector-feedback-list',
          name: 'collector-feedback-list',
          builder: (context, state) => const FeedbackListPage(),
        ),
        GoRoute(
          path: '/collector-complaint-list',
          name: 'collector-complaint-list',
          builder: (context, state) => const ComplaintListPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/upgrade-verification',
      name: 'upgrade-verification',
      builder: (context, state) => const UpgradeVerificationScreen(),
    ),
    GoRoute(
      path: '/list-post',
      name: 'list-post',
      builder: (context, state) => const HouseholdListPostScreen(),
    ),
    GoRoute(
      path: '/detail-post',
      name: 'detail-post',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return PostDetailsScreen(initialData: initialData);
      },
    ),
    GoRoute(
      path: '/create-post',
      name: 'create-post',
      builder: (context, state) => const CreateRecyclingPostPage(),
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
      path: '/reward-store',
      name: 'reward-store',
      builder: (context, state) => const RewardStore(),
    ),
    GoRoute(
      path: '/list-message',
      name: 'list-message',
      builder: (context, state) => const MessageListScreen(),
    ),
    GoRoute(
      name: 'chat-detail',
      path: '/chat-detail',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return ChatDetailScreen(initialData: initialData);
      },
    ),
    GoRoute(
      path: '/offers-list',
      name: 'offers-list',
      builder: (context, state) {
        final initialData = state.extra as Map<String, dynamic>? ?? {};
        return OffersListPage(
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
  ],
);
