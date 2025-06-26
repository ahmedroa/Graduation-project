// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation/core/helpers/app_regex.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/auth/login/logic/cubit/login_cubit.dart';

class EmailAndPassword extends StatefulWidget {
  const EmailAndPassword({super.key});

  @override
  State<EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<EmailAndPassword> {
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
    passwordController = context.read<LoginCubit>().passwordController;
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
      key: context.read<LoginCubit>().formKey,
      child: Column(
        children: [
          // Center(
          //   child: CountryCodePicker(
          //     onChanged: print,
          //     // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
          //     initialSelection: 'IT',
          //     favorite: ['+39', 'FR'],
          //     // optional. Shows only country name and flag
          //     showCountryOnly: false,
          //     // optional. Shows only country name and flag when popup is closed.
          //     showOnlyCountryWhenClosed: false,
          //     // optional. aligns the flag and the Text left
          //     alignLeft: false,
          //   ),
          // ),
          AppTextFormField(
            controller: context.read<LoginCubit>().emailController,
            hintText: 'البريد الإلكتروني',
            validator: (value) {
              if (value == null || value.isEmpty || !AppRegex.isEmailValid(value)) {
                return 'لا يمكن  ترك الحقل فارغ';
              }
              return null;
            },
          ),
          verticalSpace(18),

          AppTextFormField(
            controller: context.read<LoginCubit>().passwordController,
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
              if (value == null || value.isEmpty) {
                return 'لا يمكن  ترك الحقل فارغ';
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
        ],
      ),
    );
  }
}
