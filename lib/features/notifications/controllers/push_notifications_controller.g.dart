// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notifications_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fcmTokenHash() => r'744b247ccb5b9d50851b482279e7dd06d3bae4f8';

/// See also [fcmToken].
@ProviderFor(fcmToken)
final fcmTokenProvider = AutoDisposeProvider<String?>.internal(
  fcmToken,
  name: r'fcmTokenProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fcmTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FcmTokenRef = AutoDisposeProviderRef<String?>;
String _$isPushNotificationPermissionGrantedHash() =>
    r'8b02be9269bc0faa2dd6348e61f4704b3a4f6308';

/// See also [isPushNotificationPermissionGranted].
@ProviderFor(isPushNotificationPermissionGranted)
final isPushNotificationPermissionGrantedProvider =
    AutoDisposeProvider<bool>.internal(
  isPushNotificationPermissionGranted,
  name: r'isPushNotificationPermissionGrantedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isPushNotificationPermissionGrantedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsPushNotificationPermissionGrantedRef = AutoDisposeProviderRef<bool>;
String _$lastReceivedMessageHash() =>
    r'a3a33747a64abbc5170683621ad2788785982f60';

/// See also [lastReceivedMessage].
@ProviderFor(lastReceivedMessage)
final lastReceivedMessageProvider =
    AutoDisposeProvider<Map<String, dynamic>?>.internal(
  lastReceivedMessage,
  name: r'lastReceivedMessageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastReceivedMessageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastReceivedMessageRef = AutoDisposeProviderRef<Map<String, dynamic>?>;
String _$pushNotificationsControllerHash() =>
    r'53b4b4e46e7badbe16ca7ee4772e0f10989a2ffb';

/// See also [PushNotificationsController].
@ProviderFor(PushNotificationsController)
final pushNotificationsControllerProvider = AutoDisposeAsyncNotifierProvider<
    PushNotificationsController, PushNotificationsState>.internal(
  PushNotificationsController.new,
  name: r'pushNotificationsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pushNotificationsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PushNotificationsController
    = AutoDisposeAsyncNotifier<PushNotificationsState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
