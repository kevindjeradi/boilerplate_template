import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/features/notifications/interfaces/i_local_notifications_service.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_push_notifications_service.dart';
import 'package:boilerplate_template/features/notifications/services/local_notifications_service.dart';
import 'package:boilerplate_template/features/notifications/services/push_notifications_service.dart';

part 'notifications_providers.g.dart';

// ==================== NOTIFICATIONS PROVIDERS ====================

@Riverpod(keepAlive: true)
ILocalNotificationsService localNotificationsService(Ref ref) {
  return LocalNotificationsService();
}

@Riverpod(keepAlive: true)
IPushNotificationsService pushNotificationsService(Ref ref) {
  return PushNotificationsService();
}
