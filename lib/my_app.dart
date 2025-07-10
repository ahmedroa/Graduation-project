import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/check%D9%80app_status.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduation/core/widgets/error.dart';

class MyApp extends StatefulWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAppStatus(context);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ErrorWidget.builder = (FlutterErrorDetails error) {
      return ErrorPage();
    };
    FlutterNativeSplash.remove();
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale("ar", "AE")],
        locale: const Locale("ar", "AE"),
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
        onGenerateRoute: widget.appRouter.generateRoute,
        initialRoute: context.isNotLoggedIn ? Routes.splashView : Routes.bottomNavBar,
        // home: ReportContentScreen(contentId: ''),
        // home: BlockUserScreen(userId: '', userName: ''),
        // home: ReportContentScreen(contentId: '', contentType: ''),
      ),
    );
  }
}
