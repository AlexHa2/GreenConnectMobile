import 'package:GreenConnectMobile/core/helper/app_router_observer.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/household_list_post.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/post_detail.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/update_recycling_post.dart';
import 'package:GreenConnectMobile/features/notification/presentation/views/widgets/notification.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setup_page.dart';
import 'package:GreenConnectMobile/features/setting/presentation/views/settings_page.dart';
import 'package:go_router/go_router.dart';

final appRouterObserver = AppRouterObserver();

final GoRouter greenRouter = GoRouter(
  observers: [appRouterObserver],
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HouseHoldHome()),
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
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
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
        final initialData = state.extra as Map<String, dynamic>;
        return UpdateRecyclingPostPage(initialData: initialData);
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
        final initialData = state.extra as Map<String, dynamic>;
        return PostDetailsScreen(initialData: initialData);
      },
    ),
  ],
);
