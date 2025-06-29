import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/extension.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/routing/app_router.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';

class BuildNotLoggedInView extends StatelessWidget {
  const BuildNotLoggedInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_alt_outlined, size: 100, color: ColorsManager.kPrimaryColor),
          verticalSpace(12),
          Text('سجل دخولك', style: TextStyles.font30BlackBold),
          Text('لإضافة السيارات إلى المفضلة', style: TextStyles.font12GreyRegular),
          verticalSpace(20),
          MainButton(
            text: 'سجل دخولك',
            onTap: () {
              context.pushNamed(Routes.loginScreen);
            },
          ),
          verticalSpace(70),
        ],
      ),
    );
  }
}
