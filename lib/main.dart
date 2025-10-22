import 'package:GreenConnectMobile/core/config/app_theme.dart';
import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/presentation/providers/settings_provider.dart';
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
    final settingsState = ref.watch(settingsProvider);
    return settingsState.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error loading settings: $error')),
        ),
      ),
      data: (settings) {
        return MaterialApp.router(
          title: 'GConnect',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: settings.theme == AppTheme.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          locale: Locale(settings.languageCode),
          supportedLocales: const [Locale('vi'), Locale('en')],
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: greenRouter,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
