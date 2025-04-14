import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/features/auth/login/ui/screens/forgot_password.dart';
import 'package:graduation/features/auth/login/ui/screens/login.dart';
import 'package:graduation/features/auth/register/cubit/register_cubit.dart';
import 'package:graduation/features/auth/register/ui/screen/register.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/ui/screens/details.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/car_information.dart';
import 'package:graduation/features/posts/ui/CreatePost/screens/create_post.dart';
import 'package:graduation/features/posts/ui/ReportVehicle/widgets/report_vehicle.dart';
import 'package:graduation/features/posts/ui/CreatePost/screens/section.dart';
import 'package:graduation/features/posts/ui/ReportVehicle/screens/section_report_vehicle.dart';
import 'package:graduation/features/profile/ui/profile.dart';
import 'package:graduation/features/splach/splach.dart';
import '../../features/auth/login/logic/cubit/login_cubit.dart';
import '../../features/home/ui/widgets/bottom_vav_bar.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashView:
        return MaterialPageRoute(builder: (_) => SplashView());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => LoginCubit(), child: LoginScreen()));
      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => LoginCubit(), child: ForgotPassword()),
        );
      case Routes.register:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => RegisterCubit(), child: Register()));

      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => HomeCubit()..getHomeData(), child: BottomNavBar()),
        );
      case Routes.details:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => HomeCubit(), child: Details()));
      case Routes.createPost:
        return MaterialPageRoute(builder: (_) => CreatePost());
      case Routes.section:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => PostsCubit(), child: Section()));
      case Routes.carInformation:
        return MaterialPageRoute(builder: (_) => CarInformation());
      case Routes.reportVehicle:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => PostsCubit(), child: ReportVehicle()),
        );
      case Routes.sectionReportVehicle:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => PostsCubit(), child: SectionReportVehicle()),
        );
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => PostsCubit(), child: Profile()));

      default:
        return null;
    }
  }
}
