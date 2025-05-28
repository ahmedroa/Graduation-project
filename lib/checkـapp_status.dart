import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


Future<void> checkAppStatus(BuildContext context) async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // إعداد القيم الافتراضية
  await remoteConfig.setDefaults({
    'force_update': false,
    'maintenance_mode': false,
    'latest_version': '1.0.7',
    'update_url': 'https://your-update-url.com',
  });

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration.zero, 
    ),
  );

  await remoteConfig.fetchAndActivate();

  final isMaintenance = remoteConfig.getBool('maintenance_mode');
  final isForceUpdate = remoteConfig.getBool('force_update');
  final latestVersion = remoteConfig.getString('latest_version');
  final updateUrl = remoteConfig.getString('update_url');

  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  print('✅ current version: $currentVersion');
  print('✅ latest version from remote: $latestVersion');
  print('✅ isForceUpdate: $isForceUpdate');
  print('✅ isMaintenance: $isMaintenance');

  // في حالة الصيانة
  if (isMaintenance) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('🚧 تحت الصيانة'),
            content: const Text('التطبيق حالياً تحت الصيانة.\nالرجاء المحاولة لاحقاً.'),
          ),
    );
    return;
  }

  // في حالة التحديث الإجباري
  if (isForceUpdate && currentVersion != latestVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text('📢 تحديث مطلوب'),
            content: const Text('يوجد إصدار جديد من التطبيق. الرجاء التحديث للاستمرار.'),
            actions: [
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(updateUrl);
                  // if (await canLaunchUrl(uri)) {
                  //   await launchUrl(uri, mode: LaunchMode.externalApplication);
                  // }
                },
                child: const Text('تحديث الآن'),
              ),
            ],
          ),
    );
  }
}

// Future<void> checkAppStatus(BuildContext context) async {
//   final remoteConfig = FirebaseRemoteConfig.instance;
//   await remoteConfig.setDefaults({
//     'force_update': false,
//     'maintenance_mode': false,
//     'latest_version': '1.0.7',
//     'update_url': 'https://play.google.com/apps/internaltest/4701178070969175977',
//   });

//   await remoteConfig.fetchAndActivate();

//   final isMaintenance = remoteConfig.getBool('maintenance_mode');
//   final isForceUpdate = remoteConfig.getBool('force_update');
//   final latestVersion = remoteConfig.getString('latest_version');
//   final updateUrl = remoteConfig.getString('update_url');
//   print('isMaintenance: $isMaintenance');
//   print('isForceUpdate: $isForceUpdate');
//   print('latestVersion: $latestVersion');
//   print('updateUrl: $updateUrl');
//   print('Current platform: ${remoteConfig.getString('platform')}');
//   print('Current version: ${remoteConfig.getString('current_version')}');

//   final packageInfo = await PackageInfo.fromPlatform();
//   final currentVersion = packageInfo.version;

//   if (isMaintenance) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) =>
//               AlertDialog(title: Text('الصيانة'), content: Text('التطبيق حالياً تحت الصيانة. الرجاء المحاولة لاحقاً.')),
//     );
//     return;
//   }

//   if (isForceUpdate && currentVersion != latestVersion) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder:
//           (_) => AlertDialog(
//             title: Text('تحديث مطلوب'),
//             content: Text('يوجد إصدار جديد من التطبيق. الرجاء التحديث للاستمرار.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   // launchUrl(Uri.parse(updateUrl));
//                 },
//                 child: Text('تحديث الآن'),
//               ),
//             ],
//           ),
//     );
//   }
// }
