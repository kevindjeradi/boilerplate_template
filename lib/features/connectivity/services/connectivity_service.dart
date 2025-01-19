import 'dart:async';
import 'package:boilerplate_template/features/connectivity/interfaces/i_connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity;
  final StreamController<ConnectivityStatus> _connectivityStatusController =
      StreamController<ConnectivityStatus>();

  late final StreamSubscription<List<ConnectivityResult>>
      _connectivitySubscription;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateStatus);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final List<ConnectivityResult> status =
          await _connectivity.checkConnectivity();
      _updateStatus(status);
    } catch (e) {
      _connectivityStatusController.add(ConnectivityStatus.offline);
    }
  }

  void _updateStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      _connectivityStatusController.add(ConnectivityStatus.offline);
    } else {
      _connectivityStatusController.add(ConnectivityStatus.online);
    }
  }

  @override
  Stream<ConnectivityStatus> get connectivityStatus =>
      _connectivityStatusController.stream;

  void dispose() {
    _connectivitySubscription.cancel();
    _connectivityStatusController.close();
  }
}
