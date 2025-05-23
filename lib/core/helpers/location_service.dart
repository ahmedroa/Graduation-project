import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';

class LocationService {
  Future<Map<String, String>> getCurrentLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      bool opened = await _showEnableServiceDialog(context);
      if (opened) {
        return getCurrentLocation(context);
      } else {
        throw Exception('خدمة الموقع غير مفعلة');
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        bool retry = await _showPermissionDeniedDialog(context);
        if (retry) {
          return getCurrentLocation(context);
        } else {
          throw Exception('تم رفض إذن الوصول إلى الموقع');
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      bool opened = await _showPermissionDeniedForeverDialog(context);
      if (opened) {
        return getCurrentLocation(context);
      } else {
        throw Exception('إذن الموقع مرفوض دائمًا، يجب تفعيله من الإعدادات');
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return {
          'neighborhood': place.subLocality ?? 'غير متوفر',
          'city': place.locality ?? 'غير متوفر',
          'street': place.street ?? 'غير متوفر',
        };
      } else {
        return {'neighborhood': '', 'city': '', 'street': ''};
      }
    } catch (e) {
      throw Exception("خطأ في جلب الموقع: $e");
    }
  }

  Future<bool> _showEnableServiceDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('خدمة الموقع'),
            content: const Text('خدمة الموقع معطّلة، هل تريد الذهاب إلى الإعدادات لتفعيلها؟'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
              TextButton(
                onPressed: () {
                  Geolocator.openLocationSettings();
                  Navigator.pop(context, true);
                },
                child: const Text('فتح الإعدادات'),
              ),
            ],
          ),
    ).then((v) => v ?? false);
  }


  Future<bool> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('إذن الموقع'),
            content: const Text('تم رفض إذن الوصول إلى الموقع. هل تريد المحاولة مرة أخرى؟'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('لا')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('نعم')),
            ],
          ),
    ).then((v) => v ?? false);
  }

  Future<bool> _showPermissionDeniedForeverDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('إذن الموقع مؤمن'),
            content: const Text(
              'إذن الموقع مرفوض بشكل دائم. '
              'يجب الذهاب إلى إعدادات التطبيق وتفعيله يدوياً.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
              TextButton(
                onPressed: () {
                  Geolocator.openAppSettings();
                  Navigator.pop(context, true);
                },
                child: const Text('فتح إعدادات التطبيق'),
              ),
            ],
          ),
    ).then((v) => v ?? false);
  }
}
