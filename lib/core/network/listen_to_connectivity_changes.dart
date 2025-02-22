import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkMonitor {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _wasDisconnected = false;

  NetworkMonitor() {
    _checkInitialConnection(); // فحص الاتصال عند بدء التطبيق
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
      // لا تعرض "🚨 الإنترنت مفصول!" إلا إذا لم يكن مفصولًا مسبقًا
      if (!_wasDisconnected) {
        print("🚨 الإنترنت مفصول!");
        _wasDisconnected = true;
      }
    } else {
      // عرض "✅ الإنترنت شغال" فقط عند عودة الاتصال بعد انقطاعه
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

// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';

// class NetworkMonitor {
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<ConnectivityResult> _subscription;

//   void startMonitoring() {
//     _subscription =
//         _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
//               if (results.contains(ConnectivityResult.none)) {
//                 print("🚨 الإنترنت مفصول!");
//               } else {
//                 print("✅ الإنترنت شغال (${results.toString()})");
//               }
//             })
//             as StreamSubscription<ConnectivityResult>;
//   }

//   void stopMonitoring() {
//     _subscription.cancel();
//   }
// }
