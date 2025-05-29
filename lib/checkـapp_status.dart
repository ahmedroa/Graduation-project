import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation/app/widgets/under_Maintenance.dart';
import 'package:graduation/app/widgets/update_request.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> checkAppStatus(BuildContext context) async {
  try {
    final doc = await FirebaseFirestore.instance.collection('app_config').doc('settings').get();

    if (!doc.exists) return;

    final data = doc.data()!;
    final isMaintenance = data['maintenance_mode'] as bool;
    final isForceUpdate = data['force_update'] as bool;
    final latestVersion = data['latest_version'] as String;
    final updateUrl = data['update_url'] as String;

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    if (isMaintenance) {
      underMaintenance(context);
      return;
    }

    if (isForceUpdate && currentVersion != latestVersion) {
      updateRequest(context);
    }
  } catch (e) {
    print('⚠️ خطأ في checkAppStatusWithFirestore: $e');
  }
}
