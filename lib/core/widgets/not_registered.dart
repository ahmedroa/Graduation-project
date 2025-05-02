import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';

void notRegistered(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          surfaceTintColor: Colors.white,
          content: Text('يجب عليك تسجيل الدخول أولاً', style: TextStyles.font14DarkMedium, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                context.pushNamed(Routes.loginScreen);
              },
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: MainButton(text: 'سجل', fontSize: 12, onTap: () {}),
                    ),
                    verticalSpace(15),
                  ],
                ),
              ),
            ),
          ],
        ),
  );
}
