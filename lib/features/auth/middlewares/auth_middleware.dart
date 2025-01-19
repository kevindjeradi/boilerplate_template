import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find();
    return authController.user.value == null
        ? const RouteSettings(name: '/auth')
        : null;
  }
}
