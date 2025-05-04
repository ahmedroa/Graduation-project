import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graduation/core/helpers/spacing.dart';
import 'package:graduation/core/theme/colors.dart';
import 'package:graduation/core/theme/text_styles.dart';
import 'package:graduation/core/widgets/app_text_form_field.dart';
import 'package:graduation/core/widgets/main_button.dart';
import 'package:graduation/features/posts/ui/CreatePost/widgets/build%D9%80shimmer_effect.dart';
import 'package:graduation/features/posts/logic/cubit/posts_cubit.dart';

class ReportVehicleLocationInformation extends StatelessWidget {
  const ReportVehicleLocationInformation({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildLocationFields() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الحي', style: TextStyles.font14DarkMedium),
          verticalSpace(8),
          AppTextFormField(
            hintText: 'ادخل اسم الحي',
            validator: (value) {
              if (value!.isEmpty) {
                return 'الحي مطلوب';
              }
              return null;
            },
            controller: context.read<PostsCubit>().neighborhoodController,
          ),
          verticalSpace(12),
          AppTextFormField(
            hintText: 'المدينه',
            validator: (value) {
              if (value!.isEmpty) {
                return 'المدينه مطلوب';
              }
              return null;
            },
            controller: context.read<PostsCubit>().cityController,
          ),
          verticalSpace(12),
          AppTextFormField(
            hintText: 'الشارع',
            validator: (value) {
              if (value!.isEmpty) {
                return 'الشارع مطلوب';
              }
              return null;
            },
            controller: context.read<PostsCubit>().streetController,
          ),
        ],
      );
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text('تحديد الموقع الحالي', style: TextStyles.font14DarkMedium),
                Spacer(),
                MainButton(
                  text: 'تحديد الموقع الحالي',
                  onTap: () => context.read<PostsCubit>().getLocation(),
                  height: 35,
                  width: 145,
                  color: ColorsManager.dark,
                  icon: Icon(Icons.location_on, color: Colors.white),
                ),
              ],
            ),
            verticalSpace(12),
            BlocBuilder<PostsCubit, PostsState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return buildShimmerEffect();
                } else {
                  return buildLocationFields();
                }
              },
            ),
            verticalSpace(24),

            AppTextFormField(
              hintText: 'كتابة تعليق',
              validator: (value) {
                return null;
              },
              maxLines: 3,
            ),
            verticalSpace(70),
            Align(alignment: Alignment.topLeft, child: MainButton(text: 'نشر', onTap: () {}, width: 120)),
          ],
        ),
      ),
    );
  }
}
