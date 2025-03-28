import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/features/auth/register/cubit/register_cubit.dart';
import 'package:graduation/features/auth/register/ui/widgets/sign_up_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'تسجيل جديد',
                      style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary),
                    ),
                    Text(
                      'إنشاء حساب برقم الجوال او البريد الإلكتروني وكلمة المرور',
                      style: TextStyles.font14GraySemiBold,
                    ),
                    verticalSpace(25),

                    const SignUpForm(),
                    verticalSpace(20),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        final isLoading = state is Loading;

                        if (isLoading) {
                          return const Center(child: CircularProgressIndicator(color: ColorsManager.kPrimaryColor));
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (context.read<RegisterCubit>().formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                  email: context.read<RegisterCubit>().emailController.text,
                                  password: context.read<RegisterCubit>().passwordController.text,
                                  name: context.read<RegisterCubit>().nameController.text,
                                  phone: context.read<RegisterCubit>().phoneController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.kPrimaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('التالي', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
