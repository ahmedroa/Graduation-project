// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// class ConnectivityCubit extends Cubit<ConnectivityState> {
//   late StreamSubscription<List<ConnectivityResult>> subscription;

//   ConnectivityCubit() : super(ConnectivityInitial()) {
//     monitorConnectivity();
//   }

//   void monitorConnectivity() {
//     subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
//       bool hasConnection = results.any((result) => result != ConnectivityResult.none);
//       print(hasConnection);
//       if (hasConnection) {
//         print(hasConnection);
//         emit(ConnectivityConnected());
//       } else {
//         print(hasConnection);
//         emit(ConnectivityDisconnected());
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     subscription.cancel();
//     return super.close();
//   }
// }

// abstract class ConnectivityState {}

// class ConnectivityInitial extends ConnectivityState {}

// class ConnectivityConnected extends ConnectivityState {}

// class ConnectivityDisconnected extends ConnectivityState {}
