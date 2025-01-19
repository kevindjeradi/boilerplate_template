import 'package:boilerplate_template/features/notifications/controllers/local_notifications_controller.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:boilerplate_template/common/error_handling/services/error_handling_service.dart';
import 'package:boilerplate_template/common/permissions/controllers/permission_controller.dart';
import 'package:boilerplate_template/common/permissions/interfaces/i_permission_service.dart';
import 'package:boilerplate_template/common/theme/app_theme.dart';
import 'package:boilerplate_template/common/user/controllers/user_controller.dart';
import 'package:boilerplate_template/common/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/common/user/services/user_service.dart';
import 'package:boilerplate_template/features/api/controllers/api_controller.dart';
import 'package:boilerplate_template/features/api/interfaces/i_api_service.dart';
import 'package:boilerplate_template/features/api/services/api_service.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/interfaces/i_auth_service.dart';
import 'package:boilerplate_template/features/auth/screens/auth_screen.dart';
import 'package:boilerplate_template/features/auth/services/auth_service.dart';
import 'package:boilerplate_template/features/connectivity/controllers/connectivity_controller.dart';
import 'package:boilerplate_template/features/connectivity/interfaces/i_connectivity_service.dart';
import 'package:boilerplate_template/features/connectivity/services/connectivity_service.dart';
import 'package:boilerplate_template/features/notifications/controllers/push_notifications_controller.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_push_notifications_service.dart';
import 'package:boilerplate_template/features/notifications/services/local_notifications_service.dart';
import 'package:boilerplate_template/features/notifications/services/push_notifications_service.dart';
import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:boilerplate_template/firebase_options.dart';
import 'package:boilerplate_template/home_screen.dart';
import 'package:boilerplate_template/router/app_router.dart';
import 'package:boilerplate_template/storage/local_storage/interfaces/i_storage_service.dart';
import 'package:boilerplate_template/storage/local_storage/services/storage_service.dart';

import 'common/permissions/services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await dotenv.load(fileName: ".env");
  final String? googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final userService = UserService();
  final authService = AuthService(userService);
  final errorHandlingService = ErrorHandlingService();

  Get.lazyPut<IStorageService>(() => StorageService(prefs));
  Get.lazyPut<IConnectivityService>(() => ConnectivityService());
  Get.lazyPut<IApiService>(() => ApiService(prefs));
  Get.lazyPut<IUserService>(() => UserService());
  Get.lazyPut<IAuthService>(() => AuthService(
        Get.find<IUserService>(),
        googleSignIn: GoogleSignIn(
          clientId: googleClientId,
        ),
      ));
  Get.lazyPut<ErrorHandlingService>(() => ErrorHandlingService());
  Get.lazyPut<IPermissionService>(() => PermissionService());
  Get.lazyPut<ILocalNotificationsService>(() => LocalNotificationsService());
  Get.lazyPut<IPushNotificationsService>(() => PushNotificationsService());

  Get.lazyPut<UserController>(() => UserController(Get.find<IUserService>()));
  await Get.putAsync<SettingsController>(() async {
    final controller = SettingsController(Get.find<IStorageService>());
    await controller.loadSettings();
    return controller;
  });
  Get.lazyPut<ApiController>(() => ApiController(
        Get.find<IApiService>(),
        Get.find<ErrorHandlingService>(),
      ));
  Get.put(ConnectivityController(Get.find()));
  Get.put(AuthController(authService, errorHandlingService, Get.find()));
  Get.put(PermissionController(Get.find()));
  Get.put(LocalNotificationsController(Get.find<ILocalNotificationsService>()));
  Get.put(PushNotificationsController(Get.find<IPushNotificationsService>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();
    final AuthController authController = Get.find();

    return GetMaterialApp(
      title: 'Flutter App Boilerplate',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingsController.currentLocale.value,
      getPages: AppRouter.routes,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsController.themeMode.value,
      home: Obx(() {
        return authController.user.value != null
            ? const HomeScreen()
            : AuthScreen();
      }),
    );
  }
}
