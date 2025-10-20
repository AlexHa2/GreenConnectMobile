import 'package:GreenConnectMobile/core/config/app_theme.dart';
import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/settings/presentation/providers/settings_notifier.dart';
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

class GreenConnectApp extends ConsumerWidget {
  const GreenConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return MaterialApp.router(
      title: 'GConnect',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      locale: Locale(settings.languageCode),
      supportedLocales: const [Locale('vi'), Locale('en')],
      routerConfig: greenRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
