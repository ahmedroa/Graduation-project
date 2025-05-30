import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermission() async {
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('🔔 تم منح إذن الإشعارات');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('🔔 تم منح إذن مؤقت (provisional)');
  } else {
    print('❌ تم رفض إذن الإشعارات');
  }
}
