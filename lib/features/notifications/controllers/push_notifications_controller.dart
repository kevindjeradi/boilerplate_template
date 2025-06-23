import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_push_notifications_service.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/notifications/providers/notifications_providers.dart';

part 'push_notifications_controller.g.dart';

// Push notifications state
sealed class PushNotificationsState {
  const PushNotificationsState();
}

class PushNotificationsInitial extends PushNotificationsState {
  const PushNotificationsInitial();
}

class PushNotificationsPermissionRequested extends PushNotificationsState {
  const PushNotificationsPermissionRequested();
}

class PushNotificationsPermissionGranted extends PushNotificationsState {
  final String? token;
  const PushNotificationsPermissionGranted(this.token);
}

class PushNotificationsPermissionDenied extends PushNotificationsState {
  const PushNotificationsPermissionDenied();
}

class PushNotificationReceived extends PushNotificationsState {
  final Map<String, dynamic> message;
  const PushNotificationReceived(this.message);
}

// Controller moderne avec Riverpod 3.0 AsyncNotifier
@riverpod
class PushNotificationsController extends _$PushNotificationsController {
  late final IPushNotificationsService _pushNotificationsService;
  String? _fcmToken;

  @override
  FutureOr<PushNotificationsState> build() async {
    AppLogger.info(
        'Initializing PushNotificationsController with AsyncNotifier');

    _pushNotificationsService = ref.read(pushNotificationsServiceProvider);
    await _initializePushNotifications();

    return const PushNotificationsInitial();
  }

  Future<void> _initializePushNotifications() async {
    await _pushNotificationsService.initialize();
    await requestPermissions();

    // Listen to notification taps
    _pushNotificationsService.onNotificationTap.listen((data) {
      state = AsyncData(PushNotificationReceived(data));
    });
  }

  Future<void> requestPermissions() async {
    state = const AsyncData(PushNotificationsPermissionRequested());

    try {
      await _pushNotificationsService.requestPermissions();
      state = const AsyncData(PushNotificationsPermissionGranted(null));
    } catch (e) {
      AppLogger.error('Error requesting push notifications permissions: $e');
      state = const AsyncData(PushNotificationsPermissionDenied());
    }
  }

  String? get fcmToken => _fcmToken;

  void clearNotificationState() {
    state = const AsyncData(PushNotificationsInitial());
  }
}

// Helper providers modernes
@riverpod
String? fcmToken(Ref ref) {
  final controller = ref.read(pushNotificationsControllerProvider.notifier);
  return controller.fcmToken;
}

@riverpod
bool isPushNotificationPermissionGranted(Ref ref) {
  final state = ref.watch(pushNotificationsControllerProvider);
  return state.maybeWhen(
    data: (state) => state is PushNotificationsPermissionGranted,
    orElse: () => false,
  );
}

@riverpod
Map<String, dynamic>? lastReceivedMessage(Ref ref) {
  final state = ref.watch(pushNotificationsControllerProvider);
  return state.maybeWhen(
    data: (state) => state is PushNotificationReceived ? state.message : null,
    orElse: () => null,
  );
}
