import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/features/connectivity/interfaces/i_connectivity_service.dart';
import 'package:boilerplate_template/features/connectivity/services/connectivity_service.dart';

part 'connectivity_providers.g.dart';

// ==================== CONNECTIVITY PROVIDERS ====================

@Riverpod(keepAlive: true)
IConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();

  // Dispose the service when the provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
}
