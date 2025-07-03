import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boilerplate_template/shared/exceptions/permission_exceptions.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:boilerplate_template/features/connectivity/controllers/connectivity_controller.dart';
import 'package:boilerplate_template/features/notifications/controllers/local_notifications_controller.dart';
import 'package:boilerplate_template/shared/permissions/controllers/permission_controller.dart';
import 'package:boilerplate_template/shared/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:boilerplate_template/shared/providers/shared_providers.dart';
import 'package:boilerplate_template/features/admin/widgets/connectivity_status_card.dart';
import 'package:boilerplate_template/features/admin/widgets/permission_test_card.dart';
import 'package:boilerplate_template/features/admin/widgets/notification_test_card.dart';

class AdminTestsPage extends ConsumerWidget {
  const AdminTestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityControllerProvider);
    final permissionStatus = ref.watch(permissionControllerProvider);
    final localNotificationsState =
        ref.watch(localNotificationsControllerProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.marginMedium,
        children: [
          // En-tête de la page
          Card(
            child: Padding(
              padding: EdgeInsets.all(context.paddingMedium),
              child: Column(
                spacing: context.marginSmall,
                children: [
                  const Icon(Icons.bug_report, size: 48, color: Colors.orange),
                  Text(
                    'Tests des fonctionnalités',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Tests et diagnostics des différents services de l\'application',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Connectivity status
          ConnectivityStatusCard(connectivityState: connectivityState),

          // Permission testing
          PermissionTestCard(
            permissionStatus: permissionStatus,
            onRequestPermission: () async {
              try {
                final result = await ref
                    .read(permissionControllerProvider.notifier)
                    .handlePermission(PermissionType.camera);

                if (!result && context.mounted) {
                  final dialogService =
                      ref.read(permissionDialogServiceProvider);
                  await dialogService.showPermissionSettingsDialog(
                    context,
                    'Camera permission is required for this feature',
                  );
                }
              } on PermissionException catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toLocalizedMessage(context)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),

          // Notification testing
          NotificationTestCard(
            localNotificationsState: localNotificationsState,
            onShowNotification: () async {
              try {
                await ref
                    .read(localNotificationsControllerProvider.notifier)
                    .showSimpleNotification(
                      'Test Notification',
                      'This is a test notification from the app!',
                      payload: 'test_payload',
                    );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to show notification: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            onScheduleNotification: () async {
              try {
                final scheduledTime =
                    DateTime.now().add(const Duration(seconds: 5));
                await ref
                    .read(localNotificationsControllerProvider.notifier)
                    .scheduleNotification(
                      'Scheduled Notification',
                      'This notification was scheduled 5 seconds ago!',
                      scheduledTime,
                      payload: 'scheduled_payload',
                    );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Notification scheduled for 5 seconds from now'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to schedule notification: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
