import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtil;
import 'package:graduation/core/helpers/request_notification_permission.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/shared/bloc_observer.dart';
import 'package:graduation/firebase_options.dart';
import 'package:graduation/my_app.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  timeago.setLocaleMessages('ar', timeago.ArMessages());
  await requestNotificationPermission();

  runApp(MyApp(appRouter: AppRouter()));
}

// error to undarstand:
// flutter build appbundle
// تعديل البحث والتفاصيل فيها 



// flutter build appbundle --release
// flutter pub run build_runner build --delete-conflicting-outputs 
