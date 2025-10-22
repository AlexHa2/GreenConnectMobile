import 'package:GreenConnectMobile/features/auth/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/create_post.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/house_hold_home.dart';
import 'package:GreenConnectMobile/features/household/presentation/views/update_recycling_post.dart';
import 'package:GreenConnectMobile/features/profile/presentation/views/profile_setup_page.dart';
import 'package:GreenConnectMobile/features/setting/presentation/views/settings_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter greenRouter = GoRouter(
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
  ],
);
