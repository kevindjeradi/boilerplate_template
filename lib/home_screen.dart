import 'package:boilerplate_template/features/notifications/controllers/local_notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:boilerplate_template/common/permissions/controllers/permission_controller.dart';
import 'package:boilerplate_template/common/permissions/enums/permission_type.dart';

import 'common/constants/app_sizes.dart';
import 'features/auth/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final AuthController authController = Get.find();
    final PermissionController permissionController = Get.find();
    final LocalNotificationsController localNotificationsController =
        Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.helloWorld),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed('/settings');
            },
            tooltip: localization.settings,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              localization.welcome,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.marginMedium),
            ElevatedButton(
              onPressed: () {
                authController.signOut();
              },
              child: Text(localization.signOut),
            ),
            const SizedBox(height: AppSizes.marginMedium),
            ElevatedButton(
              onPressed: () => throw Exception(),
              child: const Text("Throw Test Exception"),
            ),
            const SizedBox(height: AppSizes.marginMedium),
            ElevatedButton(
              onPressed: () async {
                bool isGranted = await permissionController
                    .handlePermission(PermissionType.camera);
                if (isGranted) {
                  Get.snackbar(
                      'Permission Granted', 'You can now access the camera.');
                } else {
                  Get.snackbar(
                      'Permission Denied', 'Camera access is required.');
                }
              },
              child: const Text('Request Camera Permission'),
            ),
            const SizedBox(height: AppSizes.marginSmall),
            ElevatedButton(
              onPressed: () {
                localNotificationsController.showSimpleNotification(
                  'Immediate Notification',
                  'This notification appears right away!',
                );
              },
              child: const Text('Show Immediate Local Notification'),
            ),
            const SizedBox(height: AppSizes.marginSmall),
            ElevatedButton(
              onPressed: () {
                final scheduledTime =
                    DateTime.now().add(const Duration(seconds: 5));
                localNotificationsController.scheduleNotification(
                  'Scheduled Notification',
                  'This notification will appear in 5 seconds.',
                  scheduledTime,
                );
              },
              child: const Text('Schedule Local Notification in 5s'),
            ),
            const SizedBox(height: AppSizes.marginMedium),
            Obx(() {
              final payload =
                  localNotificationsController.lastTappedPayload.value;
              return Text(
                'Last local notification payload tapped: $payload',
                style: const TextStyle(fontSize: 16),
              );
            }),
          ],
        ),
      ),
    );
  }
}
