import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/app_regex.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/auth/register/cubit/register_cubit.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<RegisterCubit>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasLowercase = AppRegex.hasLowerCase(passwordController.text);
        hasUppercase = AppRegex.hasUpperCase(passwordController.text);
        hasSpecialCharacters = AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
        hasMinLength = AppRegex.hasMinLength(passwordController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<RegisterCubit>().formKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: context.read<RegisterCubit>().nameController,
            hintText: 'الاسم الكامل',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن  ترك الحقل فارغ';
              }
              return null;
            },
          ),
          verticalSpace(12),

          AppTextFormField(
            controller: context.read<RegisterCubit>().emailController,
            hintText: 'البريد الإلكتروني او رقم الجوال',
            validator: (value) {
              if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
                return 'لا يمكن  ترك الحقل فارغ';
              }
              return null;
            },
          ),
          verticalSpace(12),

          AppTextFormField(
            controller: context.read<RegisterCubit>().passwordController,
            hintText: 'كلمة المرور',
            isObscureText: isObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isObscureText = !isObscureText;
                });
              },
              child: Icon(
                isObscureText ? Icons.visibility_off : Icons.visibility,
                color: isObscureText ? Colors.grey : ColorsManager.kPrimaryColor,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty
              // || !AppRegex.isPasswordValid(value)
              ) {
                return 'كلمة المرور يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام ورموز وطول لا يقل عن 8 أحرف';
              }
              return null;
            },

            // validator: (value) {
            //   if (value == null || value.isEmpty || !AppRegex.isPasswordValid(value)) {
            //     return 'كلمة المرور يجب أن تحتوي على حروف كبيرة وصغيرة وأرقام ورموز وطول لا يقل عن 8 أحرف';
            //   }
            //   return null;
            // },
          ),
          verticalSpace(12),
          AppTextFormField(
            controller: context.read<RegisterCubit>().phoneController,
            hintText: 'رقم الجوال',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لا يمكن  ترك الحقل فارغ';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
