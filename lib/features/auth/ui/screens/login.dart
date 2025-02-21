import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/auth/logic/cubit/login_cubit.dart';
import 'package:graduation/features/auth/ui/widgets/email_and_assword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    verticalSpace(40),
                    Icon(Icons.car_crash_outlined, size: 100, color: ColorsManager.kPrimaryColor),
                    // const LogoAndLanguage(),
                    verticalSpace(25),
                    Text(
                      'تسجيل الدخول',
                      style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                    verticalSpace(25),
                    Text('مرحبا بكم في تطبيق لاقينها', style: TextStyles.font14GraySemiBold),
                    verticalSpace(25),
                    const EmailAndPassword(),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          // navigateTo(context, const ForgotPassword());
                        },
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyles.font12lBlacBold.copyWith(color: ColorsManager.kPrimaryColor),
                        ),
                      ),
                    ),
                    verticalSpace(30),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: MainButton(
                        text: 'تسجيل الدخول',
                        onTap: () {
                          print(context.read<LoginCubit>().formKey.currentState); // يجب أن لا يكون null
                          print('object');
                          print("formKey state: ${context.read<LoginCubit>().formKey.currentState}");

                          if (context.read<LoginCubit>().formKey.currentState!.validate()) {
                            context.read<LoginCubit>().register(
                              email: context.read<LoginCubit>().emailController.text,
                              password: context.read<LoginCubit>().passwordController.text,
                            );
                          }
                          // validateThenDoLogin(context);
                        },
                      ),
                    ),
                    verticalSpace(20),
                    // const AlreadyHaveAccountText(),
                    verticalSpace(30),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 120, right: 120),
                child: MainButton(
                  color: ColorsManager.backgroundColorDark,
                  int: 40,
                  text: '',
                  onTap: () {
                    // navigateTo(context, const BottomNavBarProvider());
                  },
                ),
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  void validateThenDoLogin(BuildContext context) {}
}
