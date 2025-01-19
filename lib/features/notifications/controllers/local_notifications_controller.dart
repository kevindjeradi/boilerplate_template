import 'package:get/get.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_local_notifications_service.dart';

class LocalNotificationsController extends GetxController {
  final ILocalNotificationsService _localNotificationsService;

  RxString lastTappedPayload = ''.obs;

  LocalNotificationsController(this._localNotificationsService);

  @override
  void onInit() {
    super.onInit();
    _localNotificationsService.initialize();
    _localNotificationsService.requestPermissions();

    _localNotificationsService.onNotificationTap.listen((data) {
      if (data.containsKey('payload')) {
        lastTappedPayload.value = data['payload'] ?? '';
      }
    });
  }

  Future<void> showSimpleNotification(String title, String body) async {
    await _localNotificationsService.showNotification(title: title, body: body);
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTime) async {
    await _localNotificationsService.scheduleNotification(
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }
}
