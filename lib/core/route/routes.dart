import 'package:GreenConnectMobile/core/helper/app_router_observer.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/authentication/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/household_list_post.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/post_detail.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/update_recycling_post.dart';
import 'package:GreenConnectMobile/features/notification/presentation/views/widgets/notification.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setting.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setup_page.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/list_history_post.dart';
import 'package:GreenConnectMobile/features/reward/presentation/views/reward_store.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/confirm_transaction_detail.dart';
import 'package:GreenConnectMobile/features/transaction/presentation/views/transaction_detail.dart';
import 'package:GreenConnectMobile/shared/layouts/main_layout.dart';
import 'package:go_router/go_router.dart';

final appRouterObserver = AppRouterObserver();

final GoRouter greenRouter = GoRouter(
  observers: [appRouterObserver],
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TransactionDetails(),
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: '/profile-settings',
          name: 'profile-settings',
          builder: (context, state) {
            final initialData = state.extra as Map<String, dynamic>? ?? {};
            return ProfileSetting(initialData: initialData);
          },
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
      ],
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
      path: '/reward-store',
      name: 'reward-store',
      builder: (context, state) => const RewardStore(),
    ),
    GoRoute(
      path: '/confirm-transaction',
      name: 'confirm-transaction',
      builder: (context, state) => const ConfirmTransaction(),
    ),
  ],
);
