import 'package:GreenConnectMobile/core/config/app_theme.dart';
import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/features/auth/presentation/views/login_page.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
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
