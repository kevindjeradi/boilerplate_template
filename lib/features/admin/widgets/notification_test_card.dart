import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/notifications/controllers/local_notifications_controller.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';

class NotificationTestCard extends StatelessWidget {
  const NotificationTestCard({
    super.key,
    required this.localNotificationsState,
    required this.onShowNotification,
    required this.onScheduleNotification,
  });

  final AsyncValue<LocalNotificationsState> localNotificationsState;
  final VoidCallback onShowNotification;
  final VoidCallback onScheduleNotification;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.marginSmall,
          children: [
            const Text(
              'Notification Testing:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: onShowNotification,
              child: const Text('Show Immediate Local Notification'),
            ),
            ElevatedButton(
              onPressed: onScheduleNotification,
              child: const Text('Schedule Local Notification in 5s'),
            ),
            localNotificationsState.when(
              data: (state) => Row(
                spacing: context.marginSmall,
                children: [
                  Icon(
                    _getNotificationIcon(state),
                    color: _getNotificationColor(state),
                  ),
                  Expanded(
                    child: Text(_getNotificationText(state)),
                  ),
                ],
              ),
              loading: () => const Text('Loading notifications...'),
              error: (error, _) => Text('Notification error: $error'),
            ),
          ],
        ),
      ),
    );
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
}
