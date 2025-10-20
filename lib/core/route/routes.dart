import 'package:GreenConnectMobile/features/auth/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/register_page.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/welcome_page.dart';
import 'package:GreenConnectMobile/features/collector/presentation/views/collector_dashboard_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter greenRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/collector/dashboard',
      builder: (context, state) => const CollectorDashboardPage(),
    ),
  ],
);