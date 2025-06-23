import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:boilerplate_template/features/notifications/interfaces/i_local_notifications_service.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/notifications/providers/notifications_providers.dart';

part 'local_notifications_controller.g.dart';

// Local notifications state
sealed class LocalNotificationsState {
  const LocalNotificationsState();
}

class LocalNotificationsInitial extends LocalNotificationsState {
  const LocalNotificationsInitial();
}

class LocalNotificationsPermissionRequested extends LocalNotificationsState {
  const LocalNotificationsPermissionRequested();
}

class LocalNotificationsPermissionGranted extends LocalNotificationsState {
  const LocalNotificationsPermissionGranted();
}

class LocalNotificationsPermissionDenied extends LocalNotificationsState {
  const LocalNotificationsPermissionDenied();
}

class LocalNotificationSent extends LocalNotificationsState {
  final String title;
  final String body;
  const LocalNotificationSent(this.title, this.body);
}

class LocalNotificationTapped extends LocalNotificationsState {
  final String payload;
  const LocalNotificationTapped(this.payload);
}

// Controller moderne avec Riverpod 3.0 AsyncNotifier
@riverpod
class LocalNotificationsController extends _$LocalNotificationsController {
  late final ILocalNotificationsService _localNotificationsService;
  String? _lastTappedPayload;

  @override
  FutureOr<LocalNotificationsState> build() async {
    AppLogger.info(
        'Initializing LocalNotificationsController with AsyncNotifier');

    _localNotificationsService = ref.read(localNotificationsServiceProvider);
    await _initializeNotifications();

    return const LocalNotificationsPermissionGranted();
  }

  Future<void> _initializeNotifications() async {
    await _localNotificationsService.initialize();
    await _localNotificationsService.requestPermissions();

    // Listen to notification taps
    _localNotificationsService.onNotificationTap.listen((data) {
      if (data.containsKey('payload')) {
        _lastTappedPayload = data['payload'] ?? '';
        state = AsyncData(LocalNotificationTapped(_lastTappedPayload!));
      }
    });
  }

  Future<void> requestPermissions() async {
    state = const AsyncData(LocalNotificationsPermissionRequested());
    await _localNotificationsService.requestPermissions();
    state = const AsyncData(LocalNotificationsPermissionGranted());
  }

  Future<void> showSimpleNotification(String title, String body,
      {String? payload}) async {
    await _localNotificationsService.showNotification(
      title: title,
      body: body,
      payload: payload,
    );
    state = AsyncData(LocalNotificationSent(title, body));
  }

  Future<void> scheduleNotification(
      String title, String body, DateTime scheduledTime,
      {String? payload}) async {
    await _localNotificationsService.scheduleNotification(
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
    );
    state = AsyncData(LocalNotificationSent(title, body));
  }

  String? get lastTappedPayload => _lastTappedPayload;

  void clearLastTappedPayload() {
    _lastTappedPayload = null;
    state = const AsyncData(LocalNotificationsInitial());
  }
}

// Helper providers modernes
@riverpod
String? lastTappedPayload(Ref ref) {
  final controller = ref.read(localNotificationsControllerProvider.notifier);
  return controller.lastTappedPayload;
}

@riverpod
bool isNotificationPermissionGranted(Ref ref) {
  final state = ref.watch(localNotificationsControllerProvider);
  return state.maybeWhen(
    data: (state) => state is LocalNotificationsPermissionGranted,
    orElse: () => false,
  );
}
