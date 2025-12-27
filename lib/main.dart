import 'package:GreenConnectMobile/core/config/app_theme.dart';
import 'package:GreenConnectMobile/core/di/injector.dart';
import 'package:GreenConnectMobile/core/helper/navigate_with_loading.dart';
import 'package:GreenConnectMobile/core/route/routes.dart';
import 'package:GreenConnectMobile/features/setting/domain/entities/app_settings.dart';
import 'package:GreenConnectMobile/features/setting/presentation/providers/settings_provider.dart';
import 'package:GreenConnectMobile/generated/l10n.dart';
import 'package:GreenConnectMobile/shared/widgets/custom_leaf_loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:GreenConnectMobile/core/config/firebase_options.dart';
import 'package:GreenConnectMobile/core/network/token_storage.dart';
import 'package:GreenConnectMobile/features/notification/data/services/firebase_messaging_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  initDeepLinkListener();
 
  // Log access token
  final tokenStorage = sl<TokenStorageService>();
  final accessToken = await tokenStorage.getAccessToken();
  debugPrint('ACCESS_TOKEN = $accessToken');


  FlutterError.demangleStackTrace = (stack) => stack;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final fcmService = FirebaseMessagingService();
  await fcmService.initialize(
    onMessageReceived: (message) {},
    onMessageOpenedApp: (message) {},
    onNotificationTap: (data) => fcmService.handleNotificationTapData(data),
  );
  runApp(const ProviderScope(child: GreenConnectApp()));
}

class GreenConnectApp extends ConsumerWidget {
  const GreenConnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return settingsState.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: RotatingLeafLoader())),
      ),
      error: (error, stackTrace) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error loading settings: $error')),
        ),
      ),
      data: (settings) {
        return OverlaySupport.global(
          child: MaterialApp.router(
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
            builder: (context, child) {
              return ValueListenableBuilder<bool>(
                valueListenable: appLoading,
                builder: (context, isLoading, _) {
                  return Stack(
                    children: [
                      child ?? const SizedBox.shrink(),
                      if (isLoading)
                        ColoredBox(
                          color: Theme.of(
                            context,
                          ).scaffoldBackgroundColor.withValues(alpha: 0.8),
                          child: const Center(child: RotatingLeafLoader()),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
