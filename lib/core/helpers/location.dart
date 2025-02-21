// import 'package:geolocator/geolocator.dart';

// class LocationHelper {
//   static Future<Position?> getCurrentLocation() async {
//     bool isServiceEnabled;
//     LocationPermission permission;

//     isServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isServiceEnabled) {
//       isServiceEnabled = await Geolocator.openLocationSettings();
//       if (!isServiceEnabled) {
//         return null;
//       }
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) {
//       return null;
//     }

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
//         return null;
//       }
//     }

//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//     } catch (e) {
//       print("Error getting location: $e");
//       return null;
//     }
//   }
// }



// // class LocationHelper {
// //   static Future<Position> getCurrentLocation() async {
// //     bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!isServiceEnabled) {
// //       await Geolocator.requestPermission();
// //     }

// //     return await Geolocator.getCurrentPosition(
// //       desiredAccuracy: LocationAccuracy.high,
// //     );
// //   }
// // }
// // import 'package:geolocator/geolocator.dart';
// // import 'package:permission_handler/permission_handler.dart';

// // class LocationHelper {
// //   static Future<Position> getCurrentLocation() async {
// //     bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!isServiceEnabled) {
// //       await Geolocator.openLocationSettings();
// //       return Future.error('خدمات الموقع معطلة.');
// //     }
// //     LocationPermission permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return Future.error('تم رفض إذن الوصول إلى الموقع.');
// //       }
// //     }

// //     if (permission == LocationPermission.deniedForever) {
// //       await openAppSettings();
// //       return Future.error('تم رفض إذن الوصول إلى الموقع بشكل دائم.');
// //     }

// //     return await Geolocator.getCurrentPosition(
// //       desiredAccuracy: LocationAccuracy.high,
// //     );
// //   }
// // }