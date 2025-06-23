import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/core/router/app_router.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/shared/exceptions/permission_exceptions.dart';
import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:boilerplate_template/features/connectivity/controllers/connectivity_controller.dart';
import 'package:boilerplate_template/features/notifications/controllers/local_notifications_controller.dart';
import 'package:boilerplate_template/shared/permissions/controllers/permission_controller.dart';
import 'package:boilerplate_template/shared/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/shared/constants/app_sizes.dart';

import 'package:boilerplate_template/shared/providers/shared_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final connectivityState = ref.watch(connectivityControllerProvider);
    final permissionStatus = ref.watch(permissionControllerProvider);
    final localNotificationsState =
        ref.watch(localNotificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppNavigation.goToSettings(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome message
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.home, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      localization.welcome,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.dashboardDescription,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Connectivity status
            connectivityState.when(
              data: (state) => _buildConnectivityStatus(state),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Loading connectivity...'),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Connectivity error: $error'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Permission testing
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await ref
                      .read(permissionControllerProvider.notifier)
                      .handlePermission(PermissionType.camera);

                  if (!result && context.mounted) {
                    // Show dialog if permission denied
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
              child: const Text('Request Camera Permission'),
            ),

            const SizedBox(height: 8),

            // Permission state display
            _buildPermissionStatus(permissionStatus),

            const SizedBox(height: 16),

            // Local notifications buttons
            ElevatedButton(
              onPressed: () async {
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
              child: const Text('Show Immediate Local Notification'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () async {
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
                        content: Text(
                            'Notification scheduled for 5 seconds from now'),
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
              child: const Text('Schedule Local Notification in 5s'),
            ),

            const SizedBox(height: 8),

            // Notification state display
            localNotificationsState.when(
              data: (state) => _buildNotificationStatus(state),
              loading: () => const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Loading notifications...'),
                ),
              ),
              error: (error, _) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Notification error: $error'),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Auth state display
            _buildAuthStateInfo(authState, context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivityStatus(ConnectivityState connectivityState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connectivity Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  connectivityState is ConnectivityConnected
                      ? Icons.wifi
                      : Icons.wifi_off,
                  color: connectivityState is ConnectivityConnected
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  connectivityState is ConnectivityConnected
                      ? 'Connected (${connectivityState.connectionType.name})'
                      : connectivityState is ConnectivityDisconnected
                          ? 'Disconnected'
                          : 'Checking...',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatus(PermissionStatus permissionStatus) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Permission Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getPermissionIcon(permissionStatus),
                  color: _getPermissionColor(permissionStatus),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_getPermissionText(permissionStatus)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationStatus(LocalNotificationsState notificationsState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getNotificationIcon(notificationsState),
                  color: _getNotificationColor(notificationsState),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_getNotificationText(notificationsState)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => Icons.check_circle,
      PermissionStatus.denied => Icons.cancel,
      PermissionStatus.permanentlyDenied => Icons.block,
      PermissionStatus.requesting => Icons.hourglass_empty,
      PermissionStatus.initial => Icons.help_outline,
    };
  }

  Color _getPermissionColor(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => Colors.green,
      PermissionStatus.denied => Colors.orange,
      PermissionStatus.permanentlyDenied => Colors.red,
      PermissionStatus.requesting => Colors.blue,
      PermissionStatus.initial => Colors.grey,
    };
  }

  String _getPermissionText(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => 'Permission granted',
      PermissionStatus.denied => 'Permission denied',
      PermissionStatus.permanentlyDenied => 'Permission permanently denied',
      PermissionStatus.requesting => 'Requesting permission...',
      PermissionStatus.initial => 'No permission requests yet',
    };
  }

  IconData _getNotificationIcon(LocalNotificationsState state) {
    return switch (state) {
      LocalNotificationsPermissionGranted() => Icons.notifications_active,
      LocalNotificationsPermissionDenied() => Icons.notifications_off,
      LocalNotificationSent() => Icons.send,
      LocalNotificationTapped() => Icons.touch_app,
      _ => Icons.notifications,
    };
  }

  Color _getNotificationColor(LocalNotificationsState state) {
    return switch (state) {
      LocalNotificationsPermissionGranted() => Colors.green,
      LocalNotificationsPermissionDenied() => Colors.red,
      LocalNotificationSent() => Colors.blue,
      LocalNotificationTapped() => Colors.purple,
      _ => Colors.grey,
    };
  }

  String _getNotificationText(LocalNotificationsState state) {
    return switch (state) {
      LocalNotificationsPermissionGranted() => 'Notifications enabled',
      LocalNotificationsPermissionDenied() => 'Notifications disabled',
      LocalNotificationSent(title: final title) => 'Sent: $title',
      LocalNotificationTapped(payload: final payload) =>
        'Tapped notification: $payload',
      LocalNotificationsPermissionRequested() =>
        'Requesting notification permissions...',
      _ => 'Initializing notifications...',
    };
  }

  Widget _buildAuthStateInfo(
      AuthState authState, BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getAuthIcon(authState),
                  color: _getAuthColor(authState),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_getAuthText(authState)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAuthButton(authState, context, ref),
          ],
        ),
      ),
    );
  }

  IconData _getAuthIcon(AuthState authState) {
    return switch (authState) {
      AuthAuthenticated() => Icons.check_circle,
      AuthUnauthenticated() => Icons.account_circle,
      AuthInitial() => Icons.account_circle,
      AuthLoading() => Icons.hourglass_empty,
      AuthCodeSent() => Icons.sms,
      _ => Icons.help_outline,
    };
  }

  Color _getAuthColor(AuthState authState) {
    return switch (authState) {
      AuthAuthenticated() => Colors.green,
      AuthUnauthenticated() => Colors.grey,
      AuthInitial() => Colors.grey,
      AuthLoading() => Colors.blue,
      AuthCodeSent() => Colors.orange,
      _ => Colors.grey,
    };
  }

  String _getAuthText(AuthState authState) {
    return switch (authState) {
      AuthAuthenticated(:final userId) => 'Logged in with ID: $userId',
      AuthUnauthenticated() => 'Not logged in',
      AuthInitial() => 'Not logged in',
      AuthLoading() => 'Loading...',
      AuthCodeSent() => 'SMS code sent',
      _ => 'Unknown state',
    };
  }

  Widget _buildAuthButton(
      AuthState authState, BuildContext context, WidgetRef ref) {
    return switch (authState) {
      AuthAuthenticated() => ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authControllerProvider.notifier).signOut();
            } on AuthException catch (e) {
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Sign Out'),
        ),
      AuthLoading() => const CircularProgressIndicator(),
      _ => ElevatedButton(
          onPressed: () => AppNavigation.goToAuth(context),
          child: const Text('Go to Login'),
        ),
    };
  }
}
