import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';

class CarOwnerInformation extends StatefulWidget {
  const CarOwnerInformation({super.key});

  @override
  State<CarOwnerInformation> createState() => _CarOwnerInformationState();
}

class _CarOwnerInformationState extends State<CarOwnerInformation> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(20),
            Text('بيانات صاحب المركبه', style: TextStyles.font16BlacMedium),
            verticalSpace(20),
            Text('اضف بيانات صاحب المركبه', style: TextStyles.font12lBlacMediuAm),
            verticalSpace(20),
            Text('اسم صاحب المركبه', style: TextStyles.font14DarkMedium),
            verticalSpace(8),

            AppTextFormField(hintText: 'اكتب الاسم', validator: (v) {}),
            verticalSpace(12),
            Text('رقم الهاتف', style: TextStyles.font14DarkMedium),

            verticalSpace(8),
            AppTextFormField(hintText: 'اكتب رقم الهاتف', validator: (v) {}),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text('يحتوي على واتساب', style: TextStyles.font14DarkMedium),
              ],
            ),

            verticalSpace(8),
            AppTextFormField(hintText: 'اكتب رقم هاتف اخر ', validator: (v) {}),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text('يحتوي على واتساب', style: TextStyles.font14DarkMedium),
              ],
            ),
            verticalSpace(20),
            Align(
              alignment: Alignment.centerLeft,
              child: MainButton(text: 'التالي', onTap: () {}, width: MediaQuery.of(context).size.width / 3),
            ),
          ],
        ),
      ),
    );
  }
}
