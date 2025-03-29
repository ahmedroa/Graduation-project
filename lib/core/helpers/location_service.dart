import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Map<String, String>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('خدمة الموقع غير مفعلة');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('تم رفض إذن الوصول إلى الموقع');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('إذن الموقع مرفوض دائمًا، يجب تفعيله من الإعدادات');
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return {
          'neighborhood': place.subLocality ?? 'غير متوفر',
          'city': place.locality ?? 'غير متوفر',
          'street': place.street ?? 'غير متوفر',
        };
      }
    } catch (e) {
      throw Exception("خطأ في جلب الموقع: $e");
    }

    return {'neighborhood': '', 'city': '', 'street': ''};
  }
}
