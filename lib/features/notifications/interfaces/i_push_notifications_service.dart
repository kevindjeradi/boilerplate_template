abstract class IPushNotificationsService {
  Future<void> initialize();
  Future<void> requestPermissions();
  Stream<Map<String, dynamic>> get onNotificationTap;
}
