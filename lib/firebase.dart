import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

import 'firebase_options.dart';

class MyFirebase {
  final Logger log = Logger('MyFirebase');
  bool isInitialized() => Firebase.apps.isNotEmpty;

  Future<void> initializeFirebaseApp() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      if (isInitialized()) {}
    } catch (e) {
      log.severe('Error initializing Firebase', e);
    }
  }

  Future<void> initFirebaseCrashlytics() async {
    if (!isInitialized()) return;

    try {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Catch errors that happen outside of the Flutter context
      Isolate.current.addErrorListener(
        RawReceivePort((List<StackTrace> pair) async {
          final List<StackTrace> errorAndStacktrace = pair;
          await FirebaseCrashlytics.instance.recordError(errorAndStacktrace.first, errorAndStacktrace.last);
        }).sendPort,
      );
    } catch (e) {
      log.severe('Error initializing FirebaseCrashlytics', e);
    }
  }
}
