// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/features/onboarding/onboarding.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, animation, __) {
            return FadeTransition(opacity: animation, child: OnboardingView());
          },
        ),
      );
    });

    return Scaffold(
      backgroundColor: ColorsManager.kPrimaryColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.15),
          child: Hero(tag: "logo", child: SvgPicture.asset(ImgManager.logo, color: Colors.white, width: 140)),
        ),
      ),
    );
  }
}
