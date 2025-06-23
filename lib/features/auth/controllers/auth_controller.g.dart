// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthenticatedHash() => r'2c60129d7f793a876035e5949c0cdd611f01425c';

/// See also [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentAuthUserIdHash() => r'460c3e75db08495b575abeb5b79a5ff9fca516fe';

/// See also [currentAuthUserId].
@ProviderFor(currentAuthUserId)
final currentAuthUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentAuthUserId,
  name: r'currentAuthUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAuthUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentAuthUserIdRef = AutoDisposeProviderRef<String?>;
String _$isAuthLoadingHash() => r'b26c473803a343b9b422c50f8aef9bed045eea86';

/// See also [isAuthLoading].
@ProviderFor(isAuthLoading)
final isAuthLoadingProvider = AutoDisposeProvider<bool>.internal(
  isAuthLoading,
  name: r'isAuthLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthLoadingRef = AutoDisposeProviderRef<bool>;
String _$authControllerHash() => r'b2f9f1b2a2b053644f7260f5fc4034af7caee771';

/// See also [AuthController].
@ProviderFor(AuthController)
final authControllerProvider =
    NotifierProvider<AuthController, AuthState>.internal(
  AuthController.new,
  name: r'authControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthController = Notifier<AuthState>;
String _$authFormControllerHash() =>
    r'148ad82ea20738299ad6db396626184ae664e77d';

/// See also [AuthFormController].
@ProviderFor(AuthFormController)
final authFormControllerProvider =
    AutoDisposeNotifierProvider<AuthFormController, AuthFormState>.internal(
  AuthFormController.new,
  name: r'authFormControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authFormControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthFormController = AutoDisposeNotifier<AuthFormState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
