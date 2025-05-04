import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtil;
import 'package:graduation/core/network/listen_to_connectivity_changes.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/shared/bloc_observer.dart' show MyBlocObserver;
import 'package:graduation/firebase_options.dart';
import 'package:graduation/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();

  // NetworkMonitor().startMonitoring();

  runApp(MyApp(appRouter: AppRouter()));
}








// flutter pub run build_runner build --delete-conflicting-outputs 

// final MyFirebase firebase = MyFirebase();
  // await firebase.initializeFirebaseApp(); // تهيئة Firebase
  // await firebase.initFirebaseCrashlytics(); // تشغيل Crashlytics