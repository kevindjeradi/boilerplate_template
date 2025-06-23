import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/core/theme/app_theme.dart';
import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:boilerplate_template/firebase_options.dart';
import 'package:boilerplate_template/core/router/app_router.dart';
import 'package:boilerplate_template/features/auth/services/auth_effects_service.dart';

void main() async {
  // Préserver le splash screen pendant l'initialisation
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  AppLogger.info('🚀 Starting application initialization');

  // Initialize timezone
  tz.initializeTimeZones();
  AppLogger.info('✅ Timezone initialized');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppLogger.info('✅ Firebase initialized');

  // Configure Firebase Crashlytics only on native mobile
  if (!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    AppLogger.info('✅ Crashlytics configured');
  }

  // Load environment variables
  await dotenv.load(fileName: ".env");
  AppLogger.info('✅ Environment variables loaded');

  AppLogger.info('🎯 Starting app with ProviderScope');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AppLogger.info('🎨 Building MyApp widget');

    // Initialiser seulement les effets d'auth (nécessaire)
    ref.watch(authEffectsServiceProvider);

    // Déclencher l'init des settings en arrière-plan SANS rebuild
    ref.read(settingsControllerProvider);

    // Utilisation des providers pour locale et thème
    final router = ref.watch(routerProvider);
    final currentLocale = ref.watch(currentLocaleProvider);
    final currentThemeMode = ref.watch(currentThemeModeProvider);

    return MaterialApp.router(
      title: 'Flutter App Boilerplate',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: currentLocale,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
    );
  }
}
