import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/main_button.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt_outlined, size: 100, color: ColorsManager.kPrimaryColor),
            verticalSpace(12),
            Text('سجل دخولك', style: TextStyles.font30BlackBold),
            Text('لإضافة السيارات إلى المفضلة', style: TextStyles.font12GreyRegular),
            verticalSpace(20),
            MainButton(text: 'سجل دخول؛', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
