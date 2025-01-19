import 'package:get/get.dart';

import 'package:boilerplate_template/features/auth/middlewares/auth_middleware.dart';
import 'package:boilerplate_template/features/auth/screens/auth_screen.dart';
import 'package:boilerplate_template/features/settings/screens/settings_screen.dart';
import 'package:boilerplate_template/home_screen.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: '/auth',
      page: () => AuthScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
      middlewares: [AuthMiddleware()],
      transition: Transition.downToUp,
    ),
    GetPage(
      name: '/settings',
      page: () => const SettingsScreen(),
      middlewares: [AuthMiddleware()],
      transition: Transition.upToDown,
    ),
  ];
}
