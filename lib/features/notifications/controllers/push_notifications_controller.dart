import 'package:get/get.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_push_notifications_service.dart';

class PushNotificationsController extends GetxController {
  final IPushNotificationsService _pushNotificationsService;

  RxString lastTappedPayload = ''.obs;

  PushNotificationsController(this._pushNotificationsService);

  @override
  void onInit() {
    super.onInit();
    _pushNotificationsService.initialize();
    _pushNotificationsService.requestPermissions();

    _pushNotificationsService.onNotificationTap.listen((data) {
      if (data.containsKey('payload')) {
        lastTappedPayload.value = data['payload'] ?? '';
      }
    });
  }
}
