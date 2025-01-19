abstract class ILocalNotificationsService {
  Future<void> initialize();
  Future<void> requestPermissions();
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  });
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  });
  Stream<Map<String, dynamic>> get onNotificationTap;
}
