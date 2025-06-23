import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/features/connectivity/interfaces/i_connectivity_service.dart';
import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/features/connectivity/providers/connectivity_providers.dart';

part 'connectivity_controller.g.dart';

// Connectivity state
sealed class ConnectivityState {
  const ConnectivityState();
}

class ConnectivityInitial extends ConnectivityState {
  const ConnectivityInitial();
}

class ConnectivityConnected extends ConnectivityState {
  final ConnectivityResult connectionType;
  const ConnectivityConnected(this.connectionType);
}

class ConnectivityDisconnected extends ConnectivityState {
  const ConnectivityDisconnected();
}

// Controller moderne avec Riverpod 3.0 AsyncNotifier
@riverpod
class ConnectivityController extends _$ConnectivityController {
  late final IConnectivityService _connectivityService;

  @override
  FutureOr<ConnectivityState> build() async {
    AppLogger.info('Initializing ConnectivityController with AsyncNotifier');

    _connectivityService = ref.read(connectivityServiceProvider);

    // Listen to connectivity changes
    _connectivityService.connectivityStatus.listen((status) {
      _updateConnectionState(status);
    });

    // Check initial connectivity using the connectivity_plus package directly
    final connectivity = Connectivity();
    try {
      final result = await connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none)) {
        return const ConnectivityDisconnected();
      } else {
        final firstResult = result.first;
        return ConnectivityConnected(firstResult);
      }
    } catch (e) {
      AppLogger.error('Error checking initial connectivity: $e');
      return const ConnectivityDisconnected();
    }
  }

  ConnectivityState _mapStatusToState(ConnectivityStatus status) {
    if (status == ConnectivityStatus.offline) {
      return const ConnectivityDisconnected();
    } else {
      return const ConnectivityConnected(ConnectivityResult.wifi);
    }
  }

  void _updateConnectionState(ConnectivityStatus status) {
    // Only update if we're not in a loading state
    if (state.hasValue) {
      state = AsyncData(_mapStatusToState(status));
    }
  }

  // Show connectivity message using ScaffoldMessenger
  void showConnectivityMessage(BuildContext context) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final String message;
    final Color backgroundColor;

    switch (currentState) {
      case ConnectivityConnected(connectionType: final type):
        message = _getConnectionMessage(type);
        backgroundColor = Colors.green;
        break;
      case ConnectivityDisconnected():
        message = 'No internet connection';
        backgroundColor = Colors.red;
        break;
      default:
        return; // Don't show message for initial state
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getConnectionMessage(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      default:
        return 'Connected to Internet';
    }
  }

  bool get isConnected {
    final currentState = state.valueOrNull;
    return currentState is ConnectivityConnected;
  }

  ConnectivityResult? get connectionType {
    final currentState = state.valueOrNull;
    return currentState is ConnectivityConnected
        ? currentState.connectionType
        : null;
  }
}

// Helper providers modernes
@riverpod
bool isConnected(Ref ref) {
  final state = ref.watch(connectivityControllerProvider);
  return state.maybeWhen(
    data: (state) => state is ConnectivityConnected,
    orElse: () => false,
  );
}

@riverpod
ConnectivityResult? connectionType(Ref ref) {
  final state = ref.watch(connectivityControllerProvider);
  return state.maybeWhen(
    data: (state) =>
        state is ConnectivityConnected ? state.connectionType : null,
    orElse: () => null,
  );
}
