import 'dart:async';

enum ConnectivityStatus { online, offline }

abstract class IConnectivityService {
  Stream<ConnectivityStatus> get connectivityStatus;
}
