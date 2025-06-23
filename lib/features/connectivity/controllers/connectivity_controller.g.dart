// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isConnectedHash() => r'6588fd130887c763c864c94f5ca97fed4a9103cf';

/// See also [isConnected].
@ProviderFor(isConnected)
final isConnectedProvider = AutoDisposeProvider<bool>.internal(
  isConnected,
  name: r'isConnectedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsConnectedRef = AutoDisposeProviderRef<bool>;
String _$connectionTypeHash() => r'440370b3f038c48bf8c46f5023d66ebac01fe6a2';

/// See also [connectionType].
@ProviderFor(connectionType)
final connectionTypeProvider =
    AutoDisposeProvider<ConnectivityResult?>.internal(
  connectionType,
  name: r'connectionTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectionTypeRef = AutoDisposeProviderRef<ConnectivityResult?>;
String _$connectivityControllerHash() =>
    r'dd18273e63494f9e62fbf5b537183f72cc7bb89f';

/// See also [ConnectivityController].
@ProviderFor(ConnectivityController)
final connectivityControllerProvider = AutoDisposeAsyncNotifierProvider<
    ConnectivityController, ConnectivityState>.internal(
  ConnectivityController.new,
  name: r'connectivityControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityController = AutoDisposeAsyncNotifier<ConnectivityState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
