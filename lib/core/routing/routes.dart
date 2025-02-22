import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/features/auth/ui/screens/login.dart';
import 'package:graduation/features/home/cubit/home_cubit.dart';
import '../../features/auth/logic/cubit/login_cubit.dart';
import '../../features/home/ui/widgets/bottom_vav_bar.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider(create: (context) => LoginCubit(), child: LoginScreen()));
      case Routes.bottomNavBar:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(create: (context) => HomeCubit()..getHomeData(), child: BottomNavBar()),
        );
      default:
        return null;
    }
  }
}
