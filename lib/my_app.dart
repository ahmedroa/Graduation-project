import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/extensions/auth_extensions.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduation/core/widgets/error.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ErrorWidget.builder = (FlutterErrorDetails error) {
      return ErrorPage();
    };
    FlutterNativeSplash.remove();

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
        onGenerateRoute: appRouter.generateRoute,
        initialRoute: context.isNotLoggedIn ? Routes.loginScreen : Routes.bottomNavBar,
        // home: Notifications(),
      ),
    );
  }
}
