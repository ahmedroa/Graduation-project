import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/features/auth/ui/screens/forgot_password.dart';
import 'package:graduation/features/auth/ui/screens/login.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import 'package:graduation/features/home/ui/screens/details.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/screens/car_information.dart';
import 'package:graduation/features/posts/ui/screens/create_post.dart';
import 'package:graduation/features/posts/ui/widgets/section.dart';
import 'package:graduation/features/splach/splach.dart';
import '../../features/auth/logic/cubit/login_cubit.dart';
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

      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => HomeCubit()..getHomeData(), child: BottomNavBar()),
        );
      case Routes.details:
        return MaterialPageRoute(builder: (_) => Details());
      case Routes.createPost:
        return MaterialPageRoute(builder: (_) => CreatePost());
      case Routes.section:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => PostsCubit(), child: Section()));
      case Routes.carInformation:
        return MaterialPageRoute(builder: (_) => CarInformation());

      default:
        return null;
    }
  }
}
