import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('حفظ', style: TextStyles.font16PrimaryColorBold),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        hintText: 'اسمك الاول',
                        validator: (v) {
                          return null;
                        },
                      ),
                    ),
                    horizontalSpace(12),
                    Expanded(
                      child: AppTextFormField(
                        hintText: 'اسمك الاول',
                        validator: (v) {
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                verticalSpace(12),
                AppTextFormField(
                  hintText: 'الايميل',
                  validator: (v) {
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
