import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/img.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 16),
                  SvgPicture.asset(ImgManager.logo),
                  const SizedBox(height: 10),
                  Text('', style: TextStyles.font34BlackBold.copyWith(color: Theme.of(context).colorScheme.secondary)),
                  verticalSpace(25),
                  Text('', style: TextStyles.font14GraySemiBold),
                  verticalSpace(25),
                  AppTextFormField(
                    hintText: '',
                    validator: (value) {
                      if (value == null) {
                        return 'Please enter a valid email';
                      }
                    },
                  ),
                  verticalSpace(60),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: MainButton(text: 'التالي', onTap: () {}),
                  ),
                  const SizedBox(height: 20),
                  // const AlreadyHaveAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
