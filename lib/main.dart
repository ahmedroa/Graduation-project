import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graduation/core/network/listen_to_connectivity_changes.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/firebase_options.dart';
import 'package:graduation/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Bloc. observer = MyBlocObserver();

  NetworkMonitor().startMonitoring();

  runApp(MyApp(appRouter: AppRouter()));
}


// shere app         dane
// like 
// edit + add post
// add posts
// home 
// Details
// favorite
// settings
// register
// logout


// اسم السياره
// اللوكيشن 
// Description
// phone 
// commit



// flutter pub run build_runner build --delete-conflicting-outputs 

// final MyFirebase firebase = MyFirebase();
  // await firebase.initializeFirebaseApp(); // تهيئة Firebase
  // await firebase.initFirebaseCrashlytics(); // تشغيل Crashlytics