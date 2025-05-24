// ignore_for_file: unused_field

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
import 'package:graduation/features/auth/login/logic/cubit/login_cubit.dart';
import 'package:graduation/features/auth/login/logic/cubit/login_state.dart';
import 'package:graduation/features/auth/login/ui/widgets/email_and_assword.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graduation/features/auth/login/ui/widgets/login_bloc_listener.dart';
import 'package:graduation/features/auth/register/ui/widgets/register_bloc_listener.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // أنيميشن لكل عنصر على حدة
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _titleScaleAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Offset> _registerSlideAnimation;

  // أنيميشن لزر الدخول كزائر
  late Animation<double> _guestButtonFadeAnimation;
  late Animation<Offset> _guestButtonSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    // أنيميشن تلاشي عام
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    // أنيميشن انزلاق عام
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.1, 0.6, curve: Curves.easeOutCubic)));

    // أنيميشن للشعار
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)));

    // أنيميشن تكبير للعنوان
    _titleScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack)));

    // أنيميشن للنموذج
    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.4, 0.9, curve: Curves.easeOutCubic)));

    // أنيميشن للزر
    _buttonScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.elasticOut)));

    // أنيميشن لرابط انشاء حساب
    _registerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic)));

    // أنيميشن لزر الدخول كزائر - يظهر في النهاية
    _guestButtonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeIn)));

    _guestButtonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeOutBack)));

    // تشغيل الأنيميشن
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
        title: SlideTransition(
          position: _logoSlideAnimation,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Hero(
                tag: "logo",
                child: SvgPicture.asset(ImgManager.logo, color: ColorsManager.kPrimaryColor, width: 50, height: 50),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ScaleTransition(
                            scale: _titleScaleAnimation,
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyles.font34BlackBold.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _controller.value < 0.3 ? 0 : (_controller.value - 0.3) / 0.7,
                                child: child,
                              );
                            },
                            child: Text(
                              'كتابة البريد الإلكتروني او رقم الجوال وكلمة المرور',
                              style: TextStyles.font14GraySemiBold,
                            ),
                          ),
                          verticalSpace(25),
                          SlideTransition(position: _formSlideAnimation, child: const EmailAndPassword()),
                          verticalSpace(30),
                          SlideTransition(
                            position: _formSlideAnimation,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  // context.pushNamed(Routes.forgotPassword);
                                  setupErrorState(context, 'هذه الميزة غير متاحة حاليا');
                                },
                                child: Text(
                                  'نسيت كلمة المرور؟',
                                  style: TextStyles.font12lBlacBold.copyWith(color: ColorsManager.kPrimaryColor),
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<LoginCubit, LoginState>(
                            builder: (context, state) {
                              final isLoading = state is Loading;

                              if (isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(color: ColorsManager.kPrimaryColor),
                                );
                              }

                              return ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (context.read<LoginCubit>().formKey.currentState!.validate()) {
                                        context.read<LoginCubit>().login(
                                          email: context.read<LoginCubit>().emailController.text,
                                          password: context.read<LoginCubit>().passwordController.text,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorsManager.kPrimaryColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Text(
                                      'تسجيل الدخول',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(20),
                    SlideTransition(
                      position: _registerSlideAnimation,
                      child: Align(
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(Routes.register);
                          },
                          child: Text(
                            'انشاء حساب جديد',
                            style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(20),
                    const LoginBlocListener(),
                    verticalSpace(20),

                    // زر الدخول كزائر
                    FadeTransition(
                      opacity: _guestButtonFadeAnimation,
                      child: SlideTransition(
                        position: _guestButtonSlideAnimation,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 120, right: 120, bottom: 20),
                            child: MainButton(
                              color: ColorsManager.dark,
                              text: 'الدخول كزائر',
                              onTap: () {
                                context.pushNamed(Routes.bottomNavBar);
                              },
                            ),
                            // child: ElevatedButton(
                            //   onPressed: () {
                            //     context.pushNamed(Routes.bottomNavBar);
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: ColorsManager.backgroundColorDark.withOpacity(0.9),
                            //     minimumSize: const Size(double.infinity, 40),
                            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            //     elevation: 2,
                            //   ),
                            //   child: const Text('الدخول كزائر', style: TextStyle(fontSize: 14, color: Colors.white)),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   // final bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 4.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 110,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Hero(
//           tag: "logo",
//           child: Padding(
//             padding: EdgeInsets.all(80),
//             child: SvgPicture.asset(ImgManager.logo, color: ColorsManager.kPrimaryColor, width: 50, height: 50),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       children: [
//                         // verticalSpace(20),
//                         Text(
//                           'تسجيل الدخول',
//                           style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
//                         ),
//                         // verticalSpace(25),
//                         Text(
//                           'كتابة البريد الإلكتروني او رقم الجوال وكلمة المرور',
//                           style: TextStyles.font14GraySemiBold,
//                         ),
//                         verticalSpace(25),
//                         const EmailAndPassword(),
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: TextButton(
//                             onPressed: () {
//                               context.pushNamed(Routes.forgotPassword);
//                             },
//                             child: Text(
//                               'نسيت كلمة المرور؟',
//                               style: TextStyles.font12lBlacBold.copyWith(color: ColorsManager.kPrimaryColor),
//                             ),
//                           ),
//                         ),
//                         BlocBuilder<LoginCubit, LoginState>(
//                           builder: (context, state) {
//                             final isLoading = state is Loading;

//                             if (isLoading) {
//                               return const Center(child: CircularProgressIndicator(color: ColorsManager.kPrimaryColor));
//                             }

//                             return SizedBox(
//                               width: double.infinity,
//                               height: 50.h,

//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   if (context.read<LoginCubit>().formKey.currentState!.validate()) {
//                                     context.read<LoginCubit>().login(
//                                       email: context.read<LoginCubit>().emailController.text,
//                                       password: context.read<LoginCubit>().passwordController.text,
//                                     );
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: ColorsManager.kPrimaryColor,
//                                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                 ),
//                                 child: const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, color: Colors.white)),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   verticalSpace(20),
//                   Align(
//                     child: TextButton(
//                       onPressed: () {
//                         context.pushNamed(Routes.register);
//                       },
//                       child: Text(
//                         'انشاء حساب جديد',
//                         style: TextStyles.font16DarkBold.copyWith(color: ColorsManager.kPrimaryColor),
//                       ),
//                     ),
//                   ),
//                   verticalSpace(20),
//                   LoginBlocListener(),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 120, right: 120),
//                   //   child: MainButton(
//                   //     color: ColorsManager.backgroundColorDark,
//                   //     int: 40,
//                   //     text: 'الدخول كزائر',
//                   //     onTap: () {
//                   //       context.pushNamed(Routes.bottomNavBar);
//                   //     },
//                   //   ),
//                   // ),
//                   verticalSpace(20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
