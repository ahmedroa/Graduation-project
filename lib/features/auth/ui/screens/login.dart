import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/auth/logic/cubit/login_cubit.dart';
import 'package:graduation/features/auth/ui/widgets/email_and_assword.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 4.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Hero(
          tag: "logo",
          child: Padding(
            padding: EdgeInsets.all(80),
            child: SvgPicture.asset(ImgManager.logo, color: ColorsManager.kPrimaryColor, width: 50, height: 50),
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // verticalSpace(20),
                      Text(
                        'تسجيل الدخول',
                        style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
                      ),
                      // verticalSpace(25),
                      Text('كتابة البريد الإلكتروني او رقم الجوال وكلمة المرور', style: TextStyles.font14GraySemiBold),
                      verticalSpace(25),
                      const EmailAndPassword(),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.forgotPassword);
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyles.font12lBlacBold.copyWith(color: ColorsManager.kPrimaryColor),
                          ),
                        ),
                      ),
                      verticalSpace(30),
                      MainButton(
                        text: 'تسجيل الدخول',
                        onTap: () {
                          if (context.read<LoginCubit>().formKey.currentState!.validate()) {
                            context.read<LoginCubit>().register(
                              email: context.read<LoginCubit>().emailController.text,
                              password: context.read<LoginCubit>().passwordController.text,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Padding(
                //   padding: const EdgeInsets.only(left: 120, right: 120),
                //   child: MainButton(
                //     color: ColorsManager.backgroundColorDark,
                //     int: 40,
                //     text: 'الدخول كزائر',
                //     onTap: () {
                //       context.pushNamed(Routes.bottomNavBar);
                //     },
                //   ),
                // ),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
