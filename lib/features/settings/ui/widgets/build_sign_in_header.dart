import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/extension.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';

class BuildSignInHeader extends StatelessWidget {
  const BuildSignInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            verticalSpace(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الملف الشخصي', style: TextStyles.font20DarkBold),
                  Text(
                    'يرجى تسجيل الدخول للتطبيق لتحديث معلوماتك الشخصية بسهولة وخصوصية.',
                    style: TextStyles.font14GrayMedium,
                  ),
                  verticalSpace(12),
                  MainButton(
                    text: 'سجل دخول',
                    onTap: () {
                     context.pushNamed(Routes.loginScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
