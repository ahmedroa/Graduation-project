import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/routing/routes.dart';
import 'package:graduation/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graduation/core/widgets/error.dart';
// import 'package:graduation/core/widgets/no_internet.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return ErrorPage();
    };

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
        title: 'Flutter Demo',
        theme: lightTheme,
        // home: ErrorPage(),
        initialRoute: Routes.bottomNavBar,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
// 



// class MyApp extends StatelessWidget {
//   final AppRouter appRouter;

//   const MyApp({super.key, required this.appRouter});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

//     return ScreenUtilInit(
//       designSize: Size(375, 812),
//       minTextAdapt: true,
//       child: StreamBuilder<List<ConnectivityResult>>(
//         stream: Connectivity().onConnectivityChanged,
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data!.contains(ConnectivityResult.none)) {
//             return const NoInternet();
//           }
//           return MaterialApp(
//             localizationsDelegates: const [
//               GlobalCupertinoLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//             ],
//             supportedLocales: const [Locale("ar", "AE")],
//             locale: const Locale("ar", "AE"),
//             debugShowCheckedModeBanner: false,
//             title: 'Flutter Demo',
//             theme: lightTheme,
//             initialRoute: Routes.bottomNavBar,
//             onGenerateRoute: appRouter.generateRoute,
//           );
//         },
//       ),
//     );
//   }
// }