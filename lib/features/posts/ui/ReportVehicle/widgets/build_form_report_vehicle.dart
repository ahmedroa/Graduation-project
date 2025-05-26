import 'package:flutter/material.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';
import 'package:graduation/features/posts/ui/data/show_car_type_selections_sheet.dart';
import 'package:graduation/features/posts/ui/data/show_selection_sheet.dart';

class BuildFormReportVehicle extends StatelessWidget {
  const BuildFormReportVehicle({super.key, required this.postsCubit});

  final PostsCubit postsCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('اسم السيارة', style: TextStyles.font14DarkMedium),
        verticalSpace(8),
        AppTextFormField(
          hintText: 'ادخل اسم السياره',
          controller: postsCubit.carNameController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
        ),

        verticalSpace(16),
        Text('نوع السيارة', style: TextStyles.font14DarkMedium),
        verticalSpace(8),
        AppTextFormField(
          hintText: "اختر نوع السيارة",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
          controller: postsCubit.carTypeController,
          onTap: () => showCarTypeSelectionSheet(context, postsCubit),
          suffixIcon: Icon(Icons.arrow_drop_down),
          readOnly: true,
        ),

        verticalSpace(16),
        Text('لون السيارة', style: TextStyles.font14DarkMedium),
        verticalSpace(8),
        AppTextFormField(
          hintText: "اختر لون السيارة",
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'لا يمكن ترك الحقل فارغ';
            }
            return null;
          },
          controller: postsCubit.carColorController,
          onTap:
              () =>
                  showSelectionSheet(context, postsCubit.carColors, postsCubit.carColorController, "اختر لون السيارة"),
          suffixIcon: Icon(Icons.arrow_drop_down),
          readOnly: true,
        ),

        verticalSpace(16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: 'رقم الهيكل  ', style: TextStyles.font14DarkMedium),
              TextSpan(text: '( إن وجد )', style: TextStyles.font10GreyRegular),
            ],
          ),
        ),
        verticalSpace(8),
        AppTextFormField(
          hintText: 'ادخل رقم الهيكل',
          controller: postsCubit.chassisNumberController,
          keyboardType: TextInputType.number,

          validator: (value) {
            return null;
          },
        ),
        verticalSpace(16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: 'رقم اللوحة ', style: TextStyles.font14DarkMedium),
              TextSpan(text: '( إن وجد )', style: TextStyles.font10GreyRegular),
            ],
          ),
        ),
        verticalSpace(8),
        AppTextFormField(
          hintText: 'ادخل اللوحة',
          controller: postsCubit.plateNumberController,
          keyboardType: TextInputType.number,

          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }
}
