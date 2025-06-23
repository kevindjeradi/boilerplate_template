// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isApiLoadingHash() => r'e8c95db0c429bb6a61d3e9e365cc71bb963b95d4';

/// See also [isApiLoading].
@ProviderFor(isApiLoading)
final isApiLoadingProvider = AutoDisposeProvider<bool>.internal(
  isApiLoading,
  name: r'isApiLoadingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isApiLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsApiLoadingRef = AutoDisposeProviderRef<bool>;
String _$lastApiResponseHash() => r'bc4111ddc0bfa42780493bbd2b882e6e67130a00';

/// See also [lastApiResponse].
@ProviderFor(lastApiResponse)
final lastApiResponseProvider = AutoDisposeProvider<http.Response?>.internal(
  lastApiResponse,
  name: r'lastApiResponseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastApiResponseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastApiResponseRef = AutoDisposeProviderRef<http.Response?>;
String _$apiControllerHash() => r'0ee2e0c847ffbc0e1ea04941f5983b1c6b4232b2';

/// See also [ApiController].
@ProviderFor(ApiController)
final apiControllerProvider =
    AutoDisposeNotifierProvider<ApiController, ApiStatus>.internal(
  ApiController.new,
  name: r'apiControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ApiController = AutoDisposeNotifier<ApiStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
