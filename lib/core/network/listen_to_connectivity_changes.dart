import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _wasDisconnected = false;

  NetworkMonitor() {
    _checkInitialConnection();
  }

  void _checkInitialConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(results);
  }

  void startMonitoring() {
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectivityStatus(results);
    });
  }

  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    bool isConnected = results.any((result) => result != ConnectivityResult.none);

    if (!isConnected) {
      if (!_wasDisconnected) {
        print("🚨 الإنترنت مفصول!");
        _wasDisconnected = true;
      }
    } else {
      if (_wasDisconnected) {
        print("✅ الإنترنت شغال (${results.toString()})");
        _wasDisconnected = false;
      }
    }
  }

  void stopMonitoring() {
    _subscription.cancel();
  }
}
