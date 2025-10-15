import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_connect_mb/core/config/app_theme.dart';
import 'package:green_connect_mb/core/di/injector.dart';
import 'package:green_connect_mb/features/auth/presentation/views/login_page.dart';
import 'package:green_connect_mb/generated/l10n.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  FlutterError.demangleStackTrace = (stack) {
    return stack;
  };
  runApp(const ProviderScope(child: GreenConnectApp()));
}

class GreenConnectApp extends StatelessWidget {
  const GreenConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Connect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.supportedLocales,
      home: const LoginPage(),
    );
  }
}
